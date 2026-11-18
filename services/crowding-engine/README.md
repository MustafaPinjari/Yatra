# YATRA Crowd Intelligence Engine (`services/crowding-engine`)

Deterministic and machine-learning bus occupancy and travel time estimation module.

## Core Responsibilities

1. **Telemetry Ingestion:** Ingests Delhi Open GTFS schedules, 10-second GPS traces, and e-ticketing transaction logs.
2. **High-Speed Processing:** Powered by **DuckDB** and **Polars** for multi-threaded columnar transformations.
3. **Occupancy Tiers:**
   - `LOW` (< 30%): Guaranteed seating available.
   - `MEDIUM` (30-70%): Moderate occupancy, seats filling.
   - `HIGH` (70-95%): Standing room only.
   - `OVERCROWDED` (> 95%): Severe crowding; boarding constrained for mobility devices.
4. **ETA & Headway Reliability:** Calculates headway variation and bus bunching indexes.

