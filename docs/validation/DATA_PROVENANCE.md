# YATRA — Data Provenance Register

This document provides a transparent audit of every data asset, model parameter, and empirical calculation used in YATRA. In accordance with Phase 4 standards, all inputs and outputs are classified into five explicit epistemic categories:

- **OBSERVED**: Directly available from an authoritative source.
- **ESTIMATED**: Derived using a documented mathematical model.
- **SYNTHETIC**: Generated for testing or demonstration purposes.
- **SCENARIO_MODEL**: Based on declared engineering assumptions.
- **UNVERIFIED**: Source or measurement has not been confirmed by authoritative records.

---

## 1. Primary Data Asset Classification Table

| Asset Name | Repository Path | Format | Record Count / Scale | Provenance Classification | Source & Authority |
| :--- | :--- | :---: | :---: | :---: | :--- |
| **Delhi GTFS Static** | `data/gtfs/` | CSV / Text | 8 files (169 MB total)<br>6,862 stops, 2,574 routes<br>80,357 trips, 2,737,136 stop times | **OBSERVED** | Official Delhi Transport Corporation (DTC) and Delhi Integrated Multi-Modal Transit System (DIMTS) schedule feed via Open Transit Data (OTD) Delhi. |
| **Delhi GTFS-Realtime** | `services/api/app/integrations/gtfs_rt/` | Protocol Buffer v2.0 | ~400 KB per snapshot<br>3,746 active vehicles<br>3,716 fresh / 30 stale<br>1,356 active routes | **OBSERVED** | Official Delhi Transport Stack (DTS) live API (`VehiclePositions.pb`). Authenticated via `x-api-key` header. Configured bounding box `[28.0, 29.2] N, [76.5, 77.8] E` (Delhi NCR regional boundary, 99.97% in-bounds). |
| **Historical GPS Telemetry** | `data/gps/` | None (`.gitkeep`) | 0 records locally | **UNVERIFIED** | High-frequency (10-second) historical AVL trajectory breadcrumbs are not present in the local repository. Citywide average speeds ($28\text{ km/h}$) are derived from scheduled runtimes, not empirical map matching. |
| **ETM Ticketing Transactions** | `data/ticketing/` | None (`.gitkeep`) | 0 records locally | **UNVERIFIED** | Raw conductor Electronic Ticketing Machine transaction transaction dumps are not present in the local repository. The $28.5\times$ expansion factor is an uncalibrated literature hypothesis; individual ticket counts are not treated as true passenger volumes. |
| **Transit Analysis Zones (TAZ)** | `services/api/app/engines/od_engine.py` | Geometric Polygons | 7 macro zones | **ESTIMATED** | Aggregated from Delhi Master Plan (MPD-2021) Zonal Development Plans (Zones A through P) into 7 major travel sectors. Centroids represent primary multi-modal interchange hubs. |
| **Zone Trip Generations & Attractions** | `services/api/app/engines/od_engine.py` | Tabular Marginals | 7 generation / attraction pairs | **ESTIMATED** | Calibrated against DTC depot dispatch statistics (4.28M daily boardings) and DMRC daily ridership records. AM peak hour marginal totals ($546,143$ passenger trips) preserve row/column balance identically. |
| **DMRC Metro Ridership Split** | `services/api/app/engines/od_engine.py` | Mode Share Proportion | 46% Rail / 54% Bus | **ESTIMATED** | Calibrated from published Delhi Master Plan (MPD-2021) and DMRC operational reports. Rail volume ($251,226\text{ trips/h}$) is grounded in observed station gate counts, whereas Bus volume ($294,917\text{ trips/h}$) is an estimated residual. |
| **Road Network Geometry & Widths** | `services/api/app/engines/feeder_optimizer.py` | Directed Spatial Graph | 32 nodes, 48 edges | **ESTIMATED** | Geometry represents arterial corridors connecting 7 DMRC Metro interchange hubs. Carriageway widths are assigned using Delhi Master Plan 2021 Right-of-Way (RoW) minimum standards. Roads without verified records are marked unknown and rejected by the routing engine. |
| **Physical Accessibility Audit** | `data/sample/sample_stops.json` | JSON | 4 stops | **SYNTHETIC** | Field audit fixture recording curb height (cm), ramp presence, tactile paths, and audio beacons for sample stops on Route 502 (Kashmere Gate, Red Fort, Delhi Gate, AIIMS). Citywide curb data is not available. |
| **Unit Test Fixtures** | `services/api/app/tests/` | Mock Data / Fixtures | 52 test scenarios | **SYNTHETIC** | Synthetic Protobuf payloads, corrupt coordinate tests, and out-of-bounds boundary fixtures used exclusively to verify code paths and error handling. |

