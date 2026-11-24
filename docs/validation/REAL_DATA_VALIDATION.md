# YATRA — Real-Data Validation and Empirical Error Analysis

This document records the empirical validation results, error metrics, and reproducible verification evidence across all five problems of the Delhi Transport Stack Hackathon.

---

## 1. Reproducible Verification Execution Log

The complete backend test suite and frontend operator portal build were executed from the repository root:

```bash
# 1. Backend Test Suite (Pytest)
& .venv\Scripts\python.exe -m pytest services/api/app/tests -v --durations=0
# Exit Code: 0 (45 passed, 0 failed, 0 skipped in 0.31s)

# 2. Next.js Operator Web Build
cmd.exe /c "cd apps\operator-web && npm run build"
# Exit Code: 0 (TypeScript 0 errors, 4 static pages prerendered)

# 3. Empirical Model Validation Script
& .venv\Scripts\python.exe scripts/validate_models.py
# Exit Code: 0
```

### Complete Test Execution Results

| Test File | Test Name | Result | Duration | Data Mode |
| :--- | :--- | :---: | :---: | :--- |
| `test_analytics_endpoints.py` | `test_api_journey_plan_fastest` | PASSED | 0.02s | Real GTFS stop registry + RAPTOR engine |
| `test_analytics_endpoints.py` | `test_api_crowding_estimate` | PASSED | 0.01s | Empirical RCI formulation |
| `test_analytics_endpoints.py` | `test_api_od_matrix` | PASSED | 0.01s | 7 Delhi TAZ zones + Furness IPF |
| `test_analytics_endpoints.py` | `test_api_od_desire_lines` | PASSED | 0.01s | GeoJSON LineString coordinates |
| `test_analytics_endpoints.py` | `test_api_feeder_routes_constraints` | PASSED | 0.01s | Metro road graph ($\ge 6\text{ m}, \le 7\text{ km}$) |
| `test_analytics_endpoints.py` | `test_api_feeder_routes_fleet_cap_violation` | PASSED | <0.01s | Boundary validation ($> 500$ cap check) |
| `test_analytics_endpoints.py` | `test_api_feeder_road_width_check` | PASSED | 0.01s | Road network carriageway query |
| `test_analytics_endpoints.py` | `test_api_segment_loads` | PASSED | 0.01s | Conservation equation ($L_n = 0$) |
| `test_analytics_endpoints.py` | `test_api_metro_corridor_loads` | PASSED | 0.01s | Delhi Metro Yellow Line sequence |
| `test_analytics_endpoints.py` | `test_api_validation_metrics` | PASSED | <0.01s | Empirical error metric endpoint |
| `test_analytics_endpoints.py` | `test_api_journey_plan_invalid_coordinates` | PASSED | <0.01s | Spatial boundary error handling |
| `test_gtfs_static.py` | `test_gtfs_parser_valid_feed` | PASSED | <0.01s | Synthetic minimal GTFS feed |
| `test_gtfs_static.py` | `test_gtfs_parser_missing_required_files` | PASSED | <0.01s | Error resilience on missing files |
| `test_gtfs_static.py` | `test_gtfs_parser_corrupt_coordinates` | PASSED | <0.01s | Coordinate parsing error check |
| `test_gtfs_static.py` | `test_gtfs_parser_out_of_bounds_warning` | PASSED | <0.01s | Out-of-bounds bounding box filter |
| `test_gtfs_static.py` | `test_gtfs_parser_referential_integrity` | PASSED | <0.01s | Foreign key validation |
| `test_gtfs_static.py` | `test_transit_repository_spatial_query` | PASSED | <0.01s | Haversine radius query on Delhi stops |
| `test_gtfs_rt.py` | `test_gtfs_rt_client_unconfigured` | PASSED | <0.01s | Environment variable guard |
| `test_gtfs_rt.py` | `test_gtfs_rt_client_configured` | PASSED | <0.01s | Client configuration and key mask |
| `test_gtfs_rt.py` | `test_vehicle_processor_protobuf_processing` | PASSED | <0.01s | Synthetic protobuf feed message |
| `test_gtfs_rt.py` | `test_vehicle_processor_out_of_bounds_filtering`| PASSED | <0.01s | Coordinate filter boundary |
| `test_gtfs_rt.py` | `test_vehicle_processor_stale_detection` | PASSED | <0.01s | Timestamp staleness filter ($> 120\text{s}$) |
| `test_gtfs_rt.py` | `test_vehicle_processor_json_processing` | PASSED | <0.01s | Synthetic JSON feed fallback |
| `test_health.py` | `test_root_health` | PASSED | <0.01s | Root health status |
| `test_health.py` | `test_v1_health` | PASSED | <0.01s | API v1 health status |
| `test_health.py` | `test_system_info` | PASSED | <0.01s | Ingestion and memory telemetry |
| `test_problem1_traffic_planner.py`| `test_traffic_engine_congestion_factors` | PASSED | <0.01s | Heuristic peak multipliers ($1.45\times, 1.55\times$) |
| `test_problem1_traffic_planner.py`| `test_traffic_engine_dwell_time_with_ramp` | PASSED | <0.01s | $+35\text{s}$ hydraulic ramp dwell adjustment |
| `test_problem1_traffic_planner.py`| `test_raptor_journey_planner_direct_or_transfer` | PASSED | <0.01s | Multimodal transit connection search |
| `test_problem1_traffic_planner.py`| `test_raptor_accessible_routing` | PASSED | <0.01s | Step-free accessibility filter |
| `test_problem2_crowding.py` | `test_crowding_engine_rci_bounds` | PASSED | <0.01s | RCI score bounded in $[0.05, 0.98]$ |
| `test_problem2_crowding.py` | `test_crowding_engine_etm_scaling` | PASSED | <0.01s | $28.5\times$ sample expansion factor |
| `test_problem2_crowding.py` | `test_crowding_engine_multi_objective_ranking` | PASSED | <0.01s | Pareto sorting (Fastest, Comfort, Access) |
| `test_problem3_od_matrix.py` | `test_od_matrix_furness_ipf_convergence` | PASSED | <0.01s | Furness IPF convergence in $\le 20$ iterations |
| `test_problem3_od_matrix.py` | `test_od_matrix_desire_lines_geojson` | PASSED | <0.01s | Desire lines FeatureCollection export |
| `test_problem4_feeder_optimizer.py`| `test_feeder_road_width_eligibility_constraint` | PASSED | <0.01s | Carriageway width check ($\ge 6.0\text{ m}$) |
| `test_problem4_feeder_optimizer.py`| `test_feeder_route_length_cap_and_fleet_budget` | PASSED | <0.01s | $\le 7.0\text{ km}$ length cap and $\le 500$ EV fleet |
| `test_problem4_feeder_optimizer.py`| `test_feeder_routes_geojson_export` | PASSED | <0.01s | GeoJSON route geometry generation |
| `test_problem5_segment_loads.py` | `test_passenger_flow_conservation_equation` | PASSED | <0.01s | Conservation invariant $L_n = 0$ |
| `test_problem5_segment_loads.py` | `test_missing_alighting_estimation` | PASSED | <0.01s | Destination attraction decay distribution |
| `test_problem5_segment_loads.py` | `test_bottleneck_detection` | PASSED | <0.01s | Bottleneck alert trigger ($LF \ge 0.90$) |
| `test_problem5_segment_loads.py` | `test_metro_corridor_loads` | PASSED | <0.01s | Delhi Metro 8-car segment load check |
| `test_transit_api.py` | `test_get_gtfs_status` | PASSED | <0.01s | GTFS status endpoint |
| `test_transit_api.py` | `test_get_routes_and_stops` | PASSED | 0.01s | Route and stop list queries |
| `test_transit_api.py` | `test_get_realtime_endpoints` | PASSED | 0.01s | Fleet live query |

