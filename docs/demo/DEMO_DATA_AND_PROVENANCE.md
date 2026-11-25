# YATRA — Demonstration Data Catalog & Provenance Register

This document serves as the unified single source of truth for all datasets, geographic boundaries, performance benchmarks, and empirical assumptions demonstrated across the YATRA platform.

---

## 1. Reconciled Verification Benchmarks (Single Source of Truth)

All metrics below are derived from direct code inspection and reproducible execution against official feeds:

### 1.1 Live GTFS-Realtime Telemetry Ingestion

- **Feed Endpoint:** `https://dts-backend.transportstack.in/api/dataset/otd/get-file?agency=delhi-buses&category=realtime_gtfs&filename=VehiclePositions.pb`
- **Authentication Method:** Header `x-api-key: [MASKED]` (Bearer token rejected per DTS specification)
- **HTTP Response Status:** `HTTP 200 OK`
- **Content-Type:** `application/octet-stream` (binary stream)
- **Payload Size:** 409,536 bytes (~399.9 KB)
- **Total Decoded Entities:** **3,746 active vehicles**
- **Vehicle Freshness Breakdown:**
  - Fresh vehicles ($\le 300\text{s}$ old): **3,716** (99.2%)
  - Stale vehicles ($> 300\text{s}$ old): **30** (0.8%)
  - Missing timestamp count: **0**
  - **Sum Invariant:** $3,716 + 30 + 0 = \mathbf{3,746}$ (Exact match)
- **Active Distinct Routes:** **1,356 routes**

### 1.2 Geographic Bounding Box Reconciliation

- **Configured Bounding Box (`services/api/app/integrations/gtfs_rt/processor.py`):**
  - Latitude: $[28.000000, 29.200000]\text{ N}$
  - Longitude: $[76.500000, 77.800000]\text{ E}$
  - *Definition:* Delhi National Capital Region (NCR) regional transit boundary, encompassing outer depot loops (Gurugram, Faridabad, Ghaziabad, Noida, Bahadurgarh).
- **Core Municipal Boundary (`MPD-2021`):**
  - Latitude: $[28.200000, 28.950000]\text{ N}$
  - Longitude: $[76.800000, 77.550000]\text{ E}$
  - *Definition:* National Capital Territory (NCT) of Delhi strict administrative boundary.
- **Observed Telemetry Spatial Distribution:**
  - Observed Latitude: $[28.192822, 29.230585]\text{ N}$
  - Observed Longitude: $[76.615891, 77.419624]\text{ E}$
  - **In-Bounds Compliance:** 3,745 / 3,746 (99.97%); 1 vehicle at $29.230585\text{ N}$ in peripheral Sonipat depot corridor.

### 1.3 Telemetry Latency & Processing Timing Breakdown

Performance metrics are decoupled into network transport, binary decoding, and memory processing:

1. **HTTP Round-Trip Time (Network Latency):** **$1,394\text{ ms} \text{ to } 4,653\text{ ms}$** (dependent on public internet WAN routing and DTS upstream server load).
2. **Protobuf Binary Decoding Time (`FeedMessage.ParseFromString`):** **$2.27\text{ ms}$** (in-memory parsing of ~400 KB binary payload using compiled Google Protocol Buffer library).
3. **Fleet Filtering & Memory Processing Time (`_process_protobuf_feed`):** **$11.29\text{ ms}$** (bounding box checks, Haversine enrichment, freshness calculation for 3,746 vehicles).
4. **Total Combined Processing Time:** Under 15 ms local compute; total pipeline duration dominated by external network transport.

### 1.4 Stale-Data Detection Threshold

- **Single Source of Truth:** `STALE_THRESHOLD_SECONDS = 300` (5 minutes).
- **Operational Justification:** Aligns with Delhi Transport Corporation AVL transmission norms where vehicles idling at bus terminals, layovers, or depots transmit telemetry heartbeats every 2 to 5 minutes. Telemetry exceeding 300 seconds is flagged with `is_stale: true`.

