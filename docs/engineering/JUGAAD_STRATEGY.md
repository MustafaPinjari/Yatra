# YATRA — Jugaad Engineering Strategy: Free and Low-Cost Architecture

## Executive Overview

Jugaad engineering is disciplined, high-leverage resourcefulness. In public transit intelligence, it means achieving production-grade accuracy, mathematical correctness, and real-time responsiveness without depending on expensive cloud subscriptions, proprietary geospatial APIs, or unnecessary infrastructure layers.

Every architectural decision in YATRA evaluates free, open-source, and local-first solutions before considering any paid alternative.

---

## 1. Core Principles of Transit Jugaad Engineering

1. **Deterministic Algorithms over Expensive Machine Learning:** Transit routing, headway analysis, and conservation flow calculations are deterministic physical problems. Exact mathematical implementations (e.g., RAPTOR, Furness IPF, Flow Conservation) execute in milliseconds locally, eliminating the compute and billing costs of black-box neural networks.
2. **Local Analytical Engines over Cloud Warehouses:** Rather than provisioning managed cloud data warehouses (Snowflake, BigQuery, AWS Redshift) costing hundreds of dollars per month, analytical queries run directly against flat Parquet files using embedded columnar engines (DuckDB, Polars).
3. **Open Spatial Standards over Proprietary Map Platforms:** Avoid commercial per-transaction map APIs (Google Maps Distance Matrix, Mapbox Directions) that incur runaway costs during route evaluation. Use open geospatial tools (OpenStreetMap, Shapely, MapLibre GL, NetworkX) running entirely on developer hardware.
4. **Never Sacrifice Rigor for Cost:** Cost reduction must never compromise passenger accessibility, data provenance, or mathematical correctness.

---

## 2. Domain-Specific Jugaad Implementations

### A. Data Processing Strategy
- **Embedded Columnar Queries with DuckDB:** Query large CSV and Parquet archives directly using SQL without loading whole tables into RAM. DuckDB executes out-of-core queries with memory usage capped at machine capacity.
- **Vectorized Streaming with Polars:** Use Polars for multi-threaded, zero-copy tabular processing. Polars streams chunks, avoiding Python object allocation overhead.
- **Day-by-Day GPS Chunking:** To ingest large historical GPS archives (e.g., 124 GB uncompressed traces), process data partitioned by calendar date (`date=YYYY-MM-DD`). Aggregate segment speeds incrementally and write compressed Parquet checkpoints, ensuring processing can resume after any interruption without restarting from zero.
- **Storage Compaction:** Raw GTFS Static files (169 MB) and telemetry tables are stored in snappy-compressed columnar Parquet files, achieving a $4\times\text{--}6\times$ compression ratio.
- **Embedded Storage with SQLite:** Avoid PostgreSQL/PostGIS hosting overhead for single-node deployments by utilizing SQLite with R*Tree spatial extensions.

### B. Geospatial Strategy
- **OpenStreetMap Data Foundation:** Utilize raw OSM road vectors under the Open Database License (ODbL) for road geometries, speeds, and junction topologies.
- **Local Spatial Processing Stack:** Perform network routing, spatial point-in-polygon tests, and distance buffers using open-source Python packages:
  - `Shapely` for GEOS-backed planar geometries.
  - `NetworkX` / `scipy.spatial` for graph algorithms and KD-Tree nearest-neighbor queries.
  - `pyproj` for EPSG:4326 (WGS84) to EPSG:32643 (UTM Zone 43N) coordinate transformations.
- **Self-Hosted Map Tiles with MapLibre GL:** Render maps on the web frontend using MapLibre GL JS paired with vector or raster tiles derived from OpenStreetMap, eliminating third-party tile-view rate limits and subscription tiers.
- **Honest Attribute Reporting:** When road carriageway widths or curb ramp heights are absent from source data, explicitly record them as unknown or regulatory defaults; never fabricate synthetic widths to pass an algorithm.