---

## 2. Problem 1 — Journey & Traffic Model Validation

### Data Source
- Official Delhi Buses GTFS Static timetable: `data/gtfs/stops.txt` (6,862 stops) and `data/gtfs/stop_times.txt` (2,737,136 records).
- Cumulative distances calculated along stop coordinates using the Haversine formula.

### Empirical Error Metrics (Model vs Official Timetable)

Validation was performed against 30 complete scheduled bus trips across different times of day:

- **Sample Size:** 30 complete scheduled DTC trips
- **Mean Absolute Error (MAE):** 6.71 minutes
- **Root Mean Squared Error (RMSE):** 8.56 minutes
- **Mean Absolute Percentage Error (MAPE):** 12.91%
- **Off-Peak Period MAE (06:00–07:45, 12:00–16:00):** 2.50 minutes (18 trips)
- **Peak Period MAE (08:00–11:00, 17:00–20:30):** 13.03 minutes (12 trips)

### Technical Analysis of Peak vs Off-Peak Variance
Off-peak trips exhibit low error ($\text{MAE} = 2.50\text{ min}$, $\text{MAPE} = 7.6\%$). The model accurately tracks free-flow cruise speed ($28\text{ km/h}$) and stop dwell time ($25\text{s}$ per stop).

In contrast, peak trips exhibit higher deviation ($\text{MAE} = 13.03\text{ min}$, $+21.3\%$). This discrepancy occurs because official GTFS static timetables often schedule identical trip runtimes (e.g. 53.4 minutes for Route 102A at both 06:05 and 08:35), whereas the YATRA traffic engine applies an empirical $1.45\times$ peak congestion multiplier predicting 64.8 minutes.

> [!NOTE]
> The $1.45\times$ (AM peak) and $1.55\times$ (PM peak) congestion multipliers are documented as **uncalibrated empirical assumptions** derived from Delhi Master Plan mobility norms. Direct empirical calibration requires matching against historical GPS telemetry breadcrumbs.

---

## 3. Problem 2 — ETM Crowding Validation

### Dataset Inspection
An audit of `data/ticketing/` revealed that no raw conductor Electronic Ticketing Machine (ETM) transaction logs (.csv/.parquet) are bundled in the repository (`.gitkeep` only).

