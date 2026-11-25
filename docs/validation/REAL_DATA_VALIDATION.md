# YATRA — Real-Data Validation and Empirical Error Analysis

This document records the empirical validation results, error metrics, live feed telemetry, and reproducible verification evidence across all five problems of the Delhi Transport Stack Hackathon.

---

## 1. Reproducible Verification Execution Log

The complete backend test suite, end-to-end integration suite, and frontend operator portal build were executed from the repository root:

```bash
# 1. Backend Test Suite (Pytest)
& .venv\Scripts\python.exe -m pytest services/api/app/tests -v --durations=0
# Exit Code: 0 (52 passed, 0 failed, 0 skipped in 0.35s)

# 2. End-to-End Integration Test Suite
& .venv\Scripts\python.exe scripts/e2e_integration_test.py
# Exit Code: 0 (7 of 7 checks passed, 100% compliant)

# 3. Next.js Operator Web Build
cmd.exe /c "cd apps\operator-web && npm run build"
# Exit Code: 0 (TypeScript 0 errors, 4 static pages prerendered)

# 4. Flutter / Dart Static Analysis
dart analyze apps/passenger-mobile apps/driver-mobile
# Exit Code: 0 (No issues found)

# 5. Empirical Model Validation Script
& .venv\Scripts\python.exe scripts/validate_models.py
# Exit Code: 0
```

### Complete Test Execution Results (52 / 52 Passed)

| Test File | Test Name | Result | Duration | Data Mode |
| :--- | :--- | :---: | :---: | :--- |
| `test_analytics_endpoints.py` | `test_api_journey_plan_fastest` | PASSED | 0.02s | Real GTFS stop registry + RAPTOR engine |
| `test_analytics_endpoints.py` | `test_api_crowding_estimate` | PASSED | 0.01s | Empirical RCI formulation |
| `test_analytics_endpoints.py` | `test_api_od_matrix` | PASSED | 0.01s | 7 Delhi TAZ zones + Furness IPF |
| `test_analytics_endpoints.py` | `test_api_od_desire_lines` | PASSED | 0.01s | GeoJSON LineString coordinates |
| `test_analytics_endpoints.py` | `test_api_od_sensitivity` | PASSED | 0.01s | Distance decay friction sensitivity ($\gamma \in [0.04, 0.12]$) |
| `test_analytics_endpoints.py` | `test_api_feeder_routes_constraints` | PASSED | 0.01s | Metro road graph ($\ge 6\text{ m}, \le 7\text{ km}$) |
| `test_analytics_endpoints.py` | `test_api_feeder_routes_fleet_cap_violation` | PASSED | <0.01s | Boundary validation ($> 500$ cap check) |
| `test_analytics_endpoints.py` | `test_api_feeder_road_width_check` | PASSED | 0.01s | Carriageway query with unknown road rejection |
| `test_analytics_endpoints.py` | `test_api_feeder_sensitivity` | PASSED | 0.01s | Feeder headway sensitivity analysis |
| `test_analytics_endpoints.py` | `test_api_feeder_ev_energy` | PASSED | 0.01s | 180 kWh nominal (144 kWh usable) EV battery model (21 complete loops, 125.22 km range) |
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
| `test_gtfs_rt.py` | `test_vehicle_processor_out_of_bounds_filtering` | PASSED | <0.01s | Coordinate filter boundary |
| `test_gtfs_rt.py` | `test_vehicle_processor_stale_detection` | PASSED | <0.01s | Timestamp staleness filter ($> 120\text{s}$) |
| `test_gtfs_rt.py` | `test_vehicle_processor_json_processing` | PASSED | <0.01s | Synthetic JSON feed fallback |
| `test_health.py` | `test_root_health` | PASSED | <0.01s | Root health status |
| `test_health.py` | `test_v1_health` | PASSED | <0.01s | API v1 health status |
| `test_health.py` | `test_system_info` | PASSED | <0.01s | Ingestion and memory telemetry |
| `test_problem1_traffic_planner.py` | `test_traffic_engine_congestion_factors` | PASSED | <0.01s | Heuristic peak multipliers ($1.45\times, 1.55\times$) |
| `test_problem1_traffic_planner.py` | `test_traffic_engine_dwell_time_with_ramp` | PASSED | <0.01s | $+35\text{s}$ hydraulic ramp dwell adjustment |
| `test_problem1_traffic_planner.py` | `test_raptor_journey_planner_direct_or_transfer` | PASSED | <0.01s | Multimodal transit connection search |
| `test_problem1_traffic_planner.py` | `test_raptor_accessible_routing` | PASSED | <0.01s | Step-free accessibility filter |
| `test_problem2_crowding.py` | `test_crowding_engine_rci_bounds` | PASSED | <0.01s | RCI score bounded in $[0.05, 0.98]$ |
| `test_problem2_crowding.py` | `test_crowding_engine_etm_scaling` | PASSED | <0.01s | $28.5\times$ uncalibrated sample expansion hypothesis |
| `test_problem2_crowding.py` | `test_crowding_engine_multi_objective_ranking` | PASSED | <0.01s | Pareto sorting (Fastest, Comfort, Access) |
| `test_problem3_od_matrix.py` | `test_od_matrix_furness_ipf_convergence` | PASSED | <0.01s | Furness IPF convergence in $\le 20$ iterations |
| `test_problem3_od_matrix.py` | `test_od_matrix_desire_lines_geojson` | PASSED | <0.01s | Desire lines FeatureCollection export |
| `test_problem4_feeder_optimizer.py` | `test_feeder_road_width_eligibility_constraint` | PASSED | <0.01s | Carriageway width check ($\ge 6.0\text{ m}$) |
| `test_problem4_feeder_optimizer.py` | `test_feeder_route_length_cap_and_fleet_budget` | PASSED | <0.01s | $\le 7.0\text{ km}$ length cap and $\le 500$ EV fleet |
| `test_problem4_feeder_optimizer.py` | `test_feeder_routes_geojson_export` | PASSED | <0.01s | GeoJSON route geometry generation |
| `test_problem4_feeder_optimizer.py` | `test_feeder_unknown_road_width_rejection` | PASSED | <0.01s | Rejection of unverified road segments |
| `test_problem4_feeder_optimizer.py` | `test_feeder_headway_sensitivity` | PASSED | <0.01s | Fleet requirement across headway range |
| `test_problem4_feeder_optimizer.py` | `test_feeder_ev_energy_model` | PASSED | <0.01s | EV battery consumption & charging top-up |
| `test_problem5_segment_loads.py` | `test_passenger_flow_conservation_equation` | PASSED | <0.01s | Conservation invariant $L_n = 0$ |
| `test_problem5_segment_loads.py` | `test_missing_alighting_estimation` | PASSED | <0.01s | Destination attraction decay distribution |
| `test_problem5_segment_loads.py` | `test_bottleneck_detection` | PASSED | <0.01s | Bottleneck alert trigger ($LF \ge 0.90$) |
| `test_problem5_segment_loads.py` | `test_metro_corridor_loads` | PASSED | <0.01s | Delhi Metro 8-car segment load check |
| `test_problem5_segment_loads.py` | `test_segment_load_uncertainty_bounds` | PASSED | <0.01s | Uncertainty propagation across segments |
| `test_transit_api.py` | `test_get_gtfs_status` | PASSED | <0.01s | GTFS status endpoint |
| `test_transit_api.py` | `test_get_routes_and_stops` | PASSED | 0.01s | Route and stop list queries |
| `test_transit_api.py` | `test_get_realtime_endpoints` | PASSED | 0.01s | Fleet live query |

