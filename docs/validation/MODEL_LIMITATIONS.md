# YATRA — Model Limitations & Uncertainty Disclosures

This document details the known technical, algorithmic, and data limitations of the five problem engines implemented in YATRA. In accordance with engineering integrity principles, these limitations are explicitly documented rather than concealed.

---

## 1. Problem 1 — Bus Traffic Model & Journey Planner

### Limitations
1. **Uncalibrated Congestion Multipliers:**
   The traffic model applies empirical multipliers ($1.45\times$ during AM peak 08:00–11:00, $1.55\times$ during PM peak 17:00–20:30, $1.18\times$ during midday shoulder, and $1.00\times$ off-peak). While these reflect standard urban traffic inflation in Delhi, they are uncalibrated against raw GPS breadcrumbs because historical GPS logs are not bundled in the repository.
2. **Timetable Flatness in Static GTFS:**
   Official GTFS static timetables frequently assign identical runtimes across peak and off-peak trips (e.g. 53.4 minutes for Route 102A at both 06:05 and 08:35). Comparing our traffic model against static timetables yields an MAE of 6.71 minutes overall, but increases to 13.03 minutes during peak hours because the model inflates travel time for congestion while the static schedule does not.
3. **Discrete Dwell Time Modeling:**
   Dwell time is modeled as $25\text{s}$ baseline plus $35\text{s}$ when hydraulic wheelchair ramp deployment is requested. In reality, dwell time varies with boarding queue size, conductor ticket issuance speed, and physical platform clearance.
4. **Exogenous Factors Not Modeled:**
   The model does not dynamically account for rain-induced road waterlogging, construction diversions, or VIP route closures unless reflected in live GTFS-RT alerts.

---

## 2. Problem 2 — Crowdedness-Aware Journey Planner

### Limitations
1. **ETM Data Capture Volatility:**
   Electronic Ticketing Machines (ETM) carried by bus conductors do not capture 100% of riders. In Delhi:
   - Women passengers travel free under the Pink Pass scheme, which conductors issue as zero-fare tickets at variable rates.
   - Monthly and daily DTC pass holders board without individual transaction records.
   - Cash fare transactions in heavy crush loads are often delayed or batched.
2. **Universal Expansion Factor Inadequacy:**
   The $28.5\times$ expansion factor (assuming $3.5\%$ capture) is an uncalibrated hypothesis. Route-level capture rates vary between $2\%$ and $15\%$. Applying a uniform multiplier across trunk routes (e.g. Ring Road TMS) and feeder routes introduces substantial estimation error.
3. **Absence of Real-Time Load Cell Sensors:**
   Without pneumatic axle load sensors or onboard automated passenger counters (APC), Relative Crowding Index (RCI) estimates remain probabilistic indicators with a $\pm 18.5\%$ confidence interval.
4. **Bunching Approximation:**
   Headway deviation penalties assume passenger queue growth scales with excess headway ratio ($H_{\text{obs}} / H_{\text{sched}}$). In severe bunching events, the second bus may run almost empty while the lead bus is crushed.

---

## 3. Problem 3 — Transit Origin–Destination (OD) Matrix

### Limitations
1. **Spatial Aggregation Granularity (7 Zones):**
   The matrix models 7 broad Transit Analysis Zones (North, Central, South, East, West, Rohini, Mehrauli). While computationally stable for Furness IPF convergence (converging in 4 iterations with $< 0.001\%$ marginal error), it does not capture neighborhood-level trip ends (e.g. intra-colony travel within Rohini Sector 11 vs Sector 22).
2. **Centroid-Based Distance Impedance:**
   The gravity model friction term uses Haversine inter-zonal centroid distances ($f(d) = e^{-\gamma \cdot d}$). This underestimates travel resistance across circuitous river crossings (Yamuna bridges connecting East Delhi to Central Delhi).
3. **Marginal Total Derivations:**
   Trip productions and attractions are derived from DTC bus depot fleet capacities and DMRC station footfalls, rather than a comprehensive municipal household travel survey (HTS).
4. **Single-Mode Focus:**
   The OD matrix estimates public transit passenger trips only; it does not model mode shift to private two-wheelers, auto-rickshaws, or cab aggregators.

---

## 4. Problem 4 — Metro Feeder Route & Fleet Optimization

### Limitations
1. **Geometric vs Operational Feasibility:**
   Feeder routes satisfy road carriageway width constraints ($\ge 6.0\text{ m}$), route length caps ($\le 7.0\text{ km}$), and total fleet budget constraints ($\le 500\text{ EV buses}$). However, operational feasibility is not fully established because electric vehicle specifications are missing:
   - Battery pack capacity (kWh) and usable depth-of-discharge (DoD).
   - Depot DC fast-charging schedules, plug availability, and demand-charge tariffs.
   - Summer air-conditioning auxiliary electrical load (up to $30\%$ range reduction in Delhi heat).
2. **Road Width Data Provenance:**
   Carriageway widths are modeled using Delhi Master Plan 2021 Right-of-Way (RoW) minimum designated standards for arterial and sub-arterial corridors. Micro-level road register surveys, street parking encroachments, and overhead clearance data are not available.
3. **Turnaround and Layover Buffers:**
   A fixed $6.0\text{ min}$ terminal layover buffer is used. In congested metro terminal loops (such as Kashmere Gate ISBT or Anand Vihar), terminal congestion may exceed this layover, disrupting scheduled 8–12 minute headways.

---

## 5. Problem 5 — Bus & Metro Segment-Level Crowding

### Limitations
1. **Inferred Alighting Uncertainty:**
   Passenger flow conservation ($L_i = L_{i-1} + B_i - A_i$) is mathematically satisfied with a zero terminal residual ($L_n = 0$). However, because ETM tickets record only boarding points, intermediate alightings are inferred using destination attraction decay. Mathematical conservation must not be confused with empirical ground truth.
2. **Intermediate Segment Error Bounds:**
   While the boundary conditions ($L_0 = 0$ and $L_n = 0$) are exact, intermediate segment occupancy can deviate by $\pm 15\text{--}20\%$ from actual onboard passengers.
3. **Crush Load Capacity Variation:**
   Bus capacity is modeled as nominal 60 passengers (35 seated + 25 standees) and crush 85 passengers. In reality, crush load varies depending on passenger baggage, mobility devices, and interior floor layouts.
4. **Metro Passenger Flow Simplification:**
   Metro corridor load calculations use published station boarding and alighting distributions. AFC gate entry/exit smart card tap logs were not directly provided in the hackathon repository.
