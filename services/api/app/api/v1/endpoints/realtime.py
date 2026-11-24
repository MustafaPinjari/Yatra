from fastapi import APIRouter, Query

from app.integrations.gtfs_rt.processor import get_vehicle_processor
from app.schemas.common import ApiResponse
from app.schemas.transit import GtfsRtHealthResponse, VehiclePositionModel

router = APIRouter()


@router.get("/realtime/vehicles", response_model=ApiResponse[list[VehiclePositionModel]])
async def get_live_vehicles(
    route_id: str | None = Query(None, description="Filter vehicles by route identifier or short name"),
) -> ApiResponse[list[VehiclePositionModel]]:
    """Returns real-time vehicle positions from Delhi Transport Stack GTFS-RT feed."""
    processor = get_vehicle_processor()
    vehicles = processor.get_live_vehicles(route_id=route_id)
    return ApiResponse(success=True, data=vehicles)


@router.get("/realtime/health", response_model=ApiResponse[GtfsRtHealthResponse])
async def get_realtime_feed_health() -> ApiResponse[GtfsRtHealthResponse]:
    """Returns GTFS-RT connection health, latency, last poll timestamp, and vehicle freshness stats."""
    processor = get_vehicle_processor()
    health = processor.get_health_status()
    return ApiResponse(success=health.status in ("OPERATIONAL", "UNCONFIGURED"), data=health)


@router.post("/realtime/poll", response_model=ApiResponse[dict])
async def trigger_realtime_poll() -> ApiResponse[dict]:
    """Triggers an immediate poll of the live GTFS-RT feed."""
    processor = get_vehicle_processor()
    updated_count = await processor.poll_and_process()
    return ApiResponse(
        success=True,
        data={
            "updatedVehiclesCount": updated_count,
            "health": processor.get_health_status().model_dump(),
        },
    )


@router.get("/operator/fleet/live", response_model=ApiResponse[list[dict]])
async def get_operator_fleet_live() -> ApiResponse[list[dict]]:
    """Returns fleet telemetry structured to match the operator web dashboard contract."""
    processor = get_vehicle_processor()
    vehicles = processor.get_live_vehicles()

    telemetry_list = []
    for v in vehicles:
        telemetry_list.append({
            "vehicleId": v.vehicle_id,
            "registrationNumber": v.vehicle_id,
            "routeId": v.route_id or "502",
            "routeShortName": v.route_short_name or "502",
            "coordinates": {
                "latitude": v.latitude,
                "longitude": v.longitude,
            },
            "speedKmh": v.speed_kmh or 0.0,
            "bearing": v.bearing or 0.0,
            "crowdingTier": "LOW" if v.occupancy_status == "MANY_SEATS_AVAILABLE" else "MEDIUM",
            "occupancyPercentage": 45.0 if v.occupancy_status == "MANY_SEATS_AVAILABLE" else 68.0,
            "isLowFloor": v.is_low_floor,
            "hasOperationalRamp": v.ramp_functional,
            "isStale": v.is_stale,
            "freshnessSeconds": v.freshness_seconds,
            "lastUpdated": v.recorded_at_iso,
        })

    return ApiResponse(success=True, data=telemetry_list)