---

## 2. Model Parameter Classification and Mathematical Basis

### 2.1 Problem 1 — Bus Traffic Engine & Timetable Validation
- **Free-Flow Cruise Speed ($28\text{ km/h}$):** `ESTIMATED` — Derived from off-peak GTFS schedule intervals across arterial corridors.
- **Baseline Stop Dwell Time ($25\text{s}$):** `ESTIMATED` — Standard urban bus boarding dwell time in Delhi operations.
- **Hydraulic Wheelchair Ramp Deployment ($+35\text{s}$):** `SCENARIO_MODEL` — Operating standard for low-floor kneeling bus ramp extension and wheelchair boarding.
- **AM Peak Congestion Multiplier ($1.45\times$):** `SCENARIO_MODEL` — Empirical engineering assumption for 08:00–11:00 peak traffic; uncalibrated against raw GPS breadcrumbs.
- **PM Peak Congestion Multiplier ($1.55\times$):** `SCENARIO_MODEL` — Empirical engineering assumption for 17:00–20:30 peak traffic; uncalibrated against raw GPS breadcrumbs.
- **Midday Shoulder Multiplier ($1.18\times$):** `SCENARIO_MODEL` — Empirical assumption for 11:30–16:30.
- **Timetable Deviation Validation:** Evaluated against 30 complete scheduled bus trips in `data/gtfs/stop_times.txt`. Overall MAE is $6.71\text{ min}$, RMSE is $8.56\text{ min}$, and MAPE is $12.91\%$. This validates adherence to the scheduled timetable, not observed real-time road traffic speeds.

### 2.2 Problem 2 — Crowdedness-Aware Journey Planning
- **Relative Crowding Index (RCI):** `ESTIMATED` — Bounded normalized index in $[0.05, 0.98]$ reflecting expected comfort based on route frequency, corridor demand, and live headway deviation.
- **Conductor ETM Expansion Factor ($28.5\times$):** `UNVERIFIED` — Based on a literature hypothesis of ~3.5% electronic ticket capture due to Pink Pass fare exemption and monthly pass usage. Exposed with explicit uncertainty bounds; never presented as verified absolute passenger occupancy.
- **Headway Deviation Penalty:** `ESTIMATED` — Formulated as $P_h = \max(0, (H_{\text{obs}} - H_{\text{sched}}) / H_{\text{sched}})$, capturing bunching probability from live GTFS-RT feed intervals.
- **Pareto Route Ranking:** `ESTIMATED` — Multi-objective dominance sort ranking itineraries along three explicit axes: Fastest ($T$), Least Crowded ($\text{RCI}$), and Most Accessible ($A$).

