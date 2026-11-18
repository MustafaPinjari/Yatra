# YATRA Transit Data Assets (`data/`)

Directory structure for Delhi Transport Corporation (DTC) and DIMTS cluster data streams.

## Structure

- `raw/`: Unprocessed external files (gitignored).
- `processed/`: Optimized Parquet files for the crowding engine.
- `gtfs/`: Static GTFS feeds (agencies, routes, stops, schedules).
- `gps/`: 10-second vehicle telemetry traces.
- `ticketing/`: Anonymized ETM transaction summaries.
- `sample/`: Minimal verified synthetic and sampled fixtures for automated tests.

