# YATRA — Phase 5.1 Evidence Integrity, Mathematical Corrections & Jury Readiness Report

## Executive Summary

Phase 5.1 is a targeted engineering correction phase focused on mathematical consistency, evidence integrity, provenance classification, and jury synchronization across the YATRA platform.

This phase did not alter system architecture, introduce new external dependencies, or rebuild existing algorithms. Every modification corrected documented discrepancies between calculations, code, and jury-facing documentation.

---

## 1. Discovered Issues & Root Causes

| Priority | Subsystem | Issue Identified | Root Cause |
| :--- | :--- | :--- | :--- |
| **P1** | EV Feeder Energy Model | Earlier documentation reported 27 complete loops and 154 km range, confusing nominal battery capacity with usable energy | $\lfloor 180 / 6.555 \rfloor = 27$ was calculated using 180 kWh nominal capacity instead of 144 kWh usable energy at 80% depth of discharge |
| **P2** | Crowding Heuristics | Earlier text presented 3.5% ETM sample rate as an authoritative fact and claimed a $\pm 18.5\%$ confidence interval | Conductor ETM records capture an unverified fraction of riders; the 28.5x expansion factor is an uncalibrated planning hypothesis, not an empirical census |
| **P3** | Feeder Road Width Compliance | Road widths were described ambiguously, implying physical street measurements were performed | Network geometry widths are derived from Delhi Master Plan 2021 Right-of-Way planning standards, not physical curb-to-curb field audits |
| **P4** | Origin–Destination Matrix | Earlier text lacked explicit time period and mode share provenance for 546,143 trips | 546,143 trips represents the 3-hour morning peak period (08:00–11:00); 46% Metro / 54% Bus mode split is an aggregate scenario allocation |
| **P5** | Live Telemetry & Latency | Discrepancy between reported 1,394 ms latency and under 50 ms decoding claim | Conflation of external WAN HTTP network round-trip time (1.4s–4.7s) with local Protobuf binary decoding compute (2.27 ms) |
| **P6** | Traffic Model Validation | Error metrics (MAE 6.71 min, RMSE 8.56 min) were previously conflated with real-time GPS road accuracy | Historical GPS traces are absent from local repository; metric is strictly a timetable-deviation validation against GTFS Static scheduled trips |
| **P7** | Segment Load Conservation | Terminal load residual ($L_n = 0$) was cited as empirical proof of passenger occupancy | Zero terminal residual is an enforced mathematical boundary condition ($\sum B = \sum A$) of the flow conservation model, not field validation |

---

## 2. Before & After Mathematical Calculations

### 2.1 Problem 4: Electric Feeder Bus Energy Model

Parameters:

- Nominal battery capacity: $180\text{ kWh}$
- Usable depth of discharge (DoD): $80\%$ ($0.80$)
- Specific energy consumption: $1.15\text{ kWh/km}$
- Average feeder loop distance: $5.7\text{ km}$
- Depot fast charger power: $60\text{ kW}$
- Opportunity charging session: $45\text{ min}$ ($0.75\text{ h}$)
- Charger efficiency: $92\%$ ($0.92$)

```text
Calculation Comparison:

Metric                                       Previous (Flawed)             Phase 5.1 (Corrected)
------------------------------------------------------------------------------------------------
Usable Battery Capacity                      180.0 kWh (Nominal conflated) 144.0 kWh (180 * 0.80)
Energy per 5.7 km Loop                       6.56 kWh                      6.555 kWh (reported 6.56 kWh)
Complete Loops Before Recharge               27 complete loops             21 complete loops (floor(144 / 6.555))
Operational Revenue Distance                 153.9 km                      119.7 km (21 * 5.7 km)
Theoretical Maximum Operating Distance       156.5 km                      125.22 km (144 / 1.15)
45-Min Opportunity Charge (Lossless)         45.0 kWh                      45.0 kWh (60 * 0.75)
Additional Distance from Charging (Lossless) +39.1 km                      +39.13 km (45 / 1.15)
Additional Loops from Charging (Lossless)    6 loops                       6 complete loops (floor(45 / 6.555))
45-Min Opportunity Charge (Net at 92% Eff)   Not modeled                   41.40 kWh (45 * 0.92)
Additional Distance from Charging (Net)      Not modeled                   +36.00 km (41.40 / 1.15)
Additional Loops from Charging (Net)         Not modeled                   6 complete loops (floor(41.40 / 6.555))
```

### 2.2 Problem 3: Origin–Destination Matrix Provenance

```text
Parameter                                    Previous Interpretation       Phase 5.1 Grounded Specification
------------------------------------------------------------------------------------------------
Total Matrix Trip Volume                     546,143 (unspecified period)  546,143 trips in 3-hour morning peak (08:00–11:00)
DMRC Metro Rail Mode Share                   46% (251,226 trips/h census)  46% (251,226 trips) modeled scenario allocation
DTC Surface Bus Mode Share                   54% (294,917 trips/h census)  54% (294,917 trips) modeled scenario allocation
Furness IPF Convergence                      Iterative convergence proof   Mathematical balancing of marginals; does not prove true OD
```

