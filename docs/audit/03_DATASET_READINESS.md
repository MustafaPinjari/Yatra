# YATRA — Dataset Readiness & Data Pipeline Audit

**Document ID:** AUDIT-DOC-03  
**Domain:** Delhi Transport Stack Data Infrastructure  
**Audited Datasets:** Bus GPS, Bus ETM, Static GTFS, GTFS-RT, Metro AFC, Road Network  
**Audit Date:** November 2026  

---

## 1. Dataset Inventory & Physical Inspection

An exhaustive scan of the repository storage directories (`data/`, `data/raw/`, `data/processed/`, `data/gps/`, `data/ticketing/`, `data/gtfs/`, `data/sample/`) was conducted.

### 1.1 Datasets Physically Present in Repository

| Filename | Directory Path | Format | Actual File Size | Row Count | Attributes / Columns | Temporal Coverage | Geographic Coverage | Quality / Missing Values | Status |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| `sample_routes.json` | `data/sample/` | JSON | 714 B | 3 | `id`, `routeShortName`, `routeLongName`, `originName`, `destinationName`, `operatorCode` | Static | Delhi (Route 502, 534, TMS) | 0% missing | Toy sample fixture |
| `sample_stops.json` | `data/sample/` | JSON | 1,871 B | 5 | `id`, `gtfsStopId`, `nameEn`, `nameHi`, `location.latitude`, `location.longitude`, `accessibilityScore`, `hasWheelchairRamp`, `hasTactilePaving`, `hasShelter`, `curbHeightCm` | Static | Kashmere Gate to Mehrauli | 0% missing | Toy sample fixture |

### 1.2 Required Datasets Audit & Gap Assessment

| Dataset Category | Expected File(s) & Description | Expected Size | Expected Row Count | Upstream Source & License | Problem Statement | Physical Availability | Fallback Strategy If Unobtained |
| :--- | :--- | :---: | :---: | :--- | :---: | :---: | :--- |
| **Historical Bus GPS** | `delhi_bus_gps_oct2026.7z` (31 daily SQLite DBs) | 16.1 GB (.7z)<br>~124 GB (.db) | ~1.2 Billion records | Delhi Transport Dept / Hackathon Portal (Open Data) | P1 | **MISSING** | Synthesize high-density GPS trajectory traces for Route 502/534 using OSRM + speed noise generator. |
| **Bus ETM Ticketing** | `etm_tickets_oct2026.csv.gz` (Handheld conductor ETM logs) | 66 MB (.gz)<br>~290 MB (csv) | ~2.56 Million records | DIMTS / DTC ETM Stream | P2, P3, P5 | **MISSING** | Generate realistic synthetic ETM transactions matching GTFS stop stages and hourly peak distributions. |
| **Static Bus GTFS** | `routes.txt`, `stops.txt`, `trips.txt`, `stop_times.txt`, `shapes.txt` | ~45 MB (zip) | ~4,500 stops<br>~800 routes | Delhi Open Data Portal (`opendata.delhi.gov.in`) | P1, P2, P3, P4, P5 | **MISSING** | Ingest official Delhi GTFS zip directly from open transit data repository. |
| **Live GTFS-RT** | `VehiclePositions.pb`, `TripUpdates.pb` | Live stream | 10s poll cycle | Delhi Open Transit API (OTD) | P1 | **MISSING** | Mock GTFS-RT protocol buffer replay server emitting positions along route shapes. |
| **Metro Static GTFS** | DMRC lines, station gates, platforms | ~8 MB | ~280 stations | DMRC Open Transit Feed | P3, P4, P5 | **MISSING** | Ingest official DMRC station shapefile and GTFS feed. |
| **Metro Gate AFC Footfall** | Hourly entry/exit tap records per station gate | ~15 MB | ~1.2M entries | DMRC Operational Telemetry | P3, P5 | **MISSING** | Calibrate station-level marginal distributions using published DMRC daily ridership reports (4.2M avg). |
| **Delhi Road Network** | OSM road edges, lane counts, carriageway widths | ~220 MB | ~180k road links | OpenStreetMap (Overpass API / Geofabrik) | P4 | **MISSING** | Extract Delhi road network bounding box using OSMnx, retaining `width`, `lanes`, and `highway` tags. |

---

## 2. Dataset Readiness Matrix by Problem Statement

```
┌────────────────────────────────────────────────────────────────────────┐
│ PROBLEM STATEMENT           REQUIRED DATASETS          READINESS %     │
├────────────────────────────────────────────────────────────────────────┤
│ P1: Traffic Model & Planner  GPS Archive, GTFS, RT       0.5% (Toy)    │
│ P2: Crowdedness Planner      ETM Logs, GTFS              0.5% (Toy)    │
│ P3: Transit OD Matrix        ETM Logs, Metro AFC, Zones  0.0% (None)   │
│ P4: Feeder Bus Optimization  OSM Roads, Metro Gates, EV  0.0% (None)   │
│ P5: Segment-Level Crowding   ETM Logs, Metro Line AFC    0.0% (None)   │
├────────────────────────────────────────────────────────────────────────┤
│ OVERALL DATASET READINESS:                               1.5%          │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Data Pipeline & Ingestion Engineering Plan

To prevent system crashes when processing large-scale archives (e.g. 124 GB uncompressed GPS):

### 3.1 Strict Out-of-Core Processing Rules:
1. **Never Load Raw Archives into RAM or Postgres:**
   - Raw SQLite files must be queried out-of-core using **DuckDB** or **Polars lazy frames**.
   - Extract records in chunks (e.g., partitioned by date `YYYY-MM-DD` and route `route_id`).
2. **Columnar Intermediate Storage (Parquet):**
   - Cleaned, deduplicated, and map-matched trajectory points must be written to snappy-compressed Parquet files in `data/processed/`.
   - Partition scheme: `data/processed/gps/date=2026-10-01/route=502/part-0.parquet`.
3. **Database Insertion Budget:**
   - Only load aggregated segment-level metrics (e.g., 15-minute median speed, 95th percentile travel time, mean dwell time per stop) into PostgreSQL/PostGIS.
   - Never insert 1.2 billion raw GPS coordinates into relational tables.
