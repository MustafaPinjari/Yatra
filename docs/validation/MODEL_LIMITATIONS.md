# YATRA — Model Limitations & Uncertainty Disclosures

This document details the known technical, algorithmic, and data limitations of the five problem engines implemented in YATRA. In accordance with engineering integrity principles, these limitations are explicitly documented rather than concealed.

All inputs and outputs are governed by the five standard provenance classifications: `OBSERVED`, `ESTIMATED`, `SYNTHETIC`, `SCENARIO_MODEL`, and `UNVERIFIED`.

---

## 1. Problem 1 — Bus Traffic Model & Journey Planner

### Limitations & Assumptions
1. **Uncalibrated Congestion Multipliers (`SCENARIO_MODEL`):**
   The traffic model applies empirical multipliers ($1.45\times$ during AM peak 08:00–11:00, $1.55\times$ during PM peak 17:00–20:30, $1.18\times$ during midday shoulder, and $1.00\times$ off-peak). While these reflect standard urban traffic inflation in Delhi, they are uncalibrated against raw GPS breadcrumbs because high-frequency historical GPS logs are not bundled in the repository.
2. **Timetable Flatness in Static GTFS:**
   Official GTFS static timetables frequently assign identical runtimes across peak and off-peak trips (e.g. 53.4 minutes for Route 102A at both 06:05 and 08:35). Comparing our traffic model against static timetables yields an MAE of 6.71 minutes overall, but increases to 13.03 minutes during peak hours because the model inflates travel time for congestion while the static schedule does not.
   - **Labeling requirement:** This evaluation is strictly termed **timetable deviation validation**, not observed road speed prediction accuracy.
3. **Discrete Dwell Time Modeling (`ESTIMATED` / `SCENARIO_MODEL`):**
   Dwell time is modeled as $25\text{s}$ baseline plus $35\text{s}$ when hydraulic wheelchair ramp deployment is requested. In reality, dwell time varies with boarding queue size, conductor ticket issuance speed, and physical platform clearance.
4. **Exogenous Factors Not Modeled:**
   The model does not dynamically account for rain-induced road waterlogging, construction diversions, or VIP route closures unless reflected in live GTFS-RT service alerts.

---

## 2. Problem 2 — Crowdedness-Aware Journey Planner

### Limitations & Assumptions
1. **ETM Data Capture Volatility (`UNVERIFIED`):**
   Electronic Ticketing Machines (ETM) carried by bus conductors do not capture 100% of riders. In Delhi:
   - Women passengers travel free under the Pink Pass scheme, which conductors issue as zero-fare tickets at variable rates.
   - Monthly and daily DTC pass holders board without individual transaction records.
   - Cash fare transactions in heavy crush loads are often delayed or batched.
2. **Universal Expansion Factor Inadequacy (`UNVERIFIED`):**
   The $28.5\times$ expansion factor (assuming $3.5\%$ capture) is an uncalibrated hypothesis. Route-level capture rates vary between $2\%$ and $15\%$. Applying a uniform multiplier across trunk routes (e.g. Ring Road TMS) and feeder routes introduces substantial estimation error.
   - **Mitigation:** The system does NOT claim absolute passenger counts; it surfaces a **Relative Crowding Index (RCI)** bounded in $[0.05, 0.98]$ reflecting relative comfort ranking.
3. **Absence of Real-Time Load Cell Sensors:**
   Without pneumatic axle load sensors or onboard automated passenger counters (APC), RCI estimates remain probabilistic indicators with a $\pm 18.5\%$ confidence interval.
4. **Bunching Approximation:**
   Headway deviation penalties assume passenger queue growth scales with excess headway ratio ($H_{\text{obs}} / H_{\text{sched}}$). In severe bunching events, the second bus may run almost empty while the lead bus is crushed.

---

## 3. Problem 3 — Transit Origin–Destination (OD) Matrix

### Limitations & Assumptions
1. **Spatial Aggregation Granularity (7 Zones):**
   The matrix models 7 broad Transit Analysis Zones (North, Central, South, East, West, Rohini, Mehrauli). While computationally stable for Furness IPF convergence (converging in 4 iterations with $< 0.001\%$ marginal error), it does not capture neighborhood-level trip ends (e.g. intra-colony travel within Rohini Sector 11 vs Sector 22).
