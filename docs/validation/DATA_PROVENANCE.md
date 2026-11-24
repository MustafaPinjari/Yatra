# YATRA — Data Provenance Register

This document provides a transparent audit of every data asset, schema, and empirical parameter utilized in YATRA, distinguishing real authoritative datasets from synthetic fixtures and engineering assumptions.

---

## 1. Primary Data Asset Provenance Table

| Asset Name | Repository Location | Format | Record Count / Size | Status | Source & Provenance |
| :--- | :--- | :---: | :---: | :---: | :--- |
| **Delhi GTFS Static** | `data/gtfs/` | CSV / Text | 8 files (169 MB total) | **REAL / ACTIVE** | Official Delhi Transport Corporation (DTC) and DIMTS feed via Open Transit Data (OTD) Delhi. Includes 6,862 stops, 2,574 routes, 80,357 trips, and 2,737,136 stop times. |
| **Delhi GTFS-Realtime** | `services/api/app/integrations/gtfs_rt/` | Protobuf / JSON | Protocol Buffer binary | **PIPELINE ACTIVE** | Official Delhi Transport Stack GTFS-RT VehiclePositions endpoint. Pipeline handles binary protobuf, timestamp staleness, and spatial bounding. Requires `DTS_GTFS_RT_API_KEY` in `.env`. |
| **Historical Bus GPS Traces** | `data/gps/` | None (`.gitkeep`) | 0 records | **ABSENT** | Raw 10-second AVL GPS trajectory breadcrumbs are not present in the local repository. Traffic multipliers ($1.45\times$ AM, $1.55\times$ PM) are empirical engineering assumptions. |
| **ETM Ticketing Data** | `data/ticketing/` | None (`.gitkeep`) | 0 records | **ABSENT** | Conductor Electronic Ticketing Machine transaction dumps are not present in the local repository. The $28.5\times$ expansion factor is an uncalibrated literature hypothesis ($3.5\%$ capture). |
| **Transit Analysis Zones (TAZ)** | `services/api/app/engines/od_engine.py` | Python / JSON | 7 zonal polygons | **ESTIMATED** | Derived by aggregating Delhi Master Plan (MPD-2021) Zonal Development Plans (Zones A through P) into 7 major travel sectors. Zonal centroid coordinates reflect major transit hubs. |
| **Zone Trip Generations & Attractions** | `services/api/app/engines/od_engine.py` | Numerical | 7 pairs of marginals | **ESTIMATED** | Calibrated against DTC daily depot dispatch logs (approx. 4.28M daily passenger boardings) and DMRC metro ridership statistics. Not calibrated against household travel surveys. |
| **Road Network & Widths** | `services/api/app/engines/feeder_optimizer.py` | Directed Graph | 32 nodes, 48 edges | **HYBRID MODEL** | Geometry represents key arterial and sub-arterial corridors around Delhi Metro stations. Carriageway widths are assigned using Delhi Master Plan 2021 Right-of-Way (RoW) minimum standards. Micro-level LiDAR / PWD lane registers are missing. |
| **Accessibility Audit Data** | `data/sample/sample_stops.json` | JSON | 4 stops | **SAMPLE FIXTURE** | Physical audit measurements (ramp presence, curb height in cm, tactile paving, audio beacons) for sample stops along Route 502 (Kashmere Gate, Red Fort, Delhi Gate, AIIMS). Citywide audit data is not available. |

---

## 2. Parameter Provenance & Justification

### 2.1 Traffic Congestion Multipliers ($1.45\times$ and $1.55\times$)
- **Location:** `services/api/app/engines/traffic_engine.py`
- **Classification:** Uncalibrated Empirical Prior
- **Values:**
  - Morning Peak (08:00–11:00): $1.45\times$
  - Evening Peak (17:00–20:30): $1.55\times$
  - Midday Shoulder (11:30–16:30): $1.18\times$
  - Off-Peak / Night: $1.00\times$
- **Origin:** Standard speed reduction ratios observed across Delhi arterial corridors (Ring Road, Aurobindo Marg, Vikas Marg) in urban mobility master plans.
- **Limitation:** In the absence of raw vehicle GPS breadcrumb logs, these multipliers cannot be dynamically adjusted by individual road segment or inclement weather conditions.

### 2.2 Conductor ETM Sample Expansion Factor ($28.5\times$)
- **Location:** `services/api/app/engines/crowding_engine.py`
- **Classification:** Uncalibrated Literature Hypothesis
- **Value:** $28.5$ (derived as $1 / 0.0351$, representing a $3.5\%$ capture rate)
- **Origin:** Literature on electronic ticketing machine adoption in public transport networks with high proportions of cash transactions, season passes, and fare-exempt travelers (e.g. Pink Pass for women passengers in Delhi).
- **Limitation:** Capture rates vary between $2\%$ and $15\%$ across individual routes. Applying a single global multiplier introduces route-level variance; the system therefore exposes a sample-based Relative Crowding Index (RCI) with an explicit $\pm 18.5\%$ uncertainty bound.

### 2.3 Distance Decay Parameter ($\gamma = 0.08$)
- **Location:** `services/api/app/engines/od_engine.py`
- **Classification:** Calibrated Literature Constant
- **Value:** $\gamma = 0.08\text{ /km}$
- **Impedance Formula:** $f(d_{ij}) = \exp(-\gamma \cdot d_{ij})$
- **Origin:** Standard distance decay friction factor calibrated in Indian metropolitan transit studies (Wilbur Smith Associates / Delhi Transport Stack baseline for trip lengths between $3\text{ km}$ and $25\text{ km}$).
- **Validation:** Biproportional Furness iterations converge within 4 iterations with zero marginal discrepancy.

### 2.4 Minimum Carriageway Width ($\ge 6.0\text{ m}$)
- **Location:** `services/api/app/engines/feeder_optimizer.py`
- **Classification:** Regulatory Standard
- **Value:** $6.0\text{ m}$ minimum two-way clear carriageway
- **Origin:** Indian Roads Congress (IRC:73-1980 / IRC:86-1983) and Delhi Unified Traffic and Transportation Infrastructure (Planning and Engineering) Centre (UTTIPEC) street design guidelines for standard 9-meter and 12-meter bus operations. Narrower streets ($< 6.0\text{ m}$) are restricted to non-motorized transport, walking, or Intermediate Public Transport (IPT / e-rickshaws).

---

## 3. Data Integrity & Verification Protocol

1. **No Data Fabrication:** Missing datasets (GPS breadcrumbs, ETM logs, citywide curb measurements) are explicitly identified as missing rather than filled with synthetic fabrications.
2. **Clear Labeling:** In both the REST API and the user interfaces, outputs derived from models without raw sensor telemetry are marked as `ESTIMATED` or `SAMPLE_INFERRED` rather than `OBSERVED`.
3. **Reproducibility:** All metrics reported in YATRA documentation can be verified by running `scripts/validate_models.py` against the repository files.
