# YATRA — Anticipated Jury Questions & Authoritative Technical Responses

This document prepares the presentation team for rigorous technical, mathematical, and operational questioning from transport planners, software architects, and municipal evaluators during the Delhi Transport Stack Hackathon.

---

## 1. Model Accuracy and Timetable Deviation (Problem 1)

### Q1.1: "How can you claim a Mean Absolute Error of 6.71 minutes when raw GPS trajectory data is not bundled in your repository?"

**Authoritative Response:**

"We do not claim that 6.71 minutes represents accuracy against unbundled real-time GPS road trajectories. We explicitly document this metric as a **timetable deviation validation** evaluated against 30 complete scheduled bus trips from the official DTC GTFS Static schedule (`data/gtfs/stop_times.txt`).

- During off-peak periods (06:00–07:45, 12:00–16:00), our model tracks the scheduled runtimes closely with a Mean Absolute Error of only **2.50 minutes** (7.6% error).
- During peak periods (08:00–11:00, 17:00–20:30), the official GTFS Static timetable schedules identical flat runtimes across morning and mid-day trips (e.g., 53.4 minutes for Route 102A at both 06:05 and 08:35). Our traffic engine inflates travel time using an empirical **1.45x AM peak multiplier**, predicting 64.8 minutes. This increases peak timetable deviation to **13.03 minutes** (21.3% error).
- Rather than concealing this discrepancy, we classify the 1.45x and 1.55x multipliers as `SCENARIO_MODEL` assumptions derived from Delhi Master Plan arterial corridor studies, pending complete map matching against historical GPS breadcrumbs."

### Q1.2: "How does your routing engine handle accessible journeys for wheelchair users?"

**Authoritative Response:**

"Standard transit routers evaluate only walking time and in-vehicle run time. YATRA’s RAPTOR engine integrates a physical accessibility model:

1. Stops are filtered by physical audit data (curb height, flush boarding, ramp clearance).
2. Boarding dwell time incorporates an empirical **+35-second penalty** representing hydraulic low-floor kneeling and wheelchair ramp extension.
3. This prevents unrealistic 60-second transfer windows that inevitably fail passengers with reduced mobility."

---

## 2. ETM Sampling and Crowding Heuristics (Problem 2)

### Q2.1: "Why do you use a Relative Crowding Index instead of reporting exact passenger headcounts?"

**Authoritative Response:**

"Any system claiming exact passenger headcounts from Delhi bus ticketing data without automated passenger counting (APC) sensors or axle load cells is fabricating certainty.

- Conductor Electronic Ticketing Machines (ETMs) capture only an unverified fraction of passengers:
  1. Women passengers travel free under the government Pink Pass scheme, issued by conductors at variable rates.
  2. Daily and monthly pass holders board without individual transaction records.
  3. Peak crush loads make it physically difficult for conductors to navigate aisles and ticket every passenger before they alight.
- Applying a universal 28.5x expansion factor represents an uncalibrated planning hypothesis (`UNVERIFIED_PLANNING_HYPOTHESIS`), not an empirical census result. Therefore, YATRA surfaces an `ESTIMATED` **Relative Crowding Index (RCI)** bounded in $[0.05, 0.98]$ that ranks routes into relative comfort tiers (Low, Moderate, Heavy, Crush) as a relative operational heuristic.
- YATRA provides this required disclosure in both UI and documentation: *'YATRA estimates relative crowding using available operational signals, including vehicle headway deviations. It does not claim exact onboard passenger counts. ETM sampling assumptions have not yet been independently calibrated.'*"

### Q2.2: "How does live vehicle bunching affect your crowding estimation?"

**Authoritative Response:**

"When a bus falls behind schedule, downstream stop queues grow proportionally to excess waiting time. Our engine extracts live headway gaps ($H_{\text{obs}}$) directly from the GTFS-RT feed:

$$P_h = \max\left(0, \frac{H_{\text{obs}} - H_{\text{sched}}}{H_{\text{sched}}}\right)$$

The crowding engine applies a bunching penalty factor ($\beta = 0.40$), inflating the expected RCI for delayed lead buses while reflecting lower crowding on trailing relief buses."

---

## 3. Origin–Destination Matrix & Sensitivity Analysis (Problem 3)

### Q3.1: "How defensible is your 7-zone OD matrix without a comprehensive Household Travel Survey (HTS)?"

**Authoritative Response:**

"When comprehensive household interview surveys are absent, the international transport planning standard is the **Furness biproportional Iterative Proportional Fitting (IPF)** method:

$$T_{ij}^{(k+1)} = T_{ij}^{(k)} \cdot \frac{G_i}{\sum_j T_{ij}^{(k)}} \cdot \frac{A_j}{\sum_i T_{ij}^{(k)}}$$

