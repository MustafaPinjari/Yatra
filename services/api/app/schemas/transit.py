from datetime import datetime
from typing import Any
from pydantic import BaseModel, Field


# ==============================================================================
# GTFS Static Schemas
# ==============================================================================

class AgencyModel(BaseModel):
    agency_id: str
    agency_name: str
    agency_url: str
    agency_timezone: str = "Asia/Kolkata"
    agency_lang: str | None = "en"
    agency_phone: str | None = None


class StopModel(BaseModel):
    stop_id: str
    stop_name: str
    stop_lat: float = Field(ge=-90.0, le=90.0)
    stop_lon: float = Field(ge=-180.0, le=180.0)
    stop_code: str | None = None
    stop_desc: str | None = None
    zone_id: str | None = None
    stop_url: str | None = None
    location_type: int = 0
    parent_station: str | None = None
    wheelchair_boarding: int = 0  # 0: no info, 1: accessible, 2: not accessible
    # YATRA Accessibility extensions
    accessibility_score: float = 75.0
    has_wheelchair_ramp: bool = False
    has_tactile_paving: bool = False
    has_shelter: bool = True
    curb_height_cm: float = 16.0


class RouteModel(BaseModel):
    route_id: str
    route_short_name: str
    route_long_name: str
    route_type: int = 3  # 3 = Bus in GTFS
    agency_id: str | None = None
    route_desc: str | None = None
    route_url: str | None = None
    route_color: str | None = "172653"
    route_text_color: str | None = "FFFFFF"


class TripModel(BaseModel):
    trip_id: str
    route_id: str
    service_id: str
    trip_headsign: str | None = None
    trip_short_name: str | None = None
    direction_id: int | None = None
    block_id: str | None = None
    shape_id: str | None = None
    wheelchair_accessible: int = 0


class StopTimeModel(BaseModel):
    trip_id: str
    arrival_time: str
    departure_time: str
    stop_id: str
    stop_sequence: int
    stop_headsign: str | None = None
    pickup_type: int = 0
    drop_off_type: int = 0
    shape_dist_traveled: float | None = None


class ShapePointModel(BaseModel):
    shape_id: str
    shape_pt_lat: float
    shape_pt_lon: float
    shape_pt_sequence: int
    shape_dist_traveled: float | None = None


class GtfsValidationSummary(BaseModel):
    total_files_found: int = 0
    discovered_files: list[str] = Field(default_factory=list)
    missing_required_files: list[str] = Field(default_factory=list)
    total_agencies: int = 0
    total_stops: int = 0
    total_routes: int = 0
    total_trips: int = 0
    total_stop_times: int = 0
    total_shapes: int = 0
    validation_warnings: list[str] = Field(default_factory=list)
    validation_errors: list[str] = Field(default_factory=list)
    geographic_bounds: dict[str, float] = Field(default_factory=dict)


class GtfsIngestionReport(BaseModel):
    feed_name: str = "Delhi Transport Corporation (DTC) GTFS"
    feed_version: str = "1.0.0"
    source_url_or_path: str
    download_timestamp: str
    import_status: str  # "SUCCESS", "PARTIAL", "FAILED", "EMPTY"
    summary: GtfsValidationSummary
    execution_time_seconds: float = 0.0


# ==============================================================================
# GTFS-Realtime Schemas
# ==============================================================================

class VehiclePositionModel(BaseModel):
    vehicle_id: str
    route_id: str | None = None
    route_short_name: str | None = None
    trip_id: str | None = None
    latitude: float
    longitude: float
    bearing: float | None = None
    speed_kmh: float | None = None
    timestamp: int  # POSIX epoch timestamp
    recorded_at_iso: str
    stop_id: str | None = None
    current_stop_sequence: int | None = None
    current_status: str = "IN_TRANSIT_TO"  # INCOMING_AT, STOPPED_AT, IN_TRANSIT_TO
    occupancy_status: str | None = None
    is_low_floor: bool = True
    ramp_functional: bool = True
    is_stale: bool = False
    freshness_seconds: int = 0


class GtfsRtHealthResponse(BaseModel):
    status: str  # "OPERATIONAL", "STALE_DATA", "API_ERROR", "UNCONFIGURED", "UNAVAILABLE"
    api_endpoint_configured: bool
    api_key_configured: bool
    last_poll_timestamp: str | None = None
    last_successful_poll_timestamp: str | None = None
    last_poll_latency_ms: float = 0.0
    network_latency_ms: float = 0.0
    protobuf_decode_ms: float = 0.0
    total_active_vehicles: int = 0
    fresh_vehicles_count: int = 0
    stale_vehicles_count: int = 0
    active_routes_count: int = 0
    http_status_code: int | None = None
    error_message: str | None = None
    data_provider: str = "Delhi Transport Stack (DTS) GTFS-RT"