### 2.3 Problem 3 — Transit Origin–Destination (OD) Matrix
- **Furness Iterative Proportional Fitting (IPF):** `ESTIMATED` — Biproportional algorithm balancing zonal trip generations $G_i$ and attractions $A_j$ against spatial impedance $f(d_{ij})$. Converges in 4 iterations with 0 trip marginal discrepancy.
- **Distance Friction Factor ($\gamma = 0.08\text{ /km}$):** `ESTIMATED` — Exponential distance decay $f(d_{ij}) = \exp(-\gamma \cdot d_{ij})$ calibrated to Delhi urban travel surveys (trip lengths 3–25 km).
- **Gamma Sensitivity Range ($\gamma \in [0.04, 0.12]$):** `SCENARIO_MODEL` — Demonstrates model sensitivity: $\gamma = 0.04$ yields $82.1\%$ inter-zonal share; $\gamma = 0.08$ yields $74.8\%$; $\gamma = 0.12$ yields $66.5\%$.
- **Mode Split (46% Metro / 54% Bus):** `ESTIMATED` — Grounded in DMRC daily passenger gate telemetry ($2.8\text{M}$ to $3.2\text{M}$ weekday trips) and DTC daily boardings ($4.1\text{M}$ to $4.3\text{M}$).

### 2.4 Problem 4 — Metro Feeder Route & Fleet Optimization
- **Minimum Carriageway Width ($\ge 6.0\text{ m}$):** `SCENARIO_MODEL` — Regulatory threshold from Indian Roads Congress (IRC:73 / IRC:86) and UTTIPEC guidelines for 9-meter midi-buses. Roads with unknown width are strictly rejected as non-compliant.
- **Maximum Feeder Loop Length ($\le 7.0\text{ km}$):** `SCENARIO_MODEL` — Operational planning cap to maintain 8–12 minute headways without vehicle bunching.
- **Feeder Fleet Budget Cap ($\le 500\text{ vehicles}$):** `SCENARIO_MODEL` — Policy constraint for dedicated metro feeder operations; current optimization allocates 21 EV buses across 7 candidate loops ($4.2\%$ of cap).
- **EV Battery Capacity ($180\text{ kWh}$ nominal):** `SCENARIO_MODEL` — Standard 9-meter midi-bus specification with 80% usable Depth of Discharge ($144\text{ kWh}$).
- **EV Specific Energy Consumption ($1.15\text{ kWh/km}$):** `SCENARIO_MODEL` — Empirical urban bus consumption under Delhi summer auxiliary AC load conditions.
- **Depot DC Fast Charging ($60\text{ kW}$):** `SCENARIO_MODEL` — Depot charging profile with a 45-minute midday opportunity boost ($45\text{ kWh}$ replenishment).

### 2.5 Problem 5 — Segment-Level Passenger Crowding
- **Passenger Flow Conservation Equation:** `ESTIMATED` — Exact physical balance identity $L_i = L_{i-1} + B_i - A_i$ with boundary conditions $L_0 = 0$ and $L_n = 0$. Holds identically across Route 502 (38 stops) with $0.0$ passenger residual.
- **Intermediate Alighting Distribution:** `ESTIMATED` — Inferred via destination gravity decay because single-door ETMs only record boarding points.
- **Propagating Uncertainty Intervals:** `ESTIMATED` — Surfaced in API and UI from $\pm 5\%$ at origin stop, expanding to $\pm 22\%$ across intermediate segments, and collapsing to $0\%$ at terminus.
- **Bottleneck Threshold ($LF \ge 0.90$):** `SCENARIO_MODEL` — Critical load factor alert triggering operational relief bus dispatches.

---

## 3. Data Integrity and Verification Protocol

1. **Zero Data Fabrication**: Missing datasets (raw historical GPS breadcrumbs, full conductor ETM transaction dumps, citywide curb measurements) are explicitly identified as missing or unverified rather than simulated with fake data.
2. **Explicit Labeling Across Interfaces**: Every API response schema and UI visualization screen explicitly badges data elements with their provenance classification (`OBSERVED`, `ESTIMATED`, `SYNTHETIC`, `SCENARIO_MODEL`, or `UNVERIFIED`).
3. **Reproducibility**: All calculations, error metrics, and invariants can be recomputed by running `scripts/validate_models.py` and `scripts/e2e_integration_test.py` against the repository data.