- Our matrix aggregates Delhi into 7 broad Transit Analysis Zones (TAZ) matching Delhi Master Plan (MPD-2021) Zonal Development Plans.
- The modeled volume of **546,143 trips** specifically represents the **3-hour morning peak period (08:00–11:00)** across the 7 TAZ zones.
- Trip generation ($G_i$) and attraction ($A_j$) marginals are derived from aggregate DTC depot dispatch statistics and DMRC station entry/exit gate counts.
- The algorithm converges in 4 iterations with 0 trip marginal discrepancy (546,143 trips generated = 546,143 trips attracted).
- We explicitly disclose in the system: *'Furness IPF balances estimated trip generation and attraction marginals. Its convergence does not independently establish the true passenger origin-destination distribution.'*"

### Q3.2: "What is the provenance of your 46% Metro / 54% Bus mode split?"

**Authoritative Response:**

"This mode split is an aggregate scenario allocation based on published aggregate DMRC and DTC operational reports:

- The 46% Metro share ($251,226\text{ trips}$) and 54% Bus share ($294,917\text{ trips}$) represent modeled mode-share scenario allocations across the 3-hour morning peak period, rather than independently synchronized passenger censuses.
- Planners can interactively adjust the exponential distance decay friction parameter ($\gamma \in [0.04, 0.12]$) to observe how inter-zonal travel share shifts between 82.1% (low friction) and 66.5% (high localized friction)."

---

## 4. Feeder Bus Route & Road Width Compliance (Problem 4)

### Q4.1: "How do you guarantee that feeder buses will not enter narrow streets where they cannot turn?"

**Authoritative Response:**

"Our feeder optimization engine enforces a strict physical geometry constraint:

- Indian Roads Congress guidelines (IRC:73 / IRC:86) require a minimum **6.0-meter clear carriageway** for two-way operation of 9-meter standard midi-buses.
- Road widths in our data model are based on Master Plan for Delhi 2021 designated Right-of-Way planning standards (`planning_width_row_m`), not field-measured curb-to-curb carriageway widths (`field_measured_width_m: None`, `is_field_verified: False`).
- Crucially, the engine implements a **fail-safe default**: any road segment whose carriageway width is unrecorded or unverified in planning records is marked unknown and **strictly rejected** (`is_bus_eligible: false`).
- We provide this explicit disclosure: *'Candidate paths satisfy the model's 6-metre planning-width constraint using available planning estimates. Unknown-width roads are rejected. Physical carriageway compliance requires field verification.'*
- 100% of generated feeder routes connect directly to DMRC interchange hubs and remain under the **7.0 km route length cap** (average length: 5.7 km)."

### Q4.2: "How does your fleet allocation respect the 500-bus budget constraint?"

**Authoritative Response:**

"Across the seven designated Delhi Metro hubs (Kashmere Gate, Hauz Khas, Rajiv Chowk, Anand Vihar, Janakpuri West, Botanical Garden, Netaji Subhash Place), the optimization engine allocates **21 electric buses** under the baseline 10-minute headway policy. This utilizes only **4.2%** of the 500-bus municipal budget cap.

- Sensitivity analysis across headways from 6 to 15 minutes confirms that even under high-frequency 6-minute service, the network requires only **52 buses**, comfortably within the 500-bus ceiling."

---

## 5. Electric Bus Energy & Depot Charging Feasibility (Problem 4)

### Q5.1: "What electric vehicle specifications and operational constraints did you model?"

**Authoritative Response:**

"Rather than assuming infinite vehicle range, we incorporated an explicit operational scenario model based on the Delhi Electric Vehicle Policy 2020:

- **Nominal Battery Capacity:** $180\text{ kWh}$ with an 80% usable depth-of-discharge (DoD), yielding **$144\text{ kWh}$ usable energy**.
- **Specific Energy Consumption:** **$1.15\text{ kWh/km}$**, incorporating Delhi summer ambient temperatures and high passenger air-conditioning thermal loads.
- **Cycle Range:** A standard 5.7 km feeder loop consumes $6.56\text{ kWh}$ ($5.7 \times 1.15 = 6.555\text{ kWh}$). A vehicle can execute **21 complete loops** before reaching the usable-energy limit ($144 / 6.555 = 21.96$), covering $119.7\text{ km}$ of revenue service.
- **Maximum Theoretical Operating Distance:** Single-charge theoretical range on usable energy is **$125.22\text{ km}$** ($144 / 1.15$).
- **Depot Opportunity Charging:** With a scheduled **60 kW DC depot fast charger**, a 45-minute midday driver meal break delivers **$45\text{ kWh}$** in ideal theoretical charging (or **$41.40\text{ kWh}$** net at 92% charger efficiency), providing an additional **$39.13\text{ km}$** ($36.00\text{ km}$ net) or **6 complete loops**, eliminating midday battery exhaustion."

