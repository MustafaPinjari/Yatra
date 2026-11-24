from typing import Any
from pydantic import BaseModel, Field


# ==============================================================================
# Journey Planning Schemas (Problem 1 & 2)
# ==============================================================================

class JourneyPlanRequest(BaseModel):
    origin_lat: float = Field(..., ge=28.0, le=29.0, description="Origin latitude in Delhi NCT")
    origin_lon: float = Field(..., ge=76.5, le=77.6, description="Origin longitude in Delhi NCT")
    destination_lat: float = Field(..., ge=28.0, le=29.0, description="Destination latitude in Delhi NCT")
    destination_lon: float = Field(..., ge=76.5, le=77.6, description="Destination longitude in Delhi NCT")
    departure_hour: float = Field(default=9.0, ge=0.0, le=24.0, description="Departure hour of the day (e.g. 9.5 = 09:30)")
    max_walking_distance_meters: float = Field(default=800.0, ge=100.0, le=2500.0)
    wheelchair_accessible_only: bool = Field(default=False, description="Require step-free boarding & hydraulic ramp")
    objective: str = Field(default="FASTEST", description="Ranking preference: FASTEST, LEAST_CROWDED, or MOST_ACCESSIBLE")


class JourneyLegModel(BaseModel):
    mode: str  # WALK or BUS
    from_name: str
    to_name: str
    from_lat: float
    from_lon: float
    to_lat: float
    to_lon: float
    route_id: str | None = None
    route_short_name: str | None = None
    departure_time: str
    arrival_time: str
    duration_minutes: float
    distance_km: float
    walking_meters: float = 0.0
    relative_crowding_index: float = 0.0
    crowding_level: str = "LOW"
    step_free_accessible: bool = True


class JourneyItineraryModel(BaseModel):
    itinerary_id: str
    summary: str
    transfers: int
    total_duration_minutes: float
    in_vehicle_minutes: float
    walking_minutes: float
    waiting_minutes: float
    total_walking_distance_meters: float
    relative_crowding_index: float
    crowding_level: str
    accessibility_score: float
    is_step_free_accessible: bool
    rank_score: float
    legs: list[JourneyLegModel]


class JourneyPlanResponse(BaseModel):
    origin: dict[str, float]
    destination: dict[str, float]
    departure_hour: float
    objective: str
    algorithm: str = "RAPTOR (Round-Based Public Transit Routing)"
    itineraries_count: int
    itineraries: list[JourneyItineraryModel]


# ==============================================================================
# Crowding Estimation Schemas (Problem 2)
# ==============================================================================

class CrowdingEstimateResponse(BaseModel):
    route_id: str
    hour: float
    relative_crowding_index: float
    crowding_level: str
    comfort_index: float
    bunching_headway_deviation: float
    confidence_level: str
    etm_sample_factor: float
    wheelchair_space_available: bool
    provenance: str = "SAMPLE_BASED_INFERENCE"
    expansion_factor_status: str = "UNCALIBRATED_HYPOTHESIS"
    sample_rate_percent: float = 3.5
    uncertainty_margin_percent: float = 18.5
    limitation_note: str | None = "Universal 28.5x expansion factor is uncalibrated without full conductor ETM records."


# ==============================================================================
# Origin-Destination Matrix Schemas (Problem 3)
# ==============================================================================

class OdMatrixResponse(BaseModel):
    time_period: str
    algorithm: str = "Biproportional Fitting (Furness IPF) with Distance Impedance"
    iterations_run: int
    converged: bool
    total_passenger_trips: int
    zones: list[dict[str, Any]]
    matrix: list[list[int]]
    desire_lines_geojson: dict[str, Any]
    data_provenance: str = "ESTIMATED_VIA_MPD2021_AND_DTC_DEPOT_FLOWS"
    marginal_preservation_error_percent: float = 0.01
    distance_decay_parameter: float = 0.08
    limitation_note: str | None = "Trip marginals derived from depot operational capacity and DMRC footfalls."


# ==============================================================================
# Metro Feeder Optimization Schemas (Problem 4)
# ==============================================================================

class FeederOptimizationResponse(BaseModel):
    fleet_budget_total: int
    fleet_allocated: int
    fleet_utilization_percent: float
    fleet_cap_respected: bool
    routes_count: int
    total_network_km: float
    average_route_length_km: float
    max_route_length_cap_km: float
    all_routes_under_length_cap: bool
    min_carriageway_width_enforced_m: float
    all_roads_eligible: bool
    target_headway_range: str
    allocated_routes: list[dict[str, Any]]
    road_width_provenance: str = "DELHI_MASTER_PLAN_2021_ROW_STANDARDS"
    micro_level_survey_available: bool = False
    operational_feasibility_status: str = "GEOMETRIC_AND_HEADWAY_FEASIBILITY_ONLY"
    missing_operational_inputs: list[str] = Field(default_factory=lambda: [
        "Battery capacity (kWh)",
        "Depot fast-charger schedule",
        "Driver duty rotation limits",
        "Air-conditioning thermal load degradation",
    ])


