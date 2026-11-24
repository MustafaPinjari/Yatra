from typing import Any
from fastapi import APIRouter, HTTPException, Query

from app.engines.crowding_engine import CrowdingEngine
from app.engines.feeder_optimizer import FeederOptimizerEngine
from app.engines.journey_planner import RaptorJourneyPlanner
from app.engines.od_engine import OdMatrixEngine
from app.engines.segment_load_engine import SegmentLoadEngine
from app.schemas.analytics import (
    CrowdingEstimateResponse,
    FeederEvEnergyResponse,
    FeederOptimizationResponse,
    FeederSensitivityResponse,
    JourneyPlanRequest,
    JourneyPlanResponse,
    MetroCorridorLoadResponse,
    ModelValidationReport,
    OdMatrixResponse,
    OdSensitivityResponse,
    RoadWidthCheckResponse,
    SegmentLoadResponse,
)

router = APIRouter(prefix="/analytics", tags=["Transit Intelligence & Analytics"])

# Engine singletons
planner = RaptorJourneyPlanner()
crowding_engine = CrowdingEngine()
od_engine = OdMatrixEngine()
feeder_engine = FeederOptimizerEngine()
segment_load_engine = SegmentLoadEngine()


# ==============================================================================
# Problem 1 & 2: Journey Planning & Crowding-Aware Routing
# ==============================================================================

@router.post("/journey/plan", response_model=JourneyPlanResponse, tags=["Journey Planner"])
def plan_multimodal_journey(request: JourneyPlanRequest) -> Any:
    """Plans multimodal transit journeys across Delhi NCT using the RAPTOR algorithm,

    incorporating bus dwell-time delays, traffic congestion factors,
    accessibility scores, and relative crowding ranking.
    """
    result = planner.plan_multimodal_journey(
        origin_lat=request.origin_lat,
        origin_lon=request.origin_lon,
        dest_lat=request.destination_lat,
        dest_lon=request.destination_lon,
        departure_hour=request.departure_hour,
        max_walk_meters=request.max_walking_distance_meters,
        wheelchair_only=request.wheelchair_accessible_only,
        objective=request.objective,
    )
    return result


@router.get("/crowding", response_model=CrowdingEstimateResponse)
def get_route_crowding_estimate(
    route_id: str = Query(..., description="GTFS route ID (e.g. 'route_delhi_502')"),
    hour: float = Query(default=9.0, ge=0.0, le=24.0, description="Hour of the day"),
) -> Any:
    """Problem 2: Calculates Relative Crowding Index (RCI), bus bunching headway deviation,

    and comfort index derived from empirical ETM and GTFS-RT telemetry.
    """
    result = crowding_engine.estimate_route_crowding(route_id=route_id, hour=hour)
    return result


# ==============================================================================
# Problem 3: Origin-Destination Matrix (Furness IPF)
# ==============================================================================

@router.get("/od-matrix", response_model=OdMatrixResponse)
def get_origin_destination_matrix(
    time_period: str = Query(default="AM_PEAK", description="Time period: AM_PEAK, PM_PEAK, or OFF_PEAK"),
    max_iterations: int = Query(default=20, ge=1, le=100),
    tolerance: float = Query(default=0.005, ge=0.0001, le=0.05),
) -> Any:
    """Problem 3: Calculates balanced Delhi NCT Origin-Destination trip matrix

    using Biproportional Fitting (Iterative Proportional Fitting / Furness Algorithm)
    and distance impedance gravity decay.
    """
    result = od_engine.compute_biproportional_od_matrix(
        time_period=time_period,
        max_iterations=max_iterations,
        convergence_tolerance=tolerance,
    )
    return result


@router.get("/od-desire-lines")
def get_od_desire_lines_geojson(
    time_period: str = Query(default="AM_PEAK", description="Time period: AM_PEAK, PM_PEAK, or OFF_PEAK"),
    min_trips_threshold: int = Query(default=1000, description="Minimum trip volume to render line"),
) -> Any:
    """Exports RFC 7946 GeoJSON desire lines between Delhi Transit Analysis Zones (TAZ)."""
    return od_engine.export_desire_lines_geojson(
        time_period=time_period,
        min_trips_threshold=min_trips_threshold,
    )


@router.get("/od-sensitivity", response_model=OdSensitivityResponse)
def get_od_friction_sensitivity(
    time_period: str = Query(default="AM_PEAK", description="Time period: AM_PEAK, PM_PEAK, or OFF_PEAK"),
) -> Any:
    """Problem 3: Sensitivity analysis for varying distance friction coefficients (gamma: 0.04, 0.08, 0.12)."""
    gammas = [0.04, 0.08, 0.12]
    runs = od_engine.evaluate_gamma_sensitivity(time_period=time_period, gammas=gammas)
    return {
        "time_period": time_period,
        "tested_gammas": gammas,
        "sensitivity_runs": runs,
    }


