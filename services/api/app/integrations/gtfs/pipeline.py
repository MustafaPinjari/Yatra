import json
import logging
from pathlib import Path
from typing import Any
import httpx

from app.core.config import get_settings
from app.integrations.gtfs.parser import GtfsParser
from app.integrations.gtfs.storage import get_transit_repository
from app.schemas.transit import GtfsIngestionReport

logger = logging.getLogger("yatra.gtfs.pipeline")


class GtfsPipeline:
    """Orchestrates static GTFS data ingestion, parsing, validation, and storage."""

    def __init__(self) -> None:
        self.settings = get_settings()
        self.repo = get_transit_repository()

    async def ingest_from_url_or_file(
        self,
        source_url: str | None = None,
        local_file_or_dir: Path | None = None,
    ) -> GtfsIngestionReport:
        """Downloads or reads a GTFS feed, executes parsing and validation, and updates the repository."""
        target_source: str | Path | bytes | None = None

        # 1. Check explicit local file/directory
        if local_file_or_dir and local_file_or_dir.exists():
            target_source = local_file_or_dir

        # 2. Check source URL
        elif source_url or self.settings.DTS_GTFS_STATIC_URL:
            url = source_url or self.settings.DTS_GTFS_STATIC_URL
            logger.info("Downloading official Delhi GTFS Static feed from URL")
            try:
                async with httpx.AsyncClient(timeout=60.0, follow_redirects=True) as client:
                    resp = await client.get(url)
                    resp.raise_for_status()
                    target_source = resp.content

                    # Save raw archive copy for repeatability
                    raw_dir = Path(self.settings.DATA_DIR) / "raw"
                    raw_dir.mkdir(parents=True, exist_ok=True)
                    raw_save_path = raw_dir / "delhi_gtfs_latest.zip"
                    with open(raw_save_path, "wb") as f:
                        f.write(resp.content)
            except Exception as e:
                logger.error(f"Failed to download GTFS feed from URL: {e}")
                return GtfsIngestionReport(
                    source_url_or_path=url,
                    download_timestamp=str(Path.cwd()),
                    import_status="FAILED",
                    summary=GtfsParser("").summary,
                    execution_time_seconds=0.0,
                )

        # 3. Check default data directory for local GTFS files
        if not target_source:
            default_gtfs_dir = Path(self.settings.GTFS_DIR)
            raw_gtfs_zip = Path(self.settings.DATA_DIR) / "raw" / "delhi_gtfs_latest.zip"

            if raw_gtfs_zip.exists():
                target_source = raw_gtfs_zip
            elif default_gtfs_dir.exists() and any(default_gtfs_dir.iterdir()):
                target_source = default_gtfs_dir

        if not target_source:
            logger.warning("No GTFS source found. Using pre-loaded sample dataset.")
            return GtfsIngestionReport(
                source_url_or_path="data/sample",
                download_timestamp="",
                import_status="EMPTY",
                summary=GtfsParser("").summary,
                execution_time_seconds=0.0,
            )

        # Execute parser
        parser = GtfsParser(target_source)
        report = parser.parse()

        # Update repository
        if report.import_status in ("SUCCESS", "PARTIAL"):
            self.repo.update_from_parser(parser, report)
            logger.info(
                f"GTFS Ingestion complete: {len(self.repo.stops)} stops, "
                f"{len(self.repo.routes)} routes, {len(self.repo.trips)} trips."
            )

            # Persist ingestion report for audit trail
            report_dir = Path(self.settings.DATA_DIR) / "processed"
            report_dir.mkdir(parents=True, exist_ok=True)
            report_path = report_dir / "gtfs_ingestion_report.json"
            try:
                with open(report_path, "w", encoding="utf-8") as f:
                    f.write(report.model_dump_json(indent=2))
            except Exception as e:
                logger.warning(f"Could not write ingestion report to disk: {e}")

        return report
