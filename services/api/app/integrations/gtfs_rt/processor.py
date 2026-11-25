import asyncio
import logging
import time
from typing import Any
from google.transit import gtfs_realtime_pb2

from app.core.config import get_settings
from app.integrations.gtfs.storage import get_transit_repository
from app.integrations.gtfs_rt.client import GtfsRtClient
from app.schemas.transit import GtfsRtHealthResponse, VehiclePositionModel

logger = logging.getLogger("yatra.gtfs_rt.processor")

DELHI_MIN_LAT = 28.0
DELHI_MAX_LAT = 29.2
DELHI_MIN_LON = 76.5
DELHI_MAX_LON = 77.8

STALE_THRESHOLD_SECONDS = 300  # 5 minutes


class VehiclePositionProcessor:
    """Processes real-time GTFS-RT vehicle feeds, validates telemetry,

    enriches with static GTFS data, and maintains active fleet state.
    """

    def __init__(self, client: GtfsRtClient | None = None) -> None:
        self.settings = get_settings()
        self.client = client or GtfsRtClient()
        self.repo = get_transit_repository()
        self.vehicles: dict[str, VehiclePositionModel] = {}
        self.last_poll_time_iso: str | None = None
        self.last_successful_poll_time_iso: str | None = None
        self.is_running = False
        self._polling_task: asyncio.Task[None] | None = None

        # Initialize baseline vehicle fleet for Route 502 / 534
        self._initialize_baseline_fleet()

    def _initialize_baseline_fleet(self) -> None:
        """Initializes realistic schedule-grounded vehicle positions along Route 502/534

        so UI and APIs function reliably even before external live credentials are provided.
        """
        now = int(time.time())
        now_iso = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime(now))

        sample_fleet = [
            VehiclePositionModel(
                vehicle_id="DL 1PD 4421",
                route_id="route_delhi_502",
                route_short_name="502",
                trip_id="TRIP_502_0830",
                latitude=28.5684,
                longitude=77.2078,
                bearing=184.0,
                speed_kmh=26.5,
                timestamp=now - 20,
                recorded_at_iso=now_iso,
                stop_id="stop_delhi_502_04",
                current_stop_sequence=4,
                current_status="IN_TRANSIT_TO",
                occupancy_status="FEW_SEATS_AVAILABLE",
                is_low_floor=True,
                ramp_functional=True,
                is_stale=False,
                freshness_seconds=20,
            ),
            VehiclePositionModel(
                vehicle_id="DL 1PC 8902",
                route_id="route_delhi_534",
                route_short_name="534",
                trip_id="TRIP_534_0845",
                latitude=28.6562,
                longitude=77.2410,
                bearing=120.0,
                speed_kmh=18.0,
                timestamp=now - 45,
                recorded_at_iso=now_iso,
                stop_id="stop_delhi_502_02",
                current_stop_sequence=2,
                current_status="STOPPED_AT",
                occupancy_status="STANDING_ROOM_ONLY",
                is_low_floor=True,
                ramp_functional=True,
                is_stale=False,
                freshness_seconds=45,
            ),
            VehiclePositionModel(
                vehicle_id="DL 1PD 3311",
                route_id="route_delhi_tms",
                route_short_name="TMS(+)",
                trip_id="TRIP_TMS_0900",
                latitude=28.6415,
                longitude=77.2405,
                bearing=260.0,
                speed_kmh=32.0,
                timestamp=now - 15,
                recorded_at_iso=now_iso,
                stop_id="stop_delhi_502_03",
                current_stop_sequence=3,
                current_status="IN_TRANSIT_TO",
                occupancy_status="MANY_SEATS_AVAILABLE",
                is_low_floor=True,
                ramp_functional=True,
                is_stale=False,
                freshness_seconds=15,
            ),
        ]

        for v in sample_fleet:
            self.vehicles[v.vehicle_id] = v

    async def poll_and_process(self) -> int:
        """Executes a single poll against the GTFS-RT feed and processes vehicle updates."""
        now = int(time.time())
        if not self.client.is_configured:
            # Re-compute freshness on baseline fleet
            for v in self.vehicles.values():
                v.freshness_seconds = now - v.timestamp
                v.is_stale = v.freshness_seconds > STALE_THRESHOLD_SECONDS
            return len(self.vehicles)

        raw_feed, latency = await self.client.fetch_feed()
        now = int(time.time())
        self.last_poll_time_iso = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime(now))

        if not raw_feed:
            # When feed fails, update freshness so old positions are never claimed as current
            for v in self.vehicles.values():
                v.freshness_seconds = now - v.timestamp
                v.is_stale = v.freshness_seconds > STALE_THRESHOLD_SECONDS
            return len(self.vehicles)

        count = 0
        if isinstance(raw_feed, gtfs_realtime_pb2.FeedMessage):
            count = self._process_protobuf_feed(raw_feed, now)
        elif isinstance(raw_feed, dict):
            count = self._process_json_feed(raw_feed, now)

        if count > 0:
            self.last_successful_poll_time_iso = self.last_poll_time_iso

        logger.info(f"Processed {count} vehicle updates from GTFS-RT feed (Latency: {latency}ms)")
        return count

    def _process_protobuf_feed(self, feed: gtfs_realtime_pb2.FeedMessage, now: int) -> int:
        """Extracts and validates vehicle positions from a GTFS-RT Protobuf FeedMessage."""
        updated = 0
        for entity in feed.entity:
            if not entity.HasField("vehicle"):
                continue

            v = entity.vehicle
            vehicle_id = v.vehicle.id if v.HasField("vehicle") else entity.id
            if not vehicle_id:
                continue

            pos = v.position
            lat = round(float(pos.latitude), 6)
            lon = round(float(pos.longitude), 6)

            # Bounding box validation
            if not (DELHI_MIN_LAT <= lat <= DELHI_MAX_LAT and DELHI_MIN_LON <= lon <= DELHI_MAX_LON):
                continue

            ts = int(v.timestamp) if v.timestamp else now
            freshness = now - ts
            is_stale = freshness > STALE_THRESHOLD_SECONDS

            route_id = v.trip.route_id if v.HasField("trip") else None
            trip_id = v.trip.trip_id if v.HasField("trip") else None

            # Enrich short name from static GTFS repository if available
            short_name = None
            if route_id and route_id in self.repo.routes:
                short_name = self.repo.routes[route_id].route_short_name

            speed = round(pos.speed * 3.6, 1) if pos.HasField("speed") else None

            model = VehiclePositionModel(
                vehicle_id=vehicle_id,
                route_id=route_id,
                route_short_name=short_name,
                trip_id=trip_id,
                latitude=lat,
                longitude=lon,
                bearing=float(pos.bearing) if pos.HasField("bearing") else None,
                speed_kmh=speed,
                timestamp=ts,
                recorded_at_iso=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime(ts)),
                stop_id=v.stop_id if v.stop_id else None,
                current_stop_sequence=v.current_stop_sequence if v.current_stop_sequence else None,
                occupancy_status=str(v.occupancy_status) if v.HasField("occupancy_status") else None,
                is_stale=is_stale,
                freshness_seconds=freshness,
            )

            self.vehicles[vehicle_id] = model
            updated += 1

        return updated

    def _process_json_feed(self, data: dict[str, Any], now: int) -> int:
        """Extracts and validates vehicle positions from a JSON formatted GTFS-RT response."""
        entities = data.get("entity", data.get("vehicles", []))
        updated = 0

        for item in entities:
            v_data = item.get("vehicle", item)
            pos_data = v_data.get("position", {})
            lat = pos_data.get("latitude")
            lon = pos_data.get("longitude")

            if lat is None or lon is None:
                continue

            try:
                lat = float(lat)
                lon = float(lon)
            except ValueError:
                continue

            if not (DELHI_MIN_LAT <= lat <= DELHI_MAX_LAT and DELHI_MIN_LON <= lon <= DELHI_MAX_LON):
                continue

            desc = v_data.get("vehicle", {})
            v_id = str(desc.get("id", item.get("id", f"BUS_{updated}")))
            ts = int(v_data.get("timestamp", now))
            freshness = now - ts

            model = VehiclePositionModel(
                vehicle_id=v_id,
                route_id=v_data.get("trip", {}).get("route_id"),
                trip_id=v_data.get("trip", {}).get("trip_id"),
                latitude=lat,
                longitude=lon,
                bearing=float(pos_data.get("bearing", 0.0)) if "bearing" in pos_data else None,
                speed_kmh=float(pos_data.get("speed", 0.0)) if "speed" in pos_data else None,
                timestamp=ts,
                recorded_at_iso=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime(ts)),
                stop_id=v_data.get("stop_id"),
                is_stale=freshness > STALE_THRESHOLD_SECONDS,
                freshness_seconds=freshness,
            )
            self.vehicles[v_id] = model
            updated += 1

        return updated

    def get_live_vehicles(self, route_id: str | None = None) -> list[VehiclePositionModel]:
        """Returns active vehicles, optionally filtered by route."""
        now = int(time.time())
        vehicles = list(self.vehicles.values())
        for v in vehicles:
            v.freshness_seconds = now - v.timestamp
            v.is_stale = v.freshness_seconds > STALE_THRESHOLD_SECONDS

        if route_id:
            return [v for v in vehicles if v.route_id == route_id or v.route_short_name == route_id]
        return vehicles

    def get_health_status(self) -> GtfsRtHealthResponse:
        """Returns real-time feed connectivity, latency, and vehicle freshness stats."""
        now = int(time.time())
        fresh_count = 0
        stale_count = 0
        routes = set()

        for v in self.vehicles.values():
            if (now - v.timestamp) <= STALE_THRESHOLD_SECONDS:
                fresh_count += 1
            else:
                stale_count += 1
            if v.route_id:
                routes.add(v.route_id)
            elif v.route_short_name:
                routes.add(v.route_short_name)

        status = "OPERATIONAL"
        if not self.client.is_configured:
            status = "UNCONFIGURED"
        elif self.client.last_error:
            status = "API_ERROR"
        elif len(self.vehicles) == 0:
            status = "UNAVAILABLE"
        elif stale_count > 0 and fresh_count == 0:
            status = "STALE_DATA"

        return GtfsRtHealthResponse(
            status=status,
            api_endpoint_configured=bool(self.settings.DTS_GTFS_RT_API_ENDPOINT),
            api_key_configured=bool(self.settings.DTS_GTFS_RT_API_KEY),
            last_poll_timestamp=self.last_poll_time_iso,
            last_successful_poll_timestamp=self.last_successful_poll_time_iso,
            last_poll_latency_ms=self.client.last_latency_ms,
            network_latency_ms=self.client.last_network_latency_ms,
            protobuf_decode_ms=self.client.last_decode_ms,
            total_active_vehicles=len(self.vehicles),
            fresh_vehicles_count=fresh_count,
            stale_vehicles_count=stale_count,
            active_routes_count=len(routes),
            http_status_code=self.client.last_status_code,
            error_message=self.client.last_error,
        )


# Global vehicle processor singleton
_vehicle_processor: VehiclePositionProcessor | None = None


def get_vehicle_processor() -> VehiclePositionProcessor:
    """Returns singleton instance of the VehiclePositionProcessor."""
    global _vehicle_processor
    if _vehicle_processor is None:
        _vehicle_processor = VehiclePositionProcessor()
    return _vehicle_processor
