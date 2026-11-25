# YATRA — Hackathon Jury Demonstration Script

## Demonstration Overview

- **Audience:** Delhi Transport Stack Hackathon Jury, Municipal Transit Authorities (DTC/DIMTS), Technical Evaluators
- **Duration:** 10 to 12 minutes
- **Core Narrative:** A production-grade, zero-cost transport intelligence platform solving all five hackathon problem statements through verified mathematical algorithms, official Delhi GTFS feeds, live vehicle telemetry, and dignified accessibility integration.
- **Epistemic Standard:** Transparent distinction between observed data, estimated models, scenario models, and documented data limitations.

---

## Pre-Flight Setup & Health Verification

Run the unified startup batch script from the repository root or launch services independently:

```bash
# 1. Start the complete platform via batch script
.\run_project.bat

# 2. Or verify backend health directly in a terminal
curl http://127.0.0.1:8000/health
# Response: {"status":"healthy","version":"1.0.0"}

# 3. Verify operator portal web interface
# Open: http://localhost:3000 in your browser
```

---

## Demonstration Walkthrough

### Section 0: System Architecture & Zero-Cost Jugaad Foundation (1 Minute)

- **Action:** Open the terminal and show `docs/engineering/COST_AND_RESOURCE_ESTIMATES.md` or display the Architecture diagram.
- **Speaking Points:**
  - "YATRA was engineered from first principles under a strict zero-cost Jugaad constraint. Public transit agencies operate under tight municipal budgets. Rather than relying on commercial routing APIs, cloud data warehouses, or proprietary transit solvers that cost thousands of dollars per month, YATRA runs entirely on open-source and local-first software."
  - "Routing is executed via an in-memory Python RAPTOR engine in under 20 milliseconds."
  - "Analytics are powered by embedded DuckDB and Polars columnar processing rather than cloud warehouses."
  - "Geospatial mapping uses OpenStreetMap and MapLibre GL rather than paid per-load map SDKs."
  - "Optimization runs on Google OR-Tools rather than commercial mathematical solvers."
  - "Total monthly operational software cost: exactly $0."

---

### Section 1: Multimodal Journey Intelligence (Problem 1) (2 Minutes)

- **Action:** In the Operator Portal (`http://localhost:3000`), click the **Analytics** tab and select the **Problem 1: Traffic Model & Journey Planner** card. Alternatively, execute a live journey plan query in the API docs (`http://127.0.0.1:8000/docs#/analytics/plan_journey_api_v1_analytics_journey_plan_post`).
- **Input Parameters:**
  - Origin: `28.6675, 77.2285` (Kashmere Gate ISBT)
  - Destination: `28.5684, 77.2078` (AIIMS New Delhi)
  - Departure Time: `08:30` (AM Peak)
  - Accessibility Requirement: `Wheelchair Ramp = True`
- **What Appears on Screen:**
  - Three ranked itineraries: Fastest, Least Crowded, and Most Accessible.
  - Travel time breakdown: Free-flow run time, AM peak congestion multiplier ($1.45\times$), and hydraulic wheelchair ramp deployment dwell adjustment ($+35\text{s}$).
  - Empirical error card: Timetable deviation MAE ($6.71\text{ min}$), RMSE ($8.56\text{ min}$), and MAPE ($12.91\%$) against 30 complete scheduled DTC trips from `data/gtfs/stop_times.txt`.
- **Key Speaking Points:**
  - "Notice the empirical disclosure: we distinguish between timetable deviation validation and real-world traffic prediction. The static GTFS schedule assumes flat runtimes throughout the day. Our engine models peak-hour speed degradation ($1.45\times$ AM, $1.55\times$ PM) while explicitly disclosing these multipliers as empirical prior assumptions."
  - "For wheelchair accessibility, boarding dwell time is increased by 35 seconds to account for ramp extension, preventing schedule failures for passengers with disabilities."

---

### Section 2: Relative Crowding & Comfort Index (Problem 2) (1.5 Minutes)

- **Action:** Navigate to **Problem 2: Crowding & Comfort** on the analytics console.
- **What Appears on Screen:**
  - Route crowding table for key corridors (Route 502, Route 102A, Route 419).
  - Relative Crowding Index (RCI) bounded in $[0.05, 0.98]$.
  - Vehicle comfort bands: Low ($< 0.40$), Moderate ($0.40\text{--}0.70$), Heavy ($0.70\text{--}0.85$), Crush ($> 0.85$).
  - Live bunching penalty derived from vehicle headway deviation in the GTFS-RT feed:
    $$P_h = \max\left(0, \frac{H_{\text{obs}} - H_{\text{sched}}}{H_{\text{sched}}}\right)$$

