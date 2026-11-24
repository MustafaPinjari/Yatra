# YATRA — Critical Gap Register & Weakness Analysis

**Document ID:** AUDIT-DOC-07  
**Evaluation Role:** Principal Software Architect & Lead Auditor  
**Scope:** 15 Highest-Impact Weaknesses Ranked by Technical & Hackathon Severity  

---

## 1. Top 15 Highest-Impact Weaknesses Ranked

| Rank | Gap ID | Severity | Problem Statement | Weakness Title | Technical & Judging Impact | Dependencies | Estimated Effort | Acceptance Criteria |
| :-: | :---: | :---: | :---: | :--- | :--- | :--- | :---: | :--- |
| **1** | **GAP-01** | `CRITICAL` | P1, P2 | **No Transit Routing Engine Exists** | Flutter planner displays hardcoded itineraries for 1 route; cannot route arbitrary origin/destination coordinates. Disqualification risk on interactive demo. | Real GTFS feed | 16 hours | RAPTOR or NetworkX transit graph routing between any two coordinates in Delhi NCT bounds. |
| **2** | **GAP-02** | `CRITICAL` | P4 | **Feeder Route Optimization Completely Missing** | 0% implementation for Problem 4. Scoring zero points on a mandatory problem statement. | OSM road network, Metro coordinates | 18 hours | Python module using OR-Tools or NetworkX generating feeder routes $\le 7$ km on roads $> 6$ m with $\le 500$ EV fleet. |
| **3** | **GAP-03** | `CRITICAL` | P1 | **Absence of Real Bus GPS Trajectory Processing** | No GPS cleaning, map matching, dwell-time detection, or empirical travel-time prediction. Claimed speed/ETA is ungrounded. | GPS Archive / Synthetic Traces | 14 hours | DuckDB/Polars pipeline calculating 15-minute median segment travel times and dwell times per stop. |
| **4** | **GAP-04** | `CRITICAL` | P2 | **Missing ETM Expansion & Crowding Model** | No ETM parser; naive scalar assumption violates 3–4% ticket capture realities and misses pass holders. | ETM transactions | 12 hours | Calibrated Relative Crowding Index (RCI) combining historical baseline, ticketing volume, and headway bunching. |
| **5** | **GAP-05** | `CRITICAL` | P3 | **Public Transit OD Matrix Engine Missing** | Next.js portal displays static 4.2M text; no bus or metro OD matrix construction, zone aggregation, or export. | DMRC footfall, ETM stages | 14 hours | Iterative Proportional Fitting (IPF) pipeline outputting zone-to-zone passenger flow matrices in CSV/Parquet. |
| **6** | **GAP-06** | `CRITICAL` | P5 | **Segment-Level Passenger Load Model Missing** | No passenger flow conservation ($L_i = L_{i-1} + B_i - A_i$) or directional load curve generation. | ETM tickets, DMRC lines | 10 hours | Segment-level load calculator computing directional passenger accumulation across route sequences. |
| **7** | **GAP-07** | `HIGH` | API | **FastAPI Server Lacks Transit Domain Routes** | 8 out of 11 required endpoints are missing from `services/api/app/api/v1/api.py`. Frontends cannot communicate with backend. | FastAPI, Engine modules | 12 hours | Routes `/routes`, `/stops`, `/journey/plan`, `/operator/fleet/live`, `/od/matrix`, `/feeder/optimize` fully implemented. |
| **8** | **GAP-08** | `HIGH` | Database | **Zero ORM Models or Migrations in Database** | `services/api/app/models/` is empty; PostgreSQL has zero tables. No persistence for telemetry, routes, or stops. | SQLAlchemy 2.0, PostGIS | 8 hours | Declarative models for `bus_stops`, `bus_routes`, `assistance_requests`, and `incident_reports` with Alembic migration. |
| **9** | **GAP-09** | `HIGH` | Frontend | **Flutter Mobile App Decoupled from API** | `apps/passenger-mobile` uses hardcoded Dart arrays; no HTTP client (Dio) configured to query backend endpoints. | GAP-07 (API endpoints) | 10 hours | Riverpod providers querying `http://localhost:8000/api/v1` for routes, stops, and journey planning. |
| **10**| **GAP-10** | `HIGH` | Frontend | **Next.js Web Portal Decoupled from API** | `apps/operator-web` uses static React state; cannot display real fleet telemetry, OD matrices, or incidents. | GAP-07 (API endpoints) | 8 hours | React Server Components / SWR hooks fetching live data from FastAPI endpoints. |
| **11**| **GAP-11** | `MEDIUM` | Core | **Boarding Handshake Protocol Lacks WebSocket/Redis** | Passenger-to-driver handshake is simulated via local boolean; no real-time push to driver console. | Redis / FastAPI WebSockets | 8 hours | Bidirectional WebSocket endpoint broadcasting assistance requests to active driver consoles within 500m. |
| **12**| **GAP-12** | `MEDIUM` | Data | **Missing Official Delhi GTFS Ingestion Pipeline** | Only 3 sample routes and 5 sample stops exist in `data/sample/`. No parser for official Delhi GTFS zip files. | Delhi Open Data GTFS | 6 hours | Automated GTFS loader script populating PostGIS stops and route polylines. |
| **13**| **GAP-13** | `MEDIUM` | Core | **Trust Ledger Contract Not Relayed from Backend** | Solidity smart contract compiles, but backend has no Web3/Eth client to anchor incident resolution hashes. | Web3.py, Sepolia RPC | 6 hours | Backend service hashing resolved maintenance tickets and executing `recordInspection` via Web3.py. |
| **14**| **GAP-14** | `MEDIUM` | Testing | **Zero Algorithmic or Model Evaluation Tests** | Test suite only tests root health checks and widget rendering. No validation metrics (MAE, RMSE, accuracy). | Pytest, Data fixtures | 8 hours | Pytest test suite asserting travel-time prediction MAE < 5 min and conservation of passenger flow. |
| **15**| **GAP-15** | `LOW` | Docs | **Unsubstantiated Operational Claims in UI** | UI states "Live GPS telemetry: 2s ago" and "Sepolia ledger synced" while disconnected from live feeds. | Unslop skill rules | 4 hours | Ground UI copy to indicate data freshness, simulation mode, and model confidence scores transparently. |

---

## 2. Weakness Categorization

```
┌────────────────────────────────────────────────────────┐
│ CRITICAL Gaps (Problem Statement Execution):   6 (40%) │
│ HIGH Gaps (Architecture, Database & Wiring):   4 (27%) │
│ MEDIUM Gaps (Real-time, GTFS & Blockchain):    4 (27%) │
│ LOW Gaps (Copy & Transparency):                1 ( 7%) │
└────────────────────────────────────────────────────────┘
```