---

## 6. Passenger Flow Conservation & Segment Loads (Problem 5)

### Q6.1: "How do you calculate segment loads when passengers do not tap out on Delhi buses?"

**Authoritative Response:**

"Delhi buses operate single-door cash or ETM entry where alightings are unrecorded. YATRA solves this using directional passenger flow conservation:

$$L_i = L_{i-1} + B_i - A_i \quad \text{with } L_0 = 0 \text{ and } L_n = 0$$

- Boardings ($B_i$) at each stop are initialized from route stage distributions.
- Intermediate alightings ($A_i$) are estimated using downstream destination attraction decay.
- The terminal zero residual ($L_n = 0$) is an enforced mathematical model boundary condition and conservation result ($\sum B = \sum A$), not empirical validation of onboard passenger occupancy.
- Because intermediate alightings are inferred rather than observed, we surface an explicit **uncertainty interval** that expands from $\pm 5\%$ at origin to $\pm 22\%$ across central segments, collapsing back to $0\%$ at the terminus."

---

## 7. Live GTFS-Realtime Telemetry & Failure Resilience

### Q7.1: "Why was there a discrepancy between 1,394 ms and under 50 ms in earlier performance reports?"

**Authoritative Response:**

"That was a reporting distinction between network transport latency and local CPU computation time, which we have now explicitly decoupled:

1. **HTTP Round-Trip Network Latency:** Fetching the 409,536 bytes (400 KB) binary payload over the public WAN from `dts-backend.transportstack.in` takes **$1,394\text{ ms} \text{ to } 4,653\text{ ms}$** depending on remote server load and network jitter.
2. **Local Protobuf Decoding Time:** Once the binary stream arrives in memory, Python compiled Protocol Buffer v2.0 decoding (`FeedMessage.ParseFromString`) executes in **$2.27\text{ ms}$**.
3. **Validation & Filtering Time:** Validating 3,746 vehicles against the Delhi NCR bounding box, calculating freshness, and updating memory maps takes **$11.29\text{ ms}$**.
- The total local compute time is **under 15 ms**, while the remainder is remote network latency."

### Q7.2: "How does the platform behave if the DTS live feed times out, returns HTTP 401, or sends corrupted data?"

**Authoritative Response:**

"The platform has been hardened and verified against five explicit failure modes via automated unit tests (`test_gtfs_rt_failure_modes.py`):

1. **Network Timeout:** The HTTP client enforces a 15-second timeout with exponential backoff (1s, 2s). If all retries fail, it records `API_ERROR` and serves schedule baseline positions.
2. **HTTP 401 Unauthorized:** Captures the error, masks the API key, and sets status to `API_ERROR` with HTTP 401 code.
3. **Malformed Protobuf:** If binary decoding fails, it attempts JSON parsing; if both fail, it logs a clean error and rejects the payload without crashing.
4. **Empty Payload:** An empty 0-byte stream is rejected with 0 updates processed.
5. **Stale Feed (> 300s):** If vehicle timestamps exceed 300 seconds, they are explicitly tagged `is_stale: true`, and the feed status switches to `STALE_DATA`. Old positions are never presented as live."

---

## 8. System Cost & Jugaad Architecture Discipline

### Q8.1: "What is your real infrastructure cost, and why shouldn't municipal transit run on commercial cloud APIs?"

**Authoritative Response:**

"A standard enterprise transit intelligence deployment using commercial SaaS APIs incurs substantial recurring costs:

- Commercial Routing APIs (Google Maps Distance Matrix / Mapbox Directions): $2,500 – $5,000 / month
- Commercial Map Vector Tiles: $450 – $1,200 / month
- Optimization Solvers (Gurobi / CPLEX licenses): $1,500 – $3,000 / month
- Transport Planning Suites (PTV Visum): $3,000 – $6,000 / month
- Managed Cloud Warehouses (BigQuery / Snowflake): $800 – $2,000 / month
- **Total Commercial Spend:** **$9,250 – $19,700 per month**

YATRA replaces every paid dependency with open-source, local-first equivalents:

- In-memory Python RAPTOR router ($0)
- Self-hosted OpenStreetMap and MapLibre GL ($0)
- Google OR-Tools CP-SAT and Routing library ($0)
- NumPy vectorized Furness IPF ($0)
- Embedded DuckDB and Polars columnar Parquet processing ($0)
- Direct compiled Protocol Buffer binary ingestion ($0)
- **Total Software License Cost:** **$0.00**
- Real infrastructure requirement: standard on-premise quad-core commodity server with 8 GB RAM and 20 GB disk."