- **Key Speaking Points:**
  - "Notice our epistemic honesty regarding conductor ticketing data. Conductor ETM records capture an unverified fraction of riders; the 28.5x expansion factor is an uncalibrated planning hypothesis. We do not claim exact onboard passenger counts. Instead, we compute a Relative Crowding Index as a relative operational heuristic with transparent uncertainty classification."
  - "When a bus falls behind schedule, passenger queues accumulate at downstream stops. Our engine penalizes bunched vehicles and reroutes passengers to following buses with available capacity."

---

### Section 3: Transit Origin–Destination (OD) Matrix (Problem 3) (2 Minutes)

- **Action:** Navigate to **Problem 3: Origin-Destination Matrix** on the analytics console.
- **What Appears on Screen:**
  - $7 \times 7$ inter-zonal passenger flow matrix across Delhi Transit Analysis Zones (North, Central, South, East, West, Rohini, Mehrauli).
  - Mode share breakdown: 46% DMRC Metro rail ($251,226\text{ trips}$) vs 54% DTC surface bus ($294,917\text{ trips}$) modeled scenario allocation for the 3-hour morning peak period (08:00–11:00).
  - Interactive $\gamma$ friction factor selector ($0.04, 0.08, 0.12$) showing demand sensitivity.
  - GeoJSON desire line vector overlay connecting zonal centroids across Delhi.
- **Key Speaking Points:**
  - "The OD matrix represents the 3-hour morning peak period (08:00–11:00) with 546,143 modeled trips, balanced using Furness Iterative Proportional Fitting (IPF). It converges in exactly 4 iterations with zero trip marginal discrepancy. We explicitly disclose that Furness IPF balances generation and attraction marginals, but its convergence does not independently establish the true passenger OD distribution."
  - "We separate observed DMRC metro gate entries from estimated surface bus boardings. Notice the interactive sensitivity slider: switching $\gamma$ from $0.08$ to $0.04$ increases inter-zonal trip sharing from $74.8\%$ to $82.1\%$, allowing municipal planners to test long-distance fare policy impacts."

---

### Section 4: Metro Feeder Route & Fleet Optimization (Problem 4) (2 Minutes)

- **Action:** Navigate to **Problem 4: Feeder Bus Optimization** on the analytics console.
- **What Appears on Screen:**
  - 7 optimized circular feeder loops centered on major DMRC interchange stations (Kashmere Gate, Hauz Khas, Rajiv Chowk, Anand Vihar, Janakpuri West, Botanical Garden, Netaji Subhash Place).
  - Regulatory compliance metrics:
    - Route length: All loops $\le 7.0\text{ km}$ (longest candidate is $6.1\text{ km}$).
    - Carriageway planning width: $100\%$ of feeder roads meet $\ge 6.0\text{ m}$ MPD-2021 planning standards (`field_measured_width_m: None`, physical compliance requires field audit).
    - Fleet allocation: 21 electric buses allocated out of the $500\text{ bus}$ policy cap.
  - Carriageway check interactive tool: Enter road `RD_DELHI_GATE_01` (12.0m planning width -> eligible); enter `RD_OLD_DELHI_ALLEY_09` (4.2m planning width -> rejected); enter unverified road (unknown -> rejected).
  - Electric bus operational feasibility card: 180 kWh nominal battery (144 kWh usable at 80% DoD), 1.15 kWh/km consumption, 21 complete loops before recharge (119.7 km revenue distance), 125.22 km theoretical range, 60 kW DC depot fast charger with 45-minute midday opportunity boost (+45 kWh ideal / +41.40 kWh net, +39.13 km / 6 loops).
- **Key Speaking Points:**
  - "Many automated routing algorithms select narrow alleys where 9-meter buses cannot physically turn. YATRA strictly enforces Indian Roads Congress standards: candidate paths satisfy the 6-metre planning-width constraint using MPD-2021 planning estimates, while unknown-width roads are rejected by default. We clearly disclose that physical carriageway compliance requires field verification."
  - "We also model electric fleet operational realities: 144 kWh usable battery energy, air conditioning thermal loads, and depot charging windows. The 21 allocated buses require only $4.2\%$ of the 500-bus ceiling while maintaining 8–12 minute headways."

---

### Section 5: Segment-Level Bus & Metro Crowding (Problem 5) (1.5 Minutes)

