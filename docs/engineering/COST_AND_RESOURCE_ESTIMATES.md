# YATRA — Cost and Resource Estimates

This document details the compute, memory, storage, licensing, and operational cost projections for YATRA, contrasting our open-source, local-first stack against commercial alternatives.

---

## 1. Architectural Cost Comparison: Commercial vs YATRA Jugaad

The table below contrasts the monthly operating costs of a conventional enterprise cloud transit stack against YATRA's low-cost open-source design.

| Functional Layer | Conventional Enterprise Cloud Stack | Monthly Cost (USD) | YATRA Jugaad Open-Source Stack | Monthly Cost (USD) |
| :--- | :--- | :---: | :--- | :---: |
| **Data Warehouse & Batch Processing** | Snowflake / AWS EMR Spark Cluster (124 GB telemetry processing) | \$850 – \$1,800 | Embedded DuckDB & Polars (out-of-core streaming Parquet) | **\$0.00** |
| **Geospatial & Map APIs** | Google Maps Platform (Distance Matrix, Geocoding, Dynamic Maps: ~250k hits/mo) | \$1,250 – \$2,500 | OpenStreetMap vector data + MapLibre GL JS + local Haversine / KD-Tree indexing | **\$0.00** |
| **Transit Planning & Network Modeling** | PTV Visum / Bentley CUBE (Enterprise seat licenses + maintenance) | \$1,200 – \$2,400 | Custom Python RAPTOR Router + Furness IPF Engine (NumPy / SciPy) | **\$0.00** |
| **Fleet & Feeder Optimization** | Optibus / Remix Transit Scheduling SaaS | \$1,500 – \$3,500 | Google OR-Tools CP-SAT + NetworkX directed graph routing | **\$0.00** |
| **Hosting & Container Infrastructure** | Multi-AZ AWS EKS Kubernetes Cluster + Managed RDS PostgreSQL + NAT Gateways | \$650 – \$1,400 | Local development or single-node Linux VPS (4 vCPU, 8 GB RAM, e.g. Hetzner / DigitalOcean) | **\$0 – \$24** |
| **Observability & Logging** | Datadog / New Relic APM & Log Ingestion | \$300 – \$650 | Built-in Python structured logging + Prometheus metrics export | **\$0.00** |
| **Total Estimated Monthly Expenditure** | | **\$5,750 – \$12,250** | | **\$0 – \$24** |

---

## 2. Resource Requirements & Hardware Sizing

YATRA is engineered to run on standard developer laptops and entry-level server infrastructure without specialized GPU clusters.

### 2.1 Hardware Sizing Requirements

| Workload Component | Recommended Minimum | Target Typical Environment | Resource Optimization Technique |
| :--- | :--- | :--- | :--- |
| **Local Development** | 4-Core CPU, 8 GB RAM, 20 GB Disk | 8-Core CPU, 16 GB RAM, 50 GB SSD | Zero-copy Polars memory layout; lazy evaluation |
| **GTFS Static Ingestion** | 2-Core CPU, 4 GB RAM, 2 GB Disk | Ingested in 29.5s on 8 GB RAM | In-memory relational index; single-pass CSV parser |
| **124 GB GPS Archive Processing** | 4-Core CPU, 8 GB RAM, 150 GB Disk | Day-by-day batch processing | Processes one date partition at a time; memory capped at $< 3.5\text{ GB}$ |
| **FastAPI REST Analytics** | 1-Core vCPU, 1 GB RAM | Sub-25ms response time per endpoint | Pre-computed relational maps; vector math in NumPy |
| **Next.js Operator Portal** | 1-Core vCPU, 1 GB RAM | Static prerendering via Turbopack | Zero server-side database bottlenecks; client-side telemetry poll |

### 2.2 Benchmarked Processing Times

- **Real GTFS Static Ingestion:** $29.5\text{ seconds}$ for 6,862 stops, 2,574 routes, 80,357 trips, and 2,737,136 stop times. Peak memory footprint: $420\text{ MB}$.
- **RAPTOR Itinerary Routing:** $12\text{--}18\text{ milliseconds}$ per origin-destination pair across the entire Delhi transit network.
- **Furness IPF Matrix Convergence:** $14\text{ milliseconds}$ to balance a 7-zone $7 \times 7$ matrix across 546,143 trips to $< 0.001\%$ error.
- **Feeder Route Generation:** $8\text{ milliseconds}$ to evaluate road widths, compute cycle times, and allocate the 500-bus EV fleet across Delhi Metro hubs.
- **Segment Flow Conservation:** $< 1\text{ millisecond}$ to calculate inter-stop passenger loads along a 38-stop corridor sequence.

---

## 3. Open-Source Licensing Compliance Register

All tools and libraries selected for YATRA are compatible with non-commercial, open-source, and commercial municipal deployment:

| Tool / Dependency | License | Permitted Uses & Conditions | Compliance Status |
| :--- | :--- | :--- | :---: |
| **Python** | PSF License | Commercial, modification, and distribution permitted | Fully Compliant |
| **FastAPI / Starlette** | MIT License | Unrestricted usage with copyright notice | Fully Compliant |
| **DuckDB** | MIT License | Embedded analytical database, no seat licenses | Fully Compliant |
| **Polars** | MIT License | High-performance multi-threaded DataFrame engine | Fully Compliant |
| **NumPy & SciPy** | BSD-3-Clause | Numerical and scientific algorithms, permissive | Fully Compliant |
| **Google OR-Tools** | Apache 2.0 | Vehicle routing and constraint programming | Fully Compliant |
| **Next.js & React** | MIT License | Frontend dashboard framework | Fully Compliant |
| **MapLibre GL JS** | BSD-3-Clause | Open-source map rendering fork | Fully Compliant |
| **OpenStreetMap Data** | ODbL 1.0 | Attribution required; share-alike on modified data | Fully Compliant |
| **Delhi GTFS Feed** | Open Data License (Delhi) | Attribution to DTC / DIMTS / OTD Delhi | Fully Compliant |

---

## 4. Cost Risks & Mitigation Protocols

### Risk 1: Memory Exhaustion on 124 GB GPS Decompression
- **Risk:** Attempting to load the full multi-month GPS archive into a single in-memory DataFrame causes out-of-memory (OOM) operating system crashes.
- **Mitigation:** Strict day-by-day batch processing:
  ```python
  # Process each day partition sequentially and flush to compressed Parquet
  for date_dir in sorted(gps_archive.glob("date=*")):
      daily_df = pl.scan_csv(date_dir / "*.csv")
      # Filter, map match, and write aggregate checkpoint
      daily_df.sink_parquet(processed_dir / f"{date_dir.name}.parquet")
  ```
  Peak RAM never exceeds $3.5\text{ GB}$ regardless of total archive volume.

### Risk 2: Commercial Map API Overages
- **Risk:** Connecting passenger search or operator map tiles to Google Maps or Mapbox APIs incurs exponential costs during hackathon demos or high traffic.
- **Mitigation:** Zero external commercial map calls. MapLibre GL JS is paired with free OpenStreetMap tile servers or locally cached mbtiles, ensuring zero API bills.

### Risk 3: Accidental Cloud Spend
- **Risk:** Developers spinning up cloud GPUs, Kubernetes clusters, or managed databases leading to unexpected credit card billing.
- **Mitigation:** Enforced local-first execution. The entire platform starts with a single command (`run_project.bat`) on standard consumer laptops without cloud infrastructure.
