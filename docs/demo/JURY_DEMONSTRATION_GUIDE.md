# YATRA — Hackathon Jury Demonstration Guide

This guide provides structured demonstration scripts for presenting YATRA to the Delhi Transport Stack Hackathon evaluation panel and municipal transit authorities. It includes two scripted formats:

- **Format A: Five-Minute Executive Demonstration** (high-level narrative, core problem coverage, live telemetry)
- **Format B: Ten-Minute Technical Deep-Dive** (complete algorithmic walkthrough, mathematical invariants, error metrics, failure resilience)

---

## 1. System Setup & Pre-Flight Checklist

Before the presentation begins, launch the platform locally:

```bash
# Launch backend API, operator web dashboard, and mobile harnesses
.\run_project.bat

# Verify services in your browser:
# 1. Operator Web Portal: http://localhost:3000
# 2. FastAPI Interactive Documentation: http://127.0.0.1:8000/docs
# 3. System Health: http://127.0.0.1:8000/health
```

---

## 2. Format A: Five-Minute Executive Demonstration Script

### Timing Breakdown for Format A

- **00:00 – 00:45 | Introduction & Problem Context**
- **00:45 – 01:45 | Problems 1 & 2: Multimodal Routing & Crowding Intelligence**
- **01:45 – 02:45 | Problems 3 & 4: Macro OD Matrix & Electric Feeder Routing**
- **02:45 – 03:45 | Problem 5 & Live Telemetry: Flow Conservation & 3,746 Buses**
- **03:45 – 05:00 | Accessibility, Jugaad Zero-Cost Architecture & Q&A**

---

### Step-by-Step Five-Minute Script

#### 00:00 – 00:45 | Introduction & Problem Context

- **Screen:** Open `http://localhost:3000` to the **Command centre** tab.
- **Narrative:**
  > "Good morning, members of the jury. Delhi operates over 7,000 buses and carries four million daily passengers across complex multi-modal networks. Yet municipal planners face five persistent challenges: uncalibrated traffic delays, unobserved passenger crowding, coarse origin-destination estimates, feeder buses stuck in narrow streets, and unverified passenger accumulation curves.
  >
  > YATRA solves all five problems using a unified, mathematically rigorous, zero-cost transport intelligence engine. We connect directly to official Delhi Transport Stack feeds without expensive proprietary software licenses."

#### 00:45 – 01:45 | Problems 1 & 2: Routing & Crowding Intelligence

- **Screen:** Click the **Municipal analytics** tab (`#GOVERNMENT`). Scroll to **Problem 1** and **Problem 2**.
- **Narrative:**
  > "For Problem 1, our RAPTOR transit router computes Pareto-optimal itineraries in under 20 milliseconds. Notice our error disclosures: we validate against 30 complete scheduled DTC trips from GTFS Static stop times. In off-peak hours, our Mean Absolute Error is only 2.50 minutes. During peak hours, static timetables schedule identical flat runtimes, whereas our engine models traffic impedance with a 1.45x AM congestion multiplier, yielding an overall MAE of 6.71 minutes.
  >
  > For Problem 2, we reject the practice of inventing false passenger numbers. Because conductor electronic ticketing machines capture only about 3.5% of riders due to women's free Pink Pass travel and unticketed pass holders, we surface a Relative Crowding Index bounded between 0.05 and 0.98, enriched with live bus bunching headway penalties."

#### 01:45 – 02:45 | Problems 3 & 4: Macro OD Matrix & Electric Feeder Routing

- **Screen:** Scroll to **Problem 3** and **Problem 4**. Click the $\gamma = 0.04$ button, then $\gamma = 0.12$.
- **Narrative:**
  > "For Problem 3, we estimate the seven-zone Delhi origin-destination matrix for the 3-hour morning peak period (08:00–11:00, 546,143 modeled trips) using Furness Iterative Proportional Fitting. It balances trip generation and attraction identically in four iterations with zero trip marginal discrepancy. By toggling the distance friction parameter from 0.08 to 0.04, you can see inter-zonal travel share expand from 74.8% to 82.1%. We explicitly disclose that Furness IPF balances generation and attraction marginals, but its convergence does not independently establish the true passenger origin-destination distribution.
  >
  > For Problem 4, our feeder optimizer routes 21 electric buses across seven metro hubs under the 500-bus ceiling. Crucially, candidate paths satisfy the model's 6-metre planning-width constraint using MPD-2021 planning estimates, while unknown-width roads are rejected; physical carriageway compliance requires field verification."

#### 02:45 – 03:45 | Problem 5 & Live Telemetry: Flow Conservation & 3,746 Buses

- **Screen:** Scroll to **Problem 5**, then click the **Fleet operations** tab (`#FLEET`).
- **Narrative:**
  > "For Problem 5, on Route 502 from Kashmere Gate to Mehrauli, we enforce the directional passenger flow conservation equation: $L_i = L_{i-1} + B_i - A_i$. The terminal residual balances to exactly 0.0 passengers as an enforced mathematical model boundary condition ($\sum B = \sum A$), not an empirical field validation. Notice our shaded uncertainty envelope: we honestly show that intermediate segment loads carry a plus-minus 15 to 22% confidence margin due to inferred alightings.
  >
  > Now look at our live fleet: this is live telemetry from the official Delhi Transport Stack endpoint. Over 3,700 live buses are parsed directly from binary Protocol Buffers in just 2.3 milliseconds. Notice our fallback badge and fresh versus stale indicators: we never claim stale positions are live."