---

## 2. Complete Asset Provenance Register

| Asset / Engine | Repository Location | Format | Epistemic Classification | Provenance Source & Details |
| :--- | :--- | :---: | :---: | :--- |
| **Delhi GTFS Static** | `data/gtfs/` | CSV / Text | **OBSERVED** | Official DTC/DIMTS feed via Open Transit Data Delhi. 6,862 stops, 2,574 routes, 80,357 trips, 2,737,136 stop times. |
| **Delhi GTFS-Realtime** | `services/api/app/integrations/gtfs_rt/` | Protocol Buffer v2.0 | **OBSERVED** | Official Delhi Transport Stack API (`VehiclePositions.pb`). 3,746 vehicles decoded live. |
| **Historical GPS Traces** | `data/gps/` | None (`.gitkeep`) | **UNVERIFIED** | 10-second AVL trajectory breadcrumbs are not present in the local repository. Traffic multipliers are declared empirical assumptions. |
| **ETM Ticketing Data** | `data/ticketing/` | None (`.gitkeep`) | **UNVERIFIED** | Full transaction dumps are not present in the local repository. 28.5x expansion factor is an uncalibrated planning hypothesis (`UNVERIFIED_PLANNING_HYPOTHESIS`), not an empirical census result. |
| **Transit Analysis Zones (TAZ)** | `services/api/app/engines/od_engine.py` | Geometric Polygons | **ESTIMATED** | Aggregated from Delhi Master Plan 2021 Zonal Development Plans into 7 sectors (North, Central, South, East, West, Rohini, Mehrauli). |
| **Zone Trip Gener/Attr** | `services/api/app/engines/od_engine.py` | Numerical Marginals | **ESTIMATED** | Calibrated against aggregate DTC depot dispatch logs and DMRC daily ridership records. Total of 546,143 trips represents the 3-hour morning peak period (08:00–11:00) modeled transit trips. |
| **Metro Rail / Bus Mode Split** | `services/api/app/engines/od_engine.py` | Mode Share Proportion | **SCENARIO_MODEL** | 46% Rail (251,226 trips) vs 54% Bus (294,917 trips) are modeled mode-share scenario allocations based on published aggregate reports, not separate censuses. |
| **Road Width Network** | `services/api/app/engines/feeder_optimizer.py` | Directed Graph | **ESTIMATED** | 32 nodes, 48 edges around 7 DMRC hubs. Assigned using MPD-2021 Right-of-Way planning standards (`planning_width_row_m`). Field verification required (`field_measured_width_m: None`). Unknown roads strictly rejected. |
| **Stop Accessibility Audit** | `data/sample/sample_stops.json` | JSON Fixture | **SYNTHETIC** | Physical audit measurements (ramp presence, curb height, tactile paths) for 4 sample stops on Route 502. |
| **Failure Mode Fixtures** | `services/api/app/tests/` | Mock Tests | **SYNTHETIC** | Synthetic mock payloads for timeout, HTTP 401, corrupted binary, and empty streams. |

---

## 3. Mathematical Parameters and Empirical Justifications

### 3.1 Problem 1: Journey & Traffic Engine

- **Free-Flow Cruise Speed:** $28\text{ km/h}$ (`ESTIMATED`) — Calibrated to off-peak GTFS scheduled intervals.
- **Baseline Stop Dwell Time:** $25\text{s}$ (`ESTIMATED`) — Urban boarding norm.
- **Hydraulic Ramp Extension Dwell:** $+35\text{s}$ (`SCENARIO_MODEL`) — Operating standard for kneeling bus ramp deployment.
- **AM Peak Multiplier (08:00–11:00):** $1.45\times$ (`SCENARIO_MODEL`) — Empirical speed reduction prior.
- **PM Peak Multiplier (17:00–20:30):** $1.55\times$ (`SCENARIO_MODEL`) — Empirical speed reduction prior.
- **Timetable Deviation MAE:** $6.71\text{ min}$ (Off-peak: $2.50\text{ min}$; Peak: $13.03\text{ min}$) against 30 scheduled trips.