### C. Optimization and Transport Modeling Strategy
- **Linear & Constraint Programming with Google OR-Tools:** Utilize the open-source Google OR-Tools CP-SAT and Routing library for vehicle scheduling and feeder fleet allocation. Solves complex NP-hard vehicle routing problems with zero commercial solver license fees (avoiding Gurobi or CPLEX).
- **RAPTOR Round-Based Transit Routing:** The custom Python RAPTOR router operates directly on ordered GTFS stop sequences and departure timetables, finding Pareto-optimal transfer journeys in under 20 milliseconds without external routing servers (e.g., OpenTripPlanner or GraphHopper instances).
- **Statistical Baselines over Complex Deep Learning:** Statistical distribution baselines ($p_{25}, p_{75}, p_{95}$ quantiles) provide clear reliability buffers for bus journey times. They are transparent, auditable by municipal authorities, and run instantaneously on standard hardware.

### D. Infrastructure and Operational Strategy
- **Local-First Development:** The entire YATRA platform runs locally on standard laptops or single workstation instances without external cloud dependencies.
- **Unified Single-Process Architecture:** The FastAPI backend serves transit routing, GTFS ingestion, and analytical models from a single Python process, avoiding microservice network latency and orchestration overhead.
- **Docker Compose for Deployment:** When containerization is needed, a lightweight `docker-compose.yml` launches the backend and web services locally, avoiding Kubernetes clusters and managed cloud container services.
- **Graceful Fallbacks:** External network interfaces (such as live GTFS-RT Protobuf feeds) feature automatic fallback to schedule timetables if the remote server is unreachable, maintaining full functionality offline.

### E. AI and Generative API Cost Control
- **Zero Raw Data Forwarding to LLMs:** Transit schedules, GPS breadcrumbs, and passenger ticket records are never forwarded to generative AI models. Forwarding large mobility datasets to commercial LLMs generates massive token bills without mathematical verification.
- **Deterministic Python Operations:** All routing calculations, headway bunching factors, passenger flow conservation equations, and matrix balancing iterations are computed deterministically in Python.
- **Generative AI Scoped to Natural Language Interfaces:** LLMs are reserved exclusively for conversational passenger assistance, natural language itinerary summaries, and multilingual translations.
- **Token and Rate Capping:** API calls use bounded prompt contexts and strict token limits, with credentials maintained exclusively in local `.env` files.

---

## 3. Problem-by-Problem Jugaad Engineering Decisions

### Problem 1: Real-Time Bus Traffic Model & Journey Planner
1. **Lowest-Cost Implementation:** RAPTOR transit router combined with empirical time-of-day traffic distributions calculated from GTFS stop sequences.
2. **Free / Open-Source Tools:** Python standard library, Polars, DuckDB, Shapely, Haversine spatial formulas.
3. **Paid Services Avoided:** Google Maps Distance Matrix API ($5.00 to $10.00 per 1,000 queries), Mapbox Directions API, AWS Location Service.
4. **Optimization Strategy:** Pre-indexes route stop sequences in relational memory maps (`route_to_stops` and spatial KD-Tree). Lookups occur in $O(1)$ memory time.
5. **Accuracy-Preserving Shortcut:** Evaluates direct legs first (Round 1); only explores transfer combinations (Round 2) if origin and destination do not share a common route corridor.
6. **Trade-offs & Limitations:** Time-of-day multipliers ($1.45\times$ AM, $1.55\times$ PM) represent sector-wide averages rather than lane-specific micro-congestion.