2. **Centroid-Based Distance Impedance (`ESTIMATED`):**
   The gravity model friction term uses Haversine inter-zonal centroid distances ($f(d) = e^{-\gamma \cdot d}$). This underestimates travel resistance across circuitous river crossings (Yamuna bridges connecting East Delhi to Central Delhi).
3. **Marginal Total Derivations (`ESTIMATED`):**
   Trip productions and attractions are derived from DTC bus depot fleet capacities and DMRC station footfalls, rather than a comprehensive municipal household travel survey (HTS).
4. **Mode Split Granularity (`ESTIMATED`):**
   The aggregate mode split of 46% DMRC Metro rail vs 54% DTC surface bus represents citywide public transport share during peak periods. DMRC counts are grounded in observed station gate totals, while bus passenger totals are estimated from daily operational dispatch volumes.
5. **Distance Decay Sensitivity:**
   The base model uses $\gamma = 0.08\text{ /km}$. Sensitivity analysis across $\gamma \in [0.04, 0.12]$ shows inter-zonal trips vary from $82.1\%$ down to $66.5\%$, highlighting the impact of passenger willingness to travel long distances.

---

## 4. Problem 4 — Metro Feeder Route & Fleet Optimization

### Limitations & Assumptions
1. **Geometric vs Operational Feasibility (`SCENARIO_MODEL`):**
   Feeder routes satisfy road carriageway width constraints ($\ge 6.0\text{ m}$), route length caps ($\le 7.0\text{ km}$), and total fleet budget constraints ($\le 500\text{ EV buses}$). However, operational feasibility is dependent on electric vehicle scenario assumptions:
   - Battery pack nominal capacity: $180\text{ kWh}$ with 80% usable depth-of-discharge ($144\text{ kWh}$).
   - Specific energy consumption: $1.15\text{ kWh/km}$ under Delhi summer ambient temperatures and AC loads.
   - Depot DC fast-charging: $60\text{ kW}$ rating requiring a 45-minute midday opportunity boost ($45\text{ kWh}$ replenishment).
2. **Road Width Data Provenance & Rejection (`ESTIMATED` / `SCENARIO_MODEL`):**
   Carriageway widths are modeled using Delhi Master Plan 2021 Right-of-Way (RoW) minimum designated standards for arterial and sub-arterial corridors. Roads with unconfirmed or missing width records are strictly marked unknown and rejected (`is_bus_eligible: false`).
3. **Turnaround and Layover Buffers:**
   A fixed $6.0\text{ min}$ terminal layover buffer is used. In congested metro terminal loops (such as Kashmere Gate ISBT or Anand Vihar), terminal congestion may exceed this layover, disrupting scheduled 8–12 minute headways.

---

## 5. Problem 5 — Bus & Metro Segment-Level Crowding

### Limitations & Assumptions
1. **Inferred Alighting Uncertainty (`ESTIMATED`):**
   Passenger flow conservation ($L_i = L_{i-1} + B_i - A_i$) is mathematically satisfied with a zero terminal residual ($L_n = 0$). However, because ETM tickets record only boarding points, intermediate alightings are inferred using destination attraction decay. Mathematical conservation must not be confused with empirical ground truth.
2. **Intermediate Segment Error Bounds:**
   While the boundary conditions ($L_0 = 0$ and $L_n = 0$) are exact, intermediate segment occupancy exhibits an uncertainty interval propagating from $\pm 5\%$ at origin, expanding to $\pm 22\%$ across intermediate stops, and collapsing to $0\%$ at the terminus.
3. **Crush Load Capacity Variation (`SCENARIO_MODEL`):**
   Bus capacity is modeled as nominal 60 passengers (35 seated + 25 standees) and crush 85 passengers. In reality, crush load varies depending on passenger baggage, mobility devices, and interior floor layouts.
4. **Metro Passenger Flow Simplification:**
   Metro corridor load calculations use published station boarding and alighting distributions. AFC gate entry/exit smart card tap logs were not directly provided in the hackathon repository.
