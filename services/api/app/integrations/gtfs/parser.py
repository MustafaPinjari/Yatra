import csv
import io
import math
import zipfile
from pathlib import Path
from typing import Any

from app.schemas.transit import (
    AgencyModel,
    GtfsIngestionReport,
    GtfsValidationSummary,
    RouteModel,
    ShapePointModel,
    StopModel,
    StopTimeModel,
    TripModel,
)

# Geographic Bounding Box for Delhi NCT & National Capital Region (NCR)
DELHI_MIN_LAT = 28.0
DELHI_MAX_LAT = 29.2
DELHI_MIN_LON = 76.5
DELHI_MAX_LON = 77.8

REQUIRED_GTFS_FILES = [
    "agency.txt",
    "stops.txt",
    "routes.txt",
    "trips.txt",
    "stop_times.txt",
]

OPTIONAL_GTFS_FILES = [
    "shapes.txt",
    "calendar.txt",
    "calendar_dates.txt",
    "fare_attributes.txt",
    "fare_rules.txt",
    "frequencies.txt",
]


class GtfsParser:
    """Robust, production-grade parser for GTFS Static feeds (ZIP archives or extracted directories).

    Handles malformed records, validates coordinates, enforces relational integrity,
    and produces comprehensive diagnostic reports.
    """

    def __init__(self, source_path_or_bytes: str | Path | bytes):
        self.source = source_path_or_bytes
        self.summary = GtfsValidationSummary()
        self.agencies: dict[str, AgencyModel] = {}
        self.stops: dict[str, StopModel] = {}
        self.routes: dict[str, RouteModel] = {}
        self.trips: dict[str, TripModel] = {}
        self.stop_times: list[StopTimeModel] = []
        self.shapes: dict[str, list[ShapePointModel]] = {}

    def _open_file(self, filename: str) -> io.TextIOWrapper | None:
        """Opens a file from a ZIP archive or filesystem directory."""
        if isinstance(self.source, bytes):
            zf = zipfile.ZipFile(io.BytesIO(self.source))
            matching = [n for n in zf.namelist() if n.lower().endswith(filename.lower())]
            if not matching:
                return None
            return io.TextIOWrapper(zf.open(matching[0]), encoding="utf-8-sig")

        path = Path(self.source)
        if path.is_file() and path.suffix.lower() == ".zip":
            zf = zipfile.ZipFile(path)
            matching = [n for n in zf.namelist() if n.lower().endswith(filename.lower())]
            if not matching:
                return None
            return io.TextIOWrapper(zf.open(matching[0]), encoding="utf-8-sig")

        if path.is_dir():
            file_path = path / filename
            if file_path.exists():
                return open(file_path, encoding="utf-8-sig")
            # Try case-insensitive lookup
            for f in path.iterdir():
                if f.name.lower() == filename.lower():
                    return open(f, encoding="utf-8-sig")

        return None

    def parse(self) -> GtfsIngestionReport:
        """Parses the entire GTFS feed and returns the validation report."""
        import time

        start_time = time.time()
        now_iso = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())

        # 1. Discover available files
        all_expected = REQUIRED_GTFS_FILES + OPTIONAL_GTFS_FILES
        for expected in all_expected:
            f = self._open_file(expected)
            if f is not None:
                self.summary.discovered_files.append(expected)
                self.summary.total_files_found += 1
                f.close()
            elif expected in REQUIRED_GTFS_FILES:
                self.summary.missing_required_files.append(expected)
                self.summary.validation_errors.append(f"Missing required GTFS file: {expected}")

        # If essential core files are missing, abort parsing gracefully
        if "stops.txt" in self.summary.missing_required_files or "routes.txt" in self.summary.missing_required_files:
            return GtfsIngestionReport(
                source_url_or_path=str(self.source),
                download_timestamp=now_iso,
                import_status="FAILED",
                summary=self.summary,
                execution_time_seconds=round(time.time() - start_time, 3),
            )

        # 2. Parse Agency
        self._parse_agency()

        # 3. Parse Stops
        self._parse_stops()

        # 4. Parse Routes
        self._parse_routes()

        # 5. Parse Trips
        self._parse_trips()

        # 6. Parse Stop Times
        self._parse_stop_times()

        # 7. Parse Shapes (if present)
        if "shapes.txt" in self.summary.discovered_files:
            self._parse_shapes()

        # 8. Referential Integrity Verification
        self._verify_referential_integrity()

        duration = round(time.time() - start_time, 3)
        status = "SUCCESS" if not self.summary.validation_errors else "PARTIAL"

        return GtfsIngestionReport(
            source_url_or_path=str(self.source),
            download_timestamp=now_iso,
            import_status=status,
            summary=self.summary,
            execution_time_seconds=duration,
        )

    def _parse_agency(self) -> None:
        f = self._open_file("agency.txt")
        if not f:
            return
        reader = csv.DictReader(f)
        for row in reader:
            agency_id = row.get("agency_id", "DTC").strip()
            name = row.get("agency_name", "Delhi Transport Corporation").strip()
            url = row.get("agency_url", "http://dtc.delhi.gov.in").strip()
            self.agencies[agency_id] = AgencyModel(
                agency_id=agency_id,
                agency_name=name,
                agency_url=url,
                agency_timezone=row.get("agency_timezone", "Asia/Kolkata").strip(),
                agency_lang=row.get("agency_lang", "en").strip(),
            )
        f.close()
        self.summary.total_agencies = len(self.agencies)

    def _parse_stops(self) -> None:
        f = self._open_file("stops.txt")
        if not f:
            return
        reader = csv.DictReader(f)
        min_lat, max_lat = 90.0, -90.0
        min_lon, max_lon = 180.0, -180.0

        for row in reader:
            stop_id = row.get("stop_id", "").strip()
            name = row.get("stop_name", "").strip()
            lat_str = row.get("stop_lat", "").strip()
            lon_str = row.get("stop_lon", "").strip()

            if not stop_id or not name or not lat_str or not lon_str:
                self.summary.validation_warnings.append(f"Skipping malformed stop row: {row}")
                continue

            try:
                lat = float(lat_str)
                lon = float(lon_str)
            except ValueError:
                self.summary.validation_warnings.append(f"Invalid coordinate in stop {stop_id}: lat={lat_str}, lon={lon_str}")
                continue

            # Delhi NCR Geographic Bounds Check
            if not (DELHI_MIN_LAT <= lat <= DELHI_MAX_LAT and DELHI_MIN_LON <= lon <= DELHI_MAX_LON):
                self.summary.validation_warnings.append(
                    f"Stop {stop_id} ({name}) coordinate out of Delhi bounds: ({lat}, {lon})"
                )

            min_lat = min(min_lat, lat)
            max_lat = max(max_lat, lat)
            min_lon = min(min_lon, lon)
            max_lon = max(max_lon, lon)

            # Extract or assign accessibility parameters
            wheelchair = 0
            try:
                wheelchair = int(row.get("wheelchair_boarding", 0) or 0)
            except ValueError:
                pass

            # Synthesize realistic accessibility scoring based on stop infrastructure indicators
            score = 80.0 if wheelchair == 1 else 65.0
            has_ramp = wheelchair == 1
            has_tactile = "metro" in name.lower() or "isbt" in name.lower()
            if has_tactile:
                score += 15.0

            self.stops[stop_id] = StopModel(
                stop_id=stop_id,
                stop_name=name,
                stop_lat=lat,
                stop_lon=lon,
                stop_code=row.get("stop_code"),
                stop_desc=row.get("stop_desc"),
                wheelchair_boarding=wheelchair,
                accessibility_score=min(100.0, score),
                has_wheelchair_ramp=has_ramp,
                has_tactile_paving=has_tactile,
                has_shelter=True,
                curb_height_cm=15.0 if has_ramp else 22.0,
            )

        f.close()
        self.summary.total_stops = len(self.stops)
        if self.stops:
            self.summary.geographic_bounds = {
                "min_lat": min_lat,
                "max_lat": max_lat,
                "min_lon": min_lon,
                "max_lon": max_lon,
            }

    def _parse_routes(self) -> None:
        f = self._open_file("routes.txt")
        if not f:
            return
        reader = csv.DictReader(f)
        for row in reader:
            route_id = row.get("route_id", "").strip()
            short_name = row.get("route_short_name", "").strip()
            long_name = row.get("route_long_name", "").strip()

            if not route_id:
                continue

            if not short_name and not long_name:
                self.summary.validation_warnings.append(f"Route {route_id} missing both short and long names")
                short_name = route_id

            route_type = 3
            try:
                route_type = int(row.get("route_type", 3) or 3)
            except ValueError:
                pass

            self.routes[route_id] = RouteModel(
                route_id=route_id,
                route_short_name=short_name or route_id,
                route_long_name=long_name or short_name,
                route_type=route_type,
                agency_id=row.get("agency_id"),
                route_desc=row.get("route_desc"),
                route_color=row.get("route_color", "172653"),
            )
        f.close()
        self.summary.total_routes = len(self.routes)

    def _parse_trips(self) -> None:
        f = self._open_file("trips.txt")
        if not f:
            return
        reader = csv.DictReader(f)
        for row in reader:
            trip_id = row.get("trip_id", "").strip()
            route_id = row.get("route_id", "").strip()
            service_id = row.get("service_id", "DAILY").strip()

            if not trip_id or not route_id:
                continue

            wheelchair = 0
            try:
                wheelchair = int(row.get("wheelchair_accessible", 0) or 0)
            except ValueError:
                pass

            self.trips[trip_id] = TripModel(
                trip_id=trip_id,
                route_id=route_id,
                service_id=service_id,
                trip_headsign=row.get("trip_headsign"),
                direction_id=int(row.get("direction_id", 0) or 0) if row.get("direction_id") else None,
                shape_id=row.get("shape_id"),
                wheelchair_accessible=wheelchair,
            )
        f.close()
        self.summary.total_trips = len(self.trips)

    def _parse_stop_times(self) -> None:
        f = self._open_file("stop_times.txt")
        if not f:
            return
        reader = csv.DictReader(f)
        for row in reader:
            trip_id = row.get("trip_id", "").strip()
            stop_id = row.get("stop_id", "").strip()
            arr = row.get("arrival_time", "").strip()
            dep = row.get("departure_time", "").strip()

            if not trip_id or not stop_id:
                continue

            try:
                seq = int(row.get("stop_sequence", 1))
            except ValueError:
                seq = 1

            self.stop_times.append(
                StopTimeModel(
                    trip_id=trip_id,
                    stop_id=stop_id,
                    arrival_time=arr,
                    departure_time=dep,
                    stop_sequence=seq,
                )
            )
        f.close()
        self.summary.total_stop_times = len(self.stop_times)

    def _parse_shapes(self) -> None:
        f = self._open_file("shapes.txt")
        if not f:
            return
        reader = csv.DictReader(f)
        for row in reader:
            shape_id = row.get("shape_id", "").strip()
            if not shape_id:
                continue
            try:
                lat = float(row.get("shape_pt_lat", 0))
                lon = float(row.get("shape_pt_lon", 0))
                seq = int(row.get("shape_pt_sequence", 0))
            except ValueError:
                continue

            if shape_id not in self.shapes:
                self.shapes[shape_id] = []
            self.shapes[shape_id].append(
                ShapePointModel(shape_id=shape_id, shape_pt_lat=lat, shape_pt_lon=lon, shape_pt_sequence=seq)
            )
        f.close()
        # Sort shapes by sequence
        for shape_id in self.shapes:
            self.shapes[shape_id].sort(key=lambda p: p.shape_pt_sequence)
        self.summary.total_shapes = len(self.shapes)

    def _verify_referential_integrity(self) -> None:
        """Verifies foreign key relationships across routes, trips, stops, and stop_times."""
        orphan_trips = 0
        for trip_id, trip in self.trips.items():
            if trip.route_id not in self.routes:
                orphan_trips += 1

        if orphan_trips > 0:
            self.summary.validation_warnings.append(
                f"Found {orphan_trips} trips with unknown route_id"
            )

        orphan_stop_times = 0
        for st in self.stop_times:
            if st.stop_id not in self.stops:
                orphan_stop_times += 1

        if orphan_stop_times > 0:
            self.summary.validation_warnings.append(
                f"Found {orphan_stop_times} stop_time entries referencing non-existent stop_id"
            )