---

## 2. Live GTFS-Realtime Feed Telemetry Verification

Live ingestion of the Delhi Transport Stack GTFS-RT feed was verified against the official gateway:

```text
Endpoint: https://dts-backend.transportstack.in/api/dataset/otd/get-file?agency=delhi-buses&category=realtime_gtfs&filename=VehiclePositions.pb
Authentication: x-api-key: [MASKED]
Status Code: HTTP 200 OK
Payload Size: 409,536 bytes (~399.9 KB)
Feed Format: Protocol Buffer v2.0 (FeedMessage)
Decoded Vehicles: 3,746 buses
Fresh Vehicles (<= 300s): 3,716 (99.2%)
Stale Vehicles (> 300s): 30 (0.8%)
Sum Invariant Check: 3,716 + 30 = 3,746 (Exact match)
Configured Bounding Box: [28.0, 29.2] N, [76.5, 77.8] E (Delhi NCR regional)
In-Bounds Coordinate Share: 3,745 / 3,746 (99.97%)
Active Routes: 1,356 distinct routes
HTTP Round-Trip Network Latency: 1,394 ms – 4,653 ms
Protobuf Binary Decoding Time: 2.27 ms
Fleet Memory Processing Time: 11.29 ms
Stale Vehicle Threshold: Strictly enforced at 300 seconds
```

Sanitized evidence is documented in `docs/validation/GTFS_RT_VERIFICATION.md`.

---

## 3. Problem 1 — Bus Journey & Traffic Model Validation

### Data Source

- Official Delhi Buses GTFS Static timetable: `data/gtfs/stops.txt` (6,862 stops) and `data/gtfs/stop_times.txt` (2,737,136 records).
- Cumulative distances calculated along stop coordinates using the Haversine formula.

### Empirical Error Metrics (Model vs Official Timetable)

Validation was performed against 30 complete scheduled bus trips across different times of day:

- **Sample Size:** 30 complete scheduled DTC trips
- **Mean Absolute Error (MAE):** 6.71 minutes
- **Root Mean Squared Error (RMSE):** 8.56 minutes
- **Mean Absolute Percentage Error (MAPE):** 12.91%
- **Off-Peak Period MAE (06:00–07:45, 12:00–16:00):** 2.50 minutes (18 trips, 7.6% error)
- **Peak Period MAE (08:00–11:00, 17:00–20:30):** 13.03 minutes (12 trips, 21.3% error)

### Analysis of Peak vs Off-Peak Variance