### Problem 2: Crowdedness-Aware Journey Planner
1. **Lowest-Cost Implementation:** Relative Crowding Index (RCI) combining baseline corridor demand with live vehicle headway deviations.
2. **Free / Open-Source Tools:** NumPy, Polars, Python `google.transit.gtfs_realtime_pb2`.
3. **Paid Services Avoided:** Proprietary crowd-analytics SaaS platforms (e.g. Inrix, TomTom Traffic Density).
4. **Optimization Strategy:** Computes headway ratios from GTFS-RT feed timestamps directly without maintaining a high-overhead time-series database.
5. **Accuracy-Preserving Shortcut:** Models crowding on a normalized $[0.05, 0.98]$ index rather than attempting to predict unobserved absolute passenger counts.
6. **Trade-offs & Limitations:** Lacking individual ticket transaction records, the index represents expected crowding rather than verified onboard headcounts.

### Problem 3: Transit Origin–Destination (OD) Matrix
1. **Lowest-Cost Implementation:** Furness Biproportional Iterative Proportional Fitting (IPF) balancing marginal trip generation and attraction against distance decay.
2. **Free / Open-Source Tools:** NumPy array operations, SciPy spatial matrices.
3. **Paid Services Avoided:** Commercial transport planning software (e.g. PTV Visum licenses costing thousands of dollars per seat, Bentley CUBE).
4. **Optimization Strategy:** Vectorized $N \times N$ matrix operations in NumPy converge in 4 iterations with zero memory reallocation.
5. **Accuracy-Preserving Shortcut:** Uses 7 broad planning sectors (Delhi TAZ) for macro-level flow desire lines before expanding to micro-zones.
6. **Trade-offs & Limitations:** Inter-zonal impedance uses centroid-to-centroid distances rather than turn-by-turn road network routing.

### Problem 4: Metro Feeder Route & Fleet Optimization
1. **Lowest-Cost Implementation:** Road network graph filtering roads $\ge 6.0\text{ m}$ carriageway width, finding candidate circular feeder loops $\le 7.0\text{ km}$, and allocating EV buses under the 500-bus constraint.
2. **Free / Open-Source Tools:** Python directed graph structures (`defaultdict`), Google OR-Tools / Dijkstra cycle traversal, GeoJSON.
3. **Paid Services Avoided:** Commercial fleet dispatch platforms (Optibus, Remix / Via, ESRI Network Analyst).
4. **Optimization Strategy:** Filters out narrow roads ($< 6.0\text{ m}$) prior to cycle search, reducing graph search space by $60\%$.
5. **Accuracy-Preserving Shortcut:** Ranks candidate loops by demand-priority-to-length ratio ($P_r / L_r$) to allocate the 500-bus budget greedily with cycle-time headway feasibility.
6. **Trade-offs & Limitations:** Assumes uniform average feeder operational speed ($18\text{ km/h}$) and does not model battery State-of-Charge (SoC) depletion or charging station queues.

### Problem 5: Bus & Metro Segment-Level Crowding
1. **Lowest-Cost Implementation:** Directional passenger flow conservation loop: $L_i = L_{i-1} + B_i - A_i$ with destination attraction decay estimating missing alightings.
2. **Free / Open-Source Tools:** Pure Python mathematical loops, NumPy.
3. **Paid Services Avoided:** Commercial sensor platforms (Iris Automated Passenger Counting hardware, APC SaaS analytics).
4. **Optimization Strategy:** Single-pass $O(N)$ accumulation along ordered stop sequences executes in under 1 millisecond per route.
5. **Accuracy-Preserving Shortcut:** Proportional downstream alighting estimation guarantees exact terminal balance ($L_n = 0$) without requiring expensive iterative matrix inversion.
6. **Trade-offs & Limitations:** While boundary conditions are exact, intermediate segment passenger counts retain an estimated uncertainty bound of $\pm 15\text{--}20\%$.

---

## 4. Non-Negotiable Engineering Integrity Rule

> [!IMPORTANT]
> Cost optimization must never come at the expense of public transit safety, accessible boarding accommodations, or transparent evaluation reporting.
> 
> When source data is unavailable, the system states its limitations plainly. It never fabricates synthetic road widths, imaginary curb cuts, or fake passenger census counts to pass benchmarks.