#### 03:45 – 05:00 | Accessibility, Jugaad Zero-Cost Architecture & Wrap-Up

- **Screen:** Click the **Assistance queue** tab (`#ASSISTANCE`).
- **Narrative:**
  > "Finally, YATRA integrates dignity and accessibility into daily transit operations. When a wheelchair user requests ramp assistance at a stop, the approaching driver receives an audible, high-contrast AccessHandshake alert in their cab interface. Every completed deployment is cryptographically verified on our trust ledger.
  >
  > Best of all, YATRA’s monthly software license cost is exactly zero dollars. We use DuckDB, Polars, OpenStreetMap, MapLibre, and Google OR-Tools running locally. Thank you, and we welcome your questions."

---

## 3. Format B: Ten-Minute Technical Deep-Dive Script

### Timing Breakdown for Format B

- **00:00 – 01:30 | Technical Architecture, Data Provenance & Jugaad Foundation**
- **01:30 – 03:00 | Problem 1: RAPTOR Engine, Timetable Deviation & Dwell Modeling**
- **03:00 – 04:30 | Problem 2: ETM Sampling Limits, RCI Formulation & Bunching Penalty**
- **04:30 – 06:00 | Problem 3: Furness IPF Convergence, Marginal Conservation & Sensitivity**
- **06:00 – 07:30 | Problem 4: Feeder Geometry, IRC:73 Compliance & EV Energy Model**
- **07:30 – 09:00 | Problem 5: Conservation Identity $L_n = 0$, Uncertainty & Relief Advisories**
- **09:00 – 10:00 | Live GTFS-RT Binary Ingestion, Failure Resilience & Code Verification**

---

### Step-by-Step Ten-Minute Technical Walkthrough

#### 00:00 – 01:30 | Technical Architecture & Data Provenance

- **Demonstration:**
  - Show the terminal and run `git status -s` and `.venv\Scripts\python.exe scripts/e2e_integration_test.py`.
  - Highlight that 57 backend tests and all 7 end-to-end checks pass cleanly.
- **Talking Points:**
  - Emphasize the five epistemic categories: `OBSERVED`, `ESTIMATED`, `SYNTHETIC`, `SCENARIO_MODEL`, and `UNVERIFIED`.
  - Explain the Jugaad architecture: DuckDB and Polars columnar processing replace commercial data warehouses; MapLibre GL replaces paid map APIs; Google OR-Tools replaces commercial mathematical solvers ($9,250 to $19,700 monthly savings).

#### 01:30 – 03:00 | Problem 1: Journey Intelligence & Timetable Deviation

- **Demonstration:**
  - Open `http://localhost:3000` -> **Municipal analytics** -> **Problem 1**.
  - Show empirical metrics: Sample size = 30 scheduled trips; Overall MAE = 6.71 min; RMSE = 8.56 min; MAPE = 12.91%; Off-peak MAE = 2.50 min; Peak MAE = 13.03 min.
- **Talking Points:**
  - Explain why peak error is higher: DTC GTFS static schedules have identical flat runtimes across 06:00 and 08:30 trips. The model applies a 1.45x AM congestion multiplier that reflects actual traffic impedance.
  - Explain the accessibility factor: hydraulic wheelchair ramp deployment adds $+35\text{s}$ dwell time, preventing unrealistic tight transfers.

#### 03:00 – 04:30 | Problem 2: Crowding Inference & RCI Heuristic

- **Demonstration:**
  - Scroll to **Problem 2: Relative Crowding Index**.
  - Show RCI score of 0.54 (Moderate) and headway bunching deviation of 0.18.
- **Talking Points:**
  - Provide the mathematical formulation of RCI:

    $$\text{RCI}_i = \min\left(0.98, \max\left(0.05, \text{RCI}_{\text{base}} \cdot (1 + \beta \cdot P_h)\right)\right)$$

  - Address the conductor ETM sampling reality: ~3.5% capture due to women's fare-free Pink Passes and unticketed pass holders. The system exposes relative comfort tiers rather than pretending to count heads.

#### 04:30 – 06:00 | Problem 3: Origin-Destination Matrix & Sensitivity Analysis

- **Demonstration:**
  - Scroll to **Problem 3: Origin-Destination Matrix**.
  - Click through $\gamma = 0.04$, $0.08$, and $0.12$. Observe the live recalculation.