# ==============================================================================
# Problem 4: Metro Feeder Route & Fleet Optimizer
# ==============================================================================

@router.get("/feeder-routes", response_model=FeederOptimizationResponse)
def get_optimized_metro_feeder_routes(
    metro_station_id: str | None = Query(default=None, description="Optional metro station ID filter"),
    max_fleet: int = Query(default=500, le=500, description="Total EV bus fleet budget constraint (strictly <= 500)"),
) -> Any:
    """Problem 4: Generates optimized last-mile feeder routes connecting to Delhi Metro hubs.

    Enforces:
    - Carriageway road width >= 6.0m
    - Route length <= 7.0 km
    - Total electric bus fleet <= 500
    - Headways between 8 and 12 minutes
    """
    if max_fleet > 500:
        raise HTTPException(
            status_code=400,
            detail="Regulatory fleet constraint violation: Total feeder fleet budget cannot exceed 500 electric buses.",
        )
    return feeder_engine.optimize_network_feeder_fleet(max_total_fleet=max_fleet)


@router.get("/feeder-routes/geojson")
def get_feeder_routes_geojson() -> Any:
    """Exports all optimized Delhi Metro feeder routes as GeoJSON FeatureCollection."""
    return feeder_engine.export_feeder_routes_geojson()


@router.get("/feeder-routes/check-road", response_model=RoadWidthCheckResponse)
def check_road_carriageway_width(
    u: str = Query(..., description="From road node identifier"),
    v: str = Query(..., description="To road node identifier"),
) -> Any:
    """Validates whether a specific road segment meets the >= 6.0m carriageway width requirement for bus transit."""
    return feeder_engine.check_road_width_eligibility(u=u, v=v)


@router.get("/feeder-sensitivity", response_model=FeederSensitivityResponse)
def get_feeder_fleet_headway_sensitivity(
    max_fleet: int = Query(default=500, le=500, description="Total EV bus fleet budget constraint"),
) -> Any:
    """Problem 4: Evaluates required electric feeder fleet sizes across headways (6, 8, 10, 12, 15 min)."""
    headways = [6.0, 8.0, 10.0, 12.0, 15.0]
    runs = feeder_engine.evaluate_fleet_headway_sensitivity(headways=headways, max_fleet=max_fleet)
    return {
        "fleet_cap": max_fleet,
        "tested_headways": headways,
        "sensitivity_runs": runs,
    }


@router.get("/feeder-ev-energy", response_model=FeederEvEnergyResponse)
def get_feeder_ev_energy_model(
    route_id: str | None = Query(default=None, description="Optional feeder route ID"),
    daily_trips: int = Query(default=16, ge=1, le=40, description="Scheduled daily feeder round trips"),
) -> Any:
    """Problem 4: Calculates 180 kWh battery EV consumption (1.15 kWh/km) and 60 kW depot charging schedules."""
    return feeder_engine.compute_feeder_ev_energy_model(route_id=route_id, daily_trips=daily_trips)


# ==============================================================================
# Problem 5: Segment-Level Load Engine & Bottlenecks
# ==============================================================================

@router.get("/segment-loads", response_model=SegmentLoadResponse)
def get_route_segment_loads(
    route_id: str = Query(..., description="Route ID to analyze (e.g. 'route_delhi_502')"),
    departure_hour: float = Query(default=8.5, ge=0.0, le=24.0),
    capacity: int = Query(default=60, ge=20, le=120, description="Vehicle passenger capacity"),
) -> Any:
    """Problem 5: Calculates inter-stop passenger accumulation using passenger flow conservation:

    L_i = L_{i-1} + B_i - A_i.
    Estimates missing alightings and detects bottleneck segments where load >= 90%.
    """
    return segment_load_engine.compute_route_segment_loads(
        route_id=route_id,
        capacity=capacity,
        departure_hour=departure_hour,
    )


@router.get("/metro-corridor-loads", response_model=MetroCorridorLoadResponse)
def get_metro_corridor_loads(
    line: str = Query(default="Yellow", description="Delhi Metro Line (e.g. Yellow, Blue)"),
    train_type: str = Query(default="8-car", description="Train configuration: 6-car or 8-car"),
) -> Any:
    """Problem 5: Calculates segment loads and bottleneck choke points across Delhi Metro rapid transit corridors."""
    return segment_load_engine.compute_metro_corridor_loads(
        line_name=line,
        train_type=train_type,
    )


# ==============================================================================
# Model Validation & Limitations Report
# ==============================================================================

@router.get("/validation/metrics", response_model=ModelValidationReport, tags=["Model Validation"])
def get_model_validation_metrics() -> Any:
    """Returns empirical error metrics (MAE, RMSE, MAPE) comparing traffic engine predictions

    against real GTFS Static scheduled trips, alongside data provenance status and known limitations.
    """
    return ModelValidationReport()