class RoadWidthCheckResponse(BaseModel):
    exists: bool
    u: str | None = None
    v: str | None = None
    name: str | None = None
    carriageway_width_m: float | None = None
    min_required_width_m: float
    is_bus_eligible: bool
    transport_mode_allowed: str
    regulatory_violation: str | None = None


# ==============================================================================
# Segment Load Schemas (Problem 5)
# ==============================================================================

class SegmentLoadResponse(BaseModel):
    route_id: str
    stops_count: int
    segments_count: int
    vehicle_capacity: int
    total_boardings: float
    total_alightings: float
    conservation_residual: float
    conservation_equation_holds: bool
    peak_load: float
    peak_load_factor: float
    peak_segment: str
    bottlenecks_detected: int
    bottleneck_segments: list[dict[str, Any]]
    segments: list[dict[str, Any]]
    data_provenance: str = "GTFS_ROUTE_SEQUENCE_WITH_ESTIMATED_ALIGHTINGS"
    estimation_method: str = "PROPORTIONAL_GRAVITY_DECAY"
    mathematical_conservation_satisfied: bool = True
    flow_conservation_note: str | None = None
    accuracy_disclaimer: str = "Inferred load; real-world accuracy bounded by missing alighting censuses (accumulating margin ±5% to ±25% along route)."


class OdSensitivityItem(BaseModel):
    gamma: float
    friction_label: str
    total_trips: int
    interzonal_trips: int
    interzonal_share_percent: float
    intrazonal_trips: int
    intrazonal_share_percent: float
    iterations_to_converge: int
    converged: bool


class OdSensitivityResponse(BaseModel):
    time_period: str
    tested_gammas: list[float]
    sensitivity_runs: list[OdSensitivityItem]
    methodology: str = "Iterative Proportional Fitting with Exponential Distance Friction"
    provenance: str = "ESTIMATED_VIA_MPD2021_AND_DTC_DEPOT_FLOWS"


class FeederSensitivityItem(BaseModel):
    target_headway_minutes: float
    frequency_buses_per_hour: float
    fleet_required_full_network: int
    fleet_allocated_under_cap: int
    fleet_cap: int
    is_fleet_budget_compliant: bool
    routes_fully_serviced: int
    total_coverage_km: float
    average_cycle_time_minutes: float


class FeederSensitivityResponse(BaseModel):
    fleet_cap: int = 500
    tested_headways: list[float]
    sensitivity_runs: list[FeederSensitivityItem]
    regulatory_standard: str = "Delhi Electric Bus Operational Guidelines"


class FeederEvEnergyResponse(BaseModel):
    route_id: str
    metro_hub: str
    loop_distance_km: float
    daily_trips_scheduled: int
    daily_distance_km: float
    ev_nominal_battery_capacity_kwh: float
    usable_battery_capacity_kwh: float
    specific_energy_consumption_kwh_km: float
    energy_consumed_per_loop_kwh: float
    total_daily_energy_consumed_kwh: float
    loops_before_mandatory_recharge: int
    requires_midday_opportunity_charge: bool
    depot_fast_charger_power_kw: float
    estimated_opportunity_topup_minutes: float
    full_daily_recharge_time_minutes: float
    full_daily_recharge_time_hours: float
    charging_regime: str
    provenance: str


class MetroCorridorLoadResponse(BaseModel):
    corridor: str
    train_type: str
    train_nominal_capacity: int
    total_stations: int
    segments_count: int
    bottlenecks_count: int
    peak_load: int
    segments: list[dict[str, Any]]


class ModelValidationReport(BaseModel):
    traffic_model_sample_size: int = 30
    traffic_mae_minutes: float = 6.71
    traffic_rmse_minutes: float = 8.56
    traffic_mape_percent: float = 12.91
    peak_period_mae_minutes: float = 13.03
    off_peak_period_mae_minutes: float = 2.50
    congestion_multipliers_calibrated: bool = False
    congestion_multiplier_status: str = "UNRECONCILED_EMPIRICAL_ASSUMPTION"
    historical_gps_traces_present: bool = False
    etm_ticketing_data_present: bool = False
    etm_expansion_factor_status: str = "UNCALIBRATED_HYPOTHESIS (28.5x assuming 3.5% capture)"
    od_ipf_converged: bool = True
    od_marginal_error_percent: float = 0.0
    feeder_road_width_source: str = "DELHI_MASTER_PLAN_2021_ROW_STANDARDS"
    feeder_fleet_cap_respected: bool = True
    passenger_flow_conservation_residual: float = 0.0
    conservation_equation_satisfied: bool = True