### Assessment of the $28.5\times$ Expansion Factor
The codebase includes an expansion factor:
$$\text{Expansion Factor} = 28.5 \quad \left(\frac{1}{0.0351}\right)$$
This assumes an average ETM capture rate of $3.5\%$ across Delhi bus passengers.

### Documented Limitation
Applying $28.5\times$ universally across all routes is an **uncalibrated hypothesis**:
- Conductor ticketing capture varies significantly by route type (e.g., feeder buses vs long-distance trunk routes).
- Female passengers travel free under the Pink Pass scheme; their issuance rate on ETM terminals varies between depots.
- Daily/monthly pass holders and unrecorded boardings introduce non-uniform scaling factors.

Therefore, the Relative Crowding Index (RCI) is exposed as a **sample-based relative indicator** with an explicit uncertainty margin ($\pm 18.5\%$) rather than a census passenger count.

---

## 4. Problem 3 — Origin–Destination (OD) Matrix Validation

### Model Convergence & Marginal Preservation
The Biproportional Fitting (Furness IPF) algorithm was evaluated across the 7 Delhi Transit Analysis Zones (TAZ):

- **Target Convergence Tolerance:** $\epsilon = 0.005$
- **Iterations to Convergence:** 4 iterations
- **Total Passenger Trips (AM Peak):** 546,143 trips
- **Sum of Row Marginals (Origins):** 546,143
- **Sum of Column Marginals (Destinations):** 546,143
- **Marginal Discrepancy:** 0 trips ($< 0.001\%$)

### Provincial Provenance & Calibration Status
- **Zone Boundaries:** 7 sectors aggregating Delhi Master Plan 2021 planning zones (North, Central, South, East, West, Rohini, Mehrauli).
- **Marginal Productions & Attractions:** Derived from DTC depot dispatch capacities and DMRC station ridership statistics. They represent operational estimates rather than a comprehensive household travel survey.
- **Distance Friction Parameter:** $\gamma = 0.08\text{ /km}$, representing an exponential decay calibrated from urban travel studies in Indian metropolitan areas.

---

## 5. Problem 4 — Feeder Optimization Validation

### Road Width Constraint Validation ($\ge 6.0\text{ m}$)
The network model was tested against Delhi road corridors around major Metro interchanges:

- **Arterial Corridor (Ring Road / Safdarjung):** Width $24.0\text{ m} \ge 6.0\text{ m}$ $\rightarrow$ **ELIGIBLE** for electric feeder buses.
- **Sub-Arterial Corridor (Tis Hazari / Vivek Vihar):** Width $10.0\text{--}12.0\text{ m} \ge 6.0\text{ m}$ $\rightarrow$ **ELIGIBLE**.
- **Colony Lane (Kotla Mubarakpur Bazaar):** Width $4.5\text{ m} < 6.0\text{ m}$ $\rightarrow$ **INELIGIBLE** (flagged for E-Rickshaw / Pedestrian Feeder only; buses rejected).

### Network Feeder Fleet Allocation Results

- **Fleet Budget Cap:** 500 electric buses
- **Allocated Feeder Buses:** 21 EV buses ($4.2\%$ of total budget across 5 primary loops)
- **Fleet Cap Respected:** Yes ($21 \le 500$)
- **Maximum Loop Length Cap:** $7.0\text{ km}$ strictly enforced
- **Average Route Length:** $5.7\text{ km}$
- **All Roads Eligible:** Yes ($100\%$ of edges on bus paths have width $\ge 6.0\text{ m}$)
- **Headways:** $9.8\text{--}10.5\text{ min}$ (within the target $8\text{--}12\text{ min}$ range)

> [!WARNING]
> While geometric, road-width, and cycle-time feasibility are verified, vehicle operational feasibility remains unvalidated due to missing battery capacity (kWh), depot DC fast-charging schedules, and driver shift constraints.

---

## 6. Problem 5 — Segment Load & Conservation Validation

### Passenger Flow Conservation Validation
The conservation equation:
$$L_i = L_{i-1} + B_i - A_i$$
was validated across stop sequences along Route 502 (Kashmere Gate to Mehrauli):

- **Stops Evaluated:** 5 stops (4 inter-stop segments)
- **Total Boardings:** 58.1 passengers
- **Total Estimated Alightings:** 58.1 passengers
- **Conservation Residual ($L_n$):** 0.0 passengers
- **Conservation Equation Holds:** Yes (identically zero residual at terminal)
- **Peak Segment Load:** 37.2 passengers between Red Fort and Delhi Gate (Capacity: 60, Load Factor: 0.62)

### Missing Alighting Estimation Method
Alightings at intermediate stops are estimated using a destination attraction decay function:
$$P(j \mid i) = \frac{W_j \cdot e^{-\beta \cdot d(i, j)}}{\sum_{k > i} W_k \cdot e^{-\beta \cdot d(i, k)}}$$
Mathematical conservation is preserved, but intermediate occupancy numbers are labeled as **inferred estimates** subject to unobserved passenger variations ($\pm 15\text{--}20\%$).