- **Action:** Navigate to **Problem 5: Segment Loads & Bottlenecks** on the analytics console.
- **What Appears on Screen:**
  - Stop-by-stop passenger accumulation curve along Route 502 (38 stops, Kashmere Gate to Mehrauli).
  - Exact flow conservation equation:
    $$L_i = L_{i-1} + B_i - A_i \quad \text{with } L_0 = 0 \text{ and } L_n = 0$$

  - Terminal residual: exactly $0.0\text{ passengers}$ remaining at Mehrauli (mathematical boundary condition).
  - Propagating uncertainty interval envelope: $\pm 5\%$ at origin, expanding to $\pm 22\%$ across intermediate stops, collapsing to $0\%$ at terminus.
  - Bottleneck indicator: Highlights Red Fort and Delhi Gate segments ($LF \ge 0.90$) and displays an automated relief bus dispatch advisory.
- **Key Speaking Points:**
  - "This solves the classic transit paradox: tickets record boardings, but passengers never tap out on buses. Our algorithm models missing alightings via destination attraction decay while preserving exact physical conservation. The terminal load balances to zero as an enforced mathematical boundary condition of the conservation model ($\sum B = \sum A$), which we explicitly disclose rather than claiming empirical validation."
  - "Notice the shaded uncertainty band: we honestly show that intermediate segment loads carry a $\pm 15\text{--}22\%$ error margin due to inferred alightings, giving operators a realistic basis for dispatching relief buses."

---

### Section 6: Live Telemetry & Mobile Integration (Problem 1 & Live Feed) (1.5 Minutes)

- **Action:** In the Operator Portal, click **Live Telemetry** or run `scripts/probe_gtfs_rt.py`.
- **What Appears on Screen:**
  - Live feed status: HTTP 200 OK from Delhi Transport Stack.
  - 3,746 active buses parsed from binary Protocol Buffer v2.0 (409,536 bytes payload; local decode in 2.27 ms; WAN round-trip latency: 1.4s–4.7s).
  - Real-time map displaying moving vehicle markers across Delhi (3,716 fresh $\le 300\text{s}$, 30 stale $> 300\text{s}$).
  - Mobile applications (Passenger App and Driver App):
    - Passenger App: Step-free journey planning, real-time bus arrival countdown, and Accessibility Boarding Assistance toggle.
    - Driver App: High-contrast cab interface displaying passenger boarding requests with wheelchair ramp deployment alerts.
- **Key Speaking Points:**
  - "This is live, authentic Delhi transit data. We connect directly to the official Delhi Transport Stack endpoint, decoding 3,746 live vehicles with 2.27 ms local Protobuf decoding time and 11.29 ms filtering time, clearly separated from public WAN round-trip latency."
  - "Our mobile apps close the loop between passenger and driver: when a passenger requests ramp assistance, the driver receives a clear, high-contrast alert in their cab interface before pulling into the stop."

---

## Anticipated Jury Questions & Technical Responses

### Q1: "How do you justify your travel time accuracy when historical GPS data is missing?"

**Response:**  
"We are completely transparent about this. Our MAE of 6.71 minutes is a **timetable deviation validation** against 30 complete scheduled trips from official DTC GTFS Static data (`data/gtfs/stop_times.txt`). In off-peak hours, our error is only 2.50 minutes (7.6%). In peak hours, static timetables schedule identical runtimes despite heavy congestion, whereas our model applies an empirical $1.45\times$ congestion multiplier. We label this multiplier as an empirical assumption rather than claiming it as calibrated GPS truth."

### Q2: "Can you trust the OD matrix when household travel surveys are unavailable?"

**Response:**  
"The matrix is estimated using the Furness biproportional scaling method, which is the international standard for synthetic matrix generation when full travel surveys are absent. We calibrated generation and attraction totals against DTC daily depot volumes (4.28M daily boardings) and DMRC metro ridership statistics. The model guarantees exact marginal preservation (0 discrepancy in 4 iterations) and exposes sensitivity testing across $\gamma \in [0.04, 0.12]$ so planners can inspect variation. Furness IPF balances generation and attraction marginals; its convergence does not independently establish the true passenger origin-destination distribution."

### Q3: "What prevents feeder buses from getting stuck in narrow Delhi streets?"

**Response:**  
"Our feeder optimizer enforces a minimum carriageway planning width of $6.0\text{ m}$ based on Indian Roads Congress IRC:73 standards and MPD-2021 planning estimates. Furthermore, our engine implements a strict 'fail-safe' policy: any road segment whose carriageway width is unverified in municipal records is marked unknown and rejected by the routing algorithm. Physical compliance requires field verification."

### Q4: "Why use Relative Crowding Index instead of actual passenger counts?"

**Response:**  
"Conductor ETMs capture an unverified fraction of riders; the 28.5x expansion factor is an uncalibrated planning hypothesis. Any system claiming exact passenger counts without axle load sensors or onboard cameras is fabricating certainty. Our Relative Crowding Index ranks routes into relative comfort tiers and reflects headway bunching penalties without claiming exact onboard passenger counts."