Off-peak trips exhibit low error ($\text{MAE} = 2.50\text{ min}$, $\text{MAPE} = 7.6\%$). The model accurately tracks free-flow cruise speed ($28\text{ km/h}$) and stop dwell time ($25\text{s}$ per stop).

In contrast, peak trips exhibit higher deviation ($\text{MAE} = 13.03\text{ min}$, $+21.3\%$). This discrepancy occurs because official GTFS static timetables schedule uniform trip runtimes regardless of time-of-day, whereas the YATRA traffic engine applies an empirical $1.45\times$ peak congestion multiplier predicting extended runtimes.

> [!NOTE]
> This comparison measures **scheduled timetable deviation**, not observed road speed accuracy. Raw historical GPS trajectory breadcrumbs are currently absent; the $1.45\times$ and $1.55\times$ multipliers remain declared empirical engineering assumptions.

---

## 4. Problem 2 — Crowdedness-Aware Journey Planning

### Validation Approach

Because conductor ETM transaction archives are not bundled in the local repository, Relative Crowding Index (RCI) estimates are evaluated as relative heuristics:

- **Index Bounds:** Mathematically bounded in $[0.05, 0.98]$ across all routes and times.
- **Headway Bunching:** Evaluated from GTFS-RT feed intervals:

  $$P_h = \max\left(0, \frac{H_{\text{obs}} - H_{\text{sched}}}{H_{\text{sched}}}\right)$$

- **Pareto Optimality:** Tested across multi-objective criteria (Travel Time, Comfort / RCI, Accessibility Score). Unit test `test_crowding_engine_multi_objective_ranking` confirms non-dominated sorting.

---

## 5. Problem 3 — Transit Origin–Destination (OD) Matrix

### Convergence & Marginal Preservation

- **Algorithm:** Furness Iterative Proportional Fitting (IPF).
- **Zonal Structure:** 7 Delhi Transit Analysis Zones (TAZ).
- **Convergence:** Terminates in 4 iterations with maximum cell change $< 0.001\%$.
- **Marginal Check:**

  $$\sum_{j} T_{ij} = G_i \quad (\text{error} = 0.0000\%)$$

  $$\sum_{i} T_{ij} = A_j \quad (\text{error} = 0.0000\%)$$

  Total modeled 3-hour morning peak period (08:00–11:00) trips generated ($546,143$) exactly match trips attracted ($546,143$). Furness IPF balances generation and attraction marginals; its convergence does not independently establish the true passenger OD distribution.

- **Mode Split:** Mode-share scenario allocations: 46% DMRC Metro trips ($251,226\text{ trips}$) and 54% DTC surface bus trips ($294,917\text{ trips}$) based on published aggregate operational reports.
- **Friction Sensitivity:** Evaluated across $\gamma \in [0.04, 0.08, 0.12]$. Inter-zonal trip proportion ranges smoothly from $82.1\%$ to $66.5\%$.

---

## 6. Problem 4 — Metro Feeder Route & Fleet Optimization

### Constraint Verification

- **Road Width Standard:** Minimum $6.0\text{ m}$ carriageway planning width enforced using MPD-2021 Right-of-Way estimates (`field_measured_width_m: None`, physical compliance requires field audit). Roads without width records are marked unknown and rejected (`is_bus_eligible: false`).
- **Route Length Cap:** All candidate feeder loops satisfy $L_r \le 7.0\text{ km}$ (longest candidate is $6.1\text{ km}$).
- **Fleet Allocation:** 21 EV buses allocated across 7 loops, comfortably within the $500\text{ bus}$ policy cap ($4.2\%$ utilization).
- **Headway Sensitivity:** Feasible vehicle requirements evaluated across headways from 6 to 15 minutes (52 to 22 buses required, all $\le 500$).
- **EV Operational Feasibility:** Evaluated under a 180 kWh nominal battery model ($144\text{ kWh}$ usable at 80% DoD) with 1.15 kWh/km consumption, 21 complete loops before recharge ($119.7\text{ km}$ revenue distance), 125.22 km theoretical single-charge range, and 60 kW DC depot fast charging (+45 kWh ideal / +41.40 kWh net, +39.13 km / 6 loops), confirming zero midday battery exhaustion.

---

## 7. Problem 5 — Passenger Flow Conservation & Segment Loads

### Mathematical Invariant Verification

- **Route 502 Corridor:** 38 GTFS stops from Old Delhi Railway Station to Mehrauli.
- **Flow Conservation:**

  $$L_i = L_{i-1} + B_i - A_i \quad \text{with } L_0 = 0 \text{ and } L_n = 0$$

- **Residual Result:** Exactly $0.0\text{ passengers}$ remaining at terminus (0.00% error), an enforced mathematical model boundary condition ($\sum B = \sum A$), not empirical field validation.
- **Uncertainty Envelope:** Surfaced in API responses: $\pm 5\%$ at origin, expanding to $\pm 22\%$ across intermediate stops due to gravity alighting estimation, and collapsing to $0\%$ at terminus.
- **Bottleneck Detection:** Successfully identifies load factors $\ge 0.90$ and triggers automated relief bus advisories.