### 3.2 Problem 2: Relative Crowding Index

- **RCI Bounds:** $[0.05, 0.98]$ (`ESTIMATED`) — Normalized relative comfort metric.
- **ETM Sampling Status:** 28.5x expansion factor is an uncalibrated planning hypothesis (`UNVERIFIED_PLANNING_HYPOTHESIS`); RCI operates as a relative operational heuristic without claiming exact onboard passenger counts.
- **Bunching Factor:** $\beta = 0.40$ (`ESTIMATED`) — Headway deviation queue growth factor.

### 3.3 Problem 3: OD Matrix Engine

- **Furness IPF Convergence:** 4 iterations (`ESTIMATED`) — Max marginal discrepancy $< 0.001\%$. Balances marginals; convergence does not prove true OD distribution.
- **Time Period:** 3-hour morning peak period (08:00–11:00) modeled transit trips (546,143 trips).
- **Distance Friction Parameter:** $\gamma = 0.08\text{ /km}$ (`ESTIMATED`) — Indian urban transit baseline.
- **Sensitivity Range:** $\gamma \in [0.04, 0.12]$ (`SCENARIO_MODEL`) — Inter-zonal share shifts from 82.1% to 66.5%.

### 3.4 Problem 4: Feeder Bus & EV Optimization

- **Minimum Planning Carriageway Width:** $\ge 6.0\text{ m}$ (`SCENARIO_MODEL`) — Indian Roads Congress IRC:73 standard based on MPD-2021 RoW estimates; unverified roads rejected; physical compliance requires field audit.
- **Maximum Loop Length:** $\le 7.0\text{ km}$ (`SCENARIO_MODEL`) — Circular feeder length cap (average: 5.7 km).
- **Fleet Allocation:** 21 EV buses allocated under 500 cap ($4.2\%$) (`SCENARIO_MODEL`).
- **EV Battery Capacity:** $180\text{ kWh}$ nominal ($144\text{ kWh}$ usable energy at 80% DoD) (`SCENARIO_MODEL`).
- **Specific Energy Consumption:** $1.15\text{ kWh/km}$ (`SCENARIO_MODEL`) — Delhi summer AC load norm.
- **Energy Consumed per Loop:** $5.7\text{ km} \times 1.15\text{ kWh/km} = 6.555\text{ kWh}$ ($6.56\text{ kWh}$).
- **Complete Loops Before Recharge:** $\lfloor 144 / 6.555 \rfloor = 21$ complete loops ($119.7\text{ km}$ operating distance).
- **Maximum Theoretical Operating Distance:** $144 / 1.15 = 125.22\text{ km}$ on single charge.
- **Depot Fast Charging:** $60\text{ kW}$ DC charger; 45-min midday opportunity charging delivers $45\text{ kWh}$ ($41.40\text{ kWh}$ net at 92% efficiency), providing $+39.13\text{ km}$ ($+36.00\text{ km}$ net) or 6 complete loops (`SCENARIO_MODEL`).

### 3.5 Problem 5: Segment Loads & Flow Conservation

- **Flow Conservation Identity:** $L_i = L_{i-1} + B_i - A_i$ (`ESTIMATED`) — Terminal zero residual ($L_n = 0$) is an enforced mathematical model boundary condition and conservation result ($\sum B = \sum A$), not empirical validation of passenger counts.
- **Propagating Uncertainty Margin:** $\pm 5\%$ origin, expanding to $\pm 22\%$ intermediate, collapsing to $0\%$ at terminus (`ESTIMATED`).
- **Bottleneck Threshold:** $LF \ge 0.90$ (`SCENARIO_MODEL`) — Triggers automated relief bus advisory.