---

## 3. Code Modifications & Schema Synchronization

The following files were modified to ensure complete architectural and mathematical integrity:

1. `services/api/app/schemas/analytics.py`:
   - Updated `CrowdingEstimateResponse`: added `sample_rate_status`, `uncertainty_rating`, updated `provenance`.
   - Updated `OdMatrixResponse`: added `time_period_description`, `mode_share_note`, `convergence_explanation`, and trip volume breakdown fields.
   - Updated `RoadWidthCheckResponse`: added `planning_width_row_m`, `field_measured_width_m: None`, `width_provenance`, `is_field_verified: False`, and `compliance_disclosure`.
   - Updated `FeederEvEnergyResponse`: added `usable_depth_of_discharge: 0.80`, `complete_loops_before_recharge: 21`, `theoretical_range_km: 125.22`, `opportunity_charging_energy_kwh: 45.0`, `opportunity_charging_additional_range_km: 39.13`, `opportunity_charging_additional_loops: 6`, `opportunity_charging_net_energy_kwh: 41.40`, `opportunity_charging_net_range_km: 36.00`, `opportunity_charging_net_loops: 6`, `charger_efficiency: 0.92`, and `epistemic_classification: "SCENARIO_MODEL"`.
   - Updated `SegmentLoadResponse`: added `terminal_residual_explanation`.

2. `services/api/app/engines/feeder_optimizer.py`:
   - Enforced default canonical loop distance of $5.7\text{ km}$ when `route_id` and `loop_distance_km` are omitted.
   - Enforced exact EV formulas: $144.0\text{ kWh}$ usable battery, $\lfloor 144 / 6.555 \rfloor = 21$ complete loops, $125.22\text{ km}$ theoretical single-charge range, $45.0\text{ kWh}$ ideal ($41.40\text{ kWh}$ net) opportunity charging with $+39.13\text{ km}$ ($+36.00\text{ km}$ net) and 6 additional loops.
   - Handled negative or zero inputs safely without zero-division exceptions.
   - Designated road widths as `MPD_2021_ROW_ESTIMATED` with `is_field_verified: False`.

3. `services/api/app/engines/crowding_engine.py`:
   - Classified 28.5x expansion factor as `UNVERIFIED_PLANNING_HYPOTHESIS`.
   - Removed presentation of $\pm 18.5\%$ confidence interval.
   - Surfaced explicit required disclosure regarding uncalibrated ETM sampling.

4. `services/api/app/engines/od_engine.py`:
   - Designated 546,143 trips as the 3-hour morning peak period (`AM_PEAK`, 08:00–11:00).
   - Added mode share scenario note and Furness IPF convergence disclaimer.

5. `services/api/app/engines/segment_load_engine.py`:
   - Added input validation for `boardings_input` and `alightings_input` (empty checks, length checks, clamping negative inputs to $\ge 0.0$).
   - Supported dynamic synthetic stops when `route_stops` is not present in GTFS.
   - Added explicit explanation that terminal residual is an enforced model boundary condition ($\sum B = \sum A$).

6. `apps/operator-web/src/components/screens/GovtIntelligenceView.tsx`:
   - Updated Problem 2 card with uncalibrated ETM sampling disclaimer.
   - Updated Problem 3 card with 3-hour morning peak description and IPF convergence note.
   - Updated Problem 4 card with planning width badge, $\ge 6.0\text{ m}$ standard, field audit disclosure, and corrected EV energy metrics ($144\text{ kWh}$ usable, 21 loops, $125.2\text{ km}$ range, $+45\text{ kWh}$ opportunity top-up).
   - Updated Problem 5 card with boundary condition explanation.

7. `services/api/app/tests/`:
   - `test_problem4_feeder_optimizer.py`: updated canonical EV assertions ($144\text{ kWh}$, 21 loops, $125.22\text{ km}$ range, $+45\text{ kWh}$, $+39.13\text{ km}$); added edge-case testing for zero/negative length.
   - `test_problem5_segment_loads.py`: added boundary condition tests, empty boarding checks, mismatched length checks, and negative boarding clamping.
   - `test_problem2_crowding.py`: validated uncalibrated status, heuristic rating, and absence of fabricated margin.
   - `test_analytics_endpoints.py`: validated API response matches corrected EV values.

---

## 4. Verification & Test Results

All verification suites executed cleanly with zero failures:

1. **Backend Unit & Regression Test Suite:**
   - Command: `& .venv\Scripts\python.exe -m pytest services/api/app/tests -v`
   - Result: **59 / 59 passed** in 15.03 seconds (100% passing).

2. **End-to-End Platform Integration Test:**
   - Command: `& .venv\Scripts\python.exe scripts/e2e_integration_test.py`
   - Result: **7 / 7 checks passed** (100% spec compliance).