- **Talking Points:**
  - Explain the Furness biproportional IPF algorithm:

    $$T_{ij}^{(k+1)} = T_{ij}^{(k)} \cdot \frac{G_i}{\sum_j T_{ij}^{(k)}} \cdot \frac{A_j}{\sum_i T_{ij}^{(k)}}$$

  - Point out that 3-hour morning peak period (08:00–11:00) modeled trip generation ($546,143$) exactly matches attraction ($546,143$) with 0 discrepancy in 4 iterations.
  - Highlight the mode split: 46% DMRC Metro rail ($251,226\text{ trips}$) versus 54% DTC surface bus ($294,917\text{ trips}$) modeled scenario allocation based on published aggregate reports.

#### 06:00 – 07:30 | Problem 4: Feeder Bus & Electric Fleet Optimization

- **Demonstration:**
  - Scroll to **Problem 4: Feeder Optimization**.
  - Click through headways: $6\text{m}$, $8\text{m}$, $10\text{m}$, $12\text{m}$, $15\text{m}$.
  - Show EV Energy Model card: 180 kWh nominal battery (144 kWh usable at 80% DoD), 1.15 kWh/km, 21 complete loops before recharge ($119.7\text{ km}$ revenue distance), 125.22 km theoretical single-charge range, 45 kWh opportunity charging (+39.13 km / 6 loops; net 41.40 kWh / +36.00 km at 92% efficiency).
- **Talking Points:**
  - Explain the geometric constraint enforcement: Indian Roads Congress IRC:73 requires $\ge 6.0\text{ m}$ carriageway for 9-meter buses. Roads satisfy planning estimates from MPD-2021; unverified roads are rejected; physical compliance requires field audit.
  - Demonstrate operational feasibility: 21 EV buses allocated under the 500-bus cap ($4.2\%$ utilization) maintaining 8–12 minute headways.

#### 07:30 – 09:00 | Problem 5: Segment Load Accumulation & Invariant Proof

- **Demonstration:**
  - Scroll to **Problem 5: Segment Loads**.
  - Show Route 502 (38 stops, Kashmere Gate to Mehrauli).
  - Point out the terminal residual: balances to exactly $0.0\text{ passengers}$ as an enforced model boundary condition ($\sum B = \sum A$).
  - Highlight peak load: Red Fort to Delhi Gate ($37.2\text{ pax}$, bottleneck advisory).
- **Talking Points:**
  - Explain the physical flow conservation identity:

    $$L_i = L_{i-1} + B_i - A_i \quad \text{with } L_0 = 0 \text{ and } L_n = 0$$

  - Explain the gravity alighting model: because bus passengers do not tap out on single-door buses, alightings are inferred via downstream destination attraction. The terminal zero load is a mathematical model boundary condition, not empirical field validation.
  - Point out the uncertainty interval: $\pm 5\%$ at origin, expanding to $\pm 22\%$ intermediate, collapsing to $0\%$ at terminus.

#### 09:00 – 10:00 | Live GTFS-RT Telemetry, Resilience & Failure Modes

- **Demonstration:**
  - Click the **Fleet operations** tab (`#FLEET`).
  - Show live feed telemetry: 3,746 active vehicles, 3,716 fresh, 30 stale, 1,356 routes.
  - Show the latency breakdown: remote network RTT ($1.4\text{s} \text{--} 4.6\text{s}$) vs local Protobuf binary decoding ($2.27\text{ ms}$).
  - Toggle interval buttons ($5\text{s}, 15\text{s}, 30\text{s}, \text{Off}$) and click **Poll now**.
- **Talking Points:**
  - Explain failure mode handling: verified with automated tests covering timeout, HTTP 401 unauthorized, malformed Protobuf, empty responses, and stale feed detection (> 300s).
  - Show that if live telemetry fails, the UI gracefully displays a schedule baseline banner without claiming stale data is fresh or crashing.

---

## 4. Key User Journeys Verification Matrix

| Problem | User Action | Expected Output | Verification Status |
| :--- | :--- | :--- | :---: |
| **P1** | Enter Kashmere Gate to AIIMS at 08:30 with ramp assistance | Route 502 (40.6 min), $+35\text{s}$ dwell penalty, MAE 6.71 min | Verified via `/api/v1/analytics/journey/plan` |
| **P2** | View Route 502 crowding and bunching profile | RCI 0.54 (Moderate), bunching dev 0.18, transparent ETM disclaimer | Verified via `/api/v1/analytics/crowding` |
| **P3** | Select $\gamma = 0.04$, $0.08$, $0.12$ friction decay | Live recalculation of inter-zonal share (82.1% to 66.5%) | Verified via `/api/v1/analytics/od-sensitivity` |
| **P4** | Select headway 6m to 15m; inspect road width compliance | Fleet required (52 to 22 $\le 500$); $100\%$ width $\ge 6.0\text{ m}$ | Verified via `/api/v1/analytics/feeder-sensitivity` |
| **P5** | Inspect Route 502 stop-by-stop accumulation | $L_n = 0.0\text{ pax}$ residual, $\pm 5\text{--}22\%$ uncertainty interval | Verified via `/api/v1/analytics/segment-loads` |
| **Live** | Inspect fleet monitor and toggle polling interval | 3,746 buses, fresh vs stale split, fallback banner, 2.3ms decode | Verified via `/api/v1/realtime/health` & fleet |
