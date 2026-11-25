from fastapi import APIRouter, HTTPException, Query

from app.integrations.gtfs.pipeline import GtfsPipeline
from app.integrations.gtfs.storage import get_transit_repository
from app.schemas.common import ApiResponse
from app.schemas.transit import (
    GtfsIngestionReport,
    RouteModel,
    ShapePointModel,
    StopModel,
    TripModel,
)

router = APIRouter()
pipeline = GtfsPipeline()


@router.get("/gtfs/status", response_model=ApiResponse[dict])
async def get_gtfs_status() -> ApiResponse[dict]:
    """Returns GTFS Static feed metadata, file counts, and validation status."""
    repo = get_transit_repository()
    report = repo.last_ingestion_report

    return ApiResponse(
        success=True,
        data={
            "feedName": "Delhi Transport Corporation (DTC) GTFS",
            "importStatus": report.import_status if report else "LOADED_SAMPLE",
            "downloadTimestamp": report.download_timestamp if report else None,
            "totalStops": len(repo.stops),
            "totalRoutes": len(repo.routes),
            "totalTrips": len(repo.trips),
            "geographicBounds": report.summary.geographic_bounds if report else {
                "min_lat": 28.5175, "max_lat": 28.6675, "min_lon": 77.1820, "max_lon": 77.2410
            },
            "validationWarnings": report.summary.validation_warnings if report else [],
            "validationErrors": report.summary.validation_errors if report else [],
        },
    )


@router.post("/gtfs/ingest", response_model=ApiResponse[GtfsIngestionReport])
async def trigger_gtfs_ingestion(
    source_url: str | None = None,
) -> ApiResponse[GtfsIngestionReport]:
    """Triggers an ingestion of Delhi GTFS Static data from approved URL or local feed."""
    report = await pipeline.ingest_from_url_or_file(source_url=source_url)
    return ApiResponse(success=report.import_status != "FAILED", data=report)


@router.get("/routes", response_model=ApiResponse[list[RouteModel]])
async def list_routes(
    search: str | None = Query(None, description="Search route number or terminal name"),
) -> ApiResponse[list[RouteModel]]:
    """Returns all available bus routes, optionally filtered by keyword."""
    repo = get_transit_repository()
    routes = repo.get_all_routes(search=search)
    return ApiResponse(success=True, data=routes)


@router.get("/routes/{route_id}", response_model=ApiResponse[RouteModel])
async def get_route(route_id: str) -> ApiResponse[RouteModel]:
    """Returns detailed information for a specific route."""
    repo = get_transit_repository()
    route = repo.get_route(route_id)
    if not route:
        raise HTTPException(status_code=404, detail=f"Route '{route_id}' not found")
    return ApiResponse(success=True, data=route)


@router.get("/routes/{route_id}/stops", response_model=ApiResponse[list[StopModel]])
async def get_route_stops(route_id: str) -> ApiResponse[list[StopModel]]:
    """Returns ordered stop sequence along a route."""
    repo = get_transit_repository()
    stops = repo.get_route_stops(route_id)
    return ApiResponse(success=True, data=stops)


@router.get("/routes/{route_id}/shape", response_model=ApiResponse[list[ShapePointModel]])
async def get_route_shape(route_id: str) -> ApiResponse[list[ShapePointModel]]:
    """Returns geographic shape points along a route corridor."""
    repo = get_transit_repository()
    shape_points = repo.get_route_shape(route_id)
    return ApiResponse(success=True, data=shape_points)


@router.get("/stops", response_model=ApiResponse[list[StopModel]])
async def list_stops(
    lat: float | None = Query(None, ge=-90.0, le=90.0, description="Latitude for spatial radius query"),
    lon: float | None = Query(None, ge=-180.0, le=180.0, description="Longitude for spatial radius query"),
    radius_km: float = Query(2.0, ge=0.1, le=50.0, description="Radius in kilometers"),
    search: str | None = Query(None, description="Search stop name"),
    limit: int | None = Query(None, ge=1, le=500, description="Optional maximum number of stops to return"),
) -> ApiResponse[list[StopModel]]:
    """Returns bus stops, optionally filtered by spatial radius or name search."""
    repo = get_transit_repository()
    stops = repo.get_all_stops(lat=lat, lon=lon, radius_km=radius_km, search=search, limit=limit)
    return ApiResponse(success=True, data=stops)


@router.get("/stops/{stop_id}", response_model=ApiResponse[StopModel])
async def get_stop(stop_id: str) -> ApiResponse[StopModel]:
    """Returns detailed stop metadata and accessibility indicators."""
    repo = get_transit_repository()
    stop = repo.get_stop(stop_id)
    if not stop:
        raise HTTPException(status_code=404, detail=f"Stop '{stop_id}' not found")
    return ApiResponse(success=True, data=stop)


@router.get("/trips", response_model=ApiResponse[list[TripModel]])
async def list_trips(
    route_id: str = Query(..., description="Route identifier"),
) -> ApiResponse[list[TripModel]]:
    """Returns scheduled trips for a specific route."""
    repo = get_transit_repository()
    trips = repo.get_trips_for_route(route_id)
    return ApiResponse(success=True, data=trips)