3. **Next.js Production Build:**
   - Command: `cmd.exe /c "cd apps\operator-web && npm run build"`
   - Result: **Compiled clean** with zero TypeScript or Turbopack errors.

4. **Live GTFS-RT Telemetry Ingestion:**
   - Payload: 409,536 bytes
   - Total vehicles: 3,746 (3,716 fresh $\le 300\text{s}$, 30 stale $> 300\text{s}$, 0 missing timestamp)
   - Distinct active routes: 1,356
   - Network WAN latency: $1.4\text{s} \text{ to } 4.7\text{s}$
   - Local Protobuf decode compute: $2.27\text{ ms}$
   - Fleet filtering compute: $11.29\text{ ms}$

---

## 5. Epistemic Classification Summary

| Engine / Component | Epistemic Classification | Justification & Data Status |
| :--- | :---: | :--- |
| **GTFS Static Transit Schedule** | **OBSERVED** | Official DTC/DIMTS feed: 6,862 stops, 2,574 routes, 80,357 trips, 2,737,136 stop times. |
| **GTFS-Realtime Telemetry** | **OBSERVED** | Official Delhi Transport Stack API: 3,746 live vehicle records parsed from binary Protocol Buffers. |
| **Timetable Deviation Validation** | **ESTIMATED** | MAE 6.71 min, RMSE 8.56 min evaluated against 30 scheduled trips in GTFS Static. Not GPS road accuracy. |
| **Relative Crowding Index (RCI)** | **ESTIMATED** | Operational relative heuristic based on scheduled headway and live bunching. Not passenger census. |
| **ETM 28.5x Expansion Factor** | **UNVERIFIED** | Literature-derived planning hypothesis. Uncalibrated against real Delhi ticket transaction dumps. |
| **OD Matrix (546,143 Trips)** | **SCENARIO_MODEL** | 3-hour morning peak period modeled via Furness IPF balancing. Mode split (46% Metro / 54% Bus) is an assumed scenario proportion. |
| **Feeder Road Widths** | **ESTIMATED** | Derived from MPD-2021 Right-of-Way planning standards (`field_measured_width_m: None`). Physical compliance requires field audit. |
| **Feeder Fleet Allocation** | **SCENARIO_MODEL** | 21 EV buses allocated across 7 DMRC hubs under 500-bus policy cap. |
| **EV Battery & Charging Model** | **SCENARIO_MODEL** | 180 kWh nominal, 144 kWh usable (80% DoD), 1.15 kWh/km, 21 loops before recharge, 60 kW DC charging. |
| **Segment Load Terminal Residual** | **ESTIMATED** | Exact 0.0 pax residual is an enforced mathematical model boundary condition ($\sum B = \sum A$), not empirical validation. |

---

## 6. Evaluation of Readiness Score

The platform reports a composite hackathon engineering readiness score of **82.8 / 100**:

$$\text{Composite Score} = \frac{82 + 76 + 86 + 84 + 86}{5} = \mathbf{82.8 \ / \ 100}$$

> [!NOTE]
> This score represents an **internal engineering self-assessment** based on objective audit against hackathon problem requirements. It is not an independently audited, government-certified, or third-party validated score.

---

## 7. Remaining Limitations & Prohibited Jury Claims

To protect technical defensibility during jury presentation, the following claims **must never be made**:

1. **Do not claim GPS accuracy:** Never claim that 6.71 minutes MAE represents model accuracy against real-time GPS road trajectories, because raw historical GPS trajectory breadcrumbs are not present in the local repository. State plainly that it is a timetable-deviation validation evaluated against 30 GTFS Static scheduled trips.
2. **Do not claim passenger headcounts:** Never claim that YATRA measures exact onboard passenger counts or that conductor ETM machines capture exactly 3.5% of riders. State that RCI is a relative operational heuristic and that ETM sampling assumptions are uncalibrated planning hypotheses.
3. **Do not claim field-verified road widths:** Never claim that feeder routes were measured with physical surveying tools or lasers. State that candidate paths satisfy Master Plan for Delhi 2021 Right-of-Way planning standards and that physical carriageway verification is required before deployment.
4. **Do not claim independent OD proof:** Never claim that Furness IPF convergence proves the real-world travel pattern of Delhi citizens. State that IPF balances trip generation and attraction marginals from published aggregate data for the 3-hour morning peak period.
5. **Do not claim passenger occupancy validation from conservation:** Never cite $L_n = 0$ as empirical proof that passenger load estimation is accurate. State that zero residual is an enforced model boundary condition guaranteed by $\sum B = \sum A$.
6. **Do not claim infinite or 154 km single-charge EV range:** Never claim 27 loops or 154 km revenue range on a single charge. State the exact physics: 144 kWh usable energy yields 21 complete loops (119.7 km operating distance) on a 5.7 km circuit, with midday 45-minute opportunity charging adding 6 complete loops (+39.13 km ideal / +36.00 km net).
