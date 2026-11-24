# YATRA — System Architecture & Integration Audit

**Document ID:** AUDIT-DOC-05  
**Domain:** System Architecture, API Contracts, Database Integrity, Inter-Service Data Flow  
**Evaluator:** Principal Software Architect & DevOps Auditor  
**Audit Scope:** Full Monorepo Architecture (`apps/`, `services/`, `packages/`, `blockchain/`)  

---

## 1. Monorepo Structural Inventory

```
yatra/
├── apps/
│   ├── passenger-mobile/       # Flutter 3.47 (iOS/Android/Web) — Working UI, Mock Data
│   ├── driver-mobile/          # Flutter 3.47 (Driver tablet) — Working UI, Mock Data
│   └── operator-web/           # Next.js 16 (App Router) — Working UI, Mock Data
├── services/
│   ├── api/                    # FastAPI 0.115 Core Gateway — Minimal (/health only)
│   ├── crowding-engine/        # Empty directory (README.md only)
│   ├── accessibility-engine/   # Empty directory (README.md only)
│   ├── handshake-engine/       # Empty directory (README.md only)
│   ├── intelligence-engine/    # Empty directory (README.md only)
│   └── notification-service/   # Empty directory (README.md only)
├── packages/
│   ├── api-client/             # TypeScript fetch client — Declares 7 endpoints
│   ├── api-contracts/          # TypeScript domain contracts
│   ├── shared-types/           # TypeScript interfaces & enums
│   └── design-system/          # Design tokens & color constants
└── blockchain/
    ├── contracts/              # Solidity (TrustLedger.sol) — Compiles locally
    ├── test/                   # Foundry tests — 4 unit tests passing
    └── scripts/                # Deployment script for Sepolia
```

---

## 2. API Contract vs. Implementation Audit

A rigorous cross-comparison was performed between the endpoints specified in `packages/api-contracts` / `packages/api-client` and the actual route handlers registered in `services/api/app/api/v1/api.py`.

| API Endpoint | HTTP Method | Expected Contract | Actual Server Implementation | Database Interaction | Status |
| :--- | :---: | :--- | :--- | :--- | :---: |
| `/health` | `GET` | Root system health status | `services/api/app/main.py:48` | None | **VERIFIED** |
| `/api/v1/health` | `GET` | HealthResponse model | `services/api/app/api/v1/endpoints/health.py:11` | None | **VERIFIED** |
| `/api/v1/system/info` | `GET` | SystemInfoResponse | `services/api/app/api/v1/endpoints/system.py:11` | None | **VERIFIED** |
| `/api/v1/routes` | `GET` | List of `BusRoute` objects | **MISSING** (No route handler) | None | **MISSING** |
| `/api/v1/stops` | `GET` | List of `BusStop` objects | **MISSING** (No route handler) | None | **MISSING** |
| `/api/v1/journey/plan` | `POST` | `RouteItineraryResponse` | **MISSING** (No route handler) | None | **MISSING** |
| `/api/v1/operator/fleet/live`| `GET` | `VehicleTelemetry[]` | **MISSING** (No route handler) | None | **MISSING** |
| `/api/v1/operator/incidents` | `GET` | `IncidentReport[]` | **MISSING** (No route handler) | None | **MISSING** |
| `/api/v1/handshake/requests` | `POST` | `InitiateHandshakeRequest` | **MISSING** (No route handler) | None | **MISSING** |
| `/api/v1/od/matrix` | `GET` | OD flow matrices | **MISSING** (No route handler) | None | **MISSING** |
| `/api/v1/feeder/optimize` | `POST` | GeoJSON feeder routes | **MISSING** (No route handler) | None | **MISSING** |

**API Deficit:** Out of 11 essential endpoints required for hackathon functionality, **only 3 diagnostic endpoints exist** (27% endpoint coverage, 0% transit functionality).

---

## 3. Database Design vs. Physical Database Audit

- **Documented Specification:** `docs/database/DATABASE_DESIGN.md` defines 12 normalized PostGIS tables (`users`, `passenger_profiles`, `driver_profiles`, `operators`, `depots`, `vehicles`, `bus_routes`, `bus_stops`, `vehicle_locations`, `assistance_requests`, `incident_reports`, `trust_ledger_records`).
- **Physical Reality:**
  - `services/api/app/models/__init__.py` contains only `__all__ = []`.
  - Zero SQLAlchemy ORM model classes are defined.
  - Zero Alembic database migrations exist.
  - If a PostgreSQL instance is connected via `DATABASE_URL`, zero tables are created or queried.

---

## 4. End-to-End Workflow Audit

| Required Hackathon Workflow | Workflow Specification | Actual Execution Status | Failure Point |
| :--- | :--- | :---: | :--- |
| **Workflow A (Passenger Planner)** | Origin/Destination input $\to$ Travel-time calculation $\to$ Crowding evaluation $\to$ Ranked itineraries. | **BROKEN** | Flutter app displays hardcoded Route 502 options; no HTTP call made to backend. |
| **Workflow B (Municipal OD Analytics)** | Region/Time selection $\to$ OD engine aggregates trips $\to$ Overloaded corridor identification $\to$ MapLibre display. | **BROKEN** | Next.js portal displays static 4.2M text; no OD matrix endpoint or visualization component. |
| **Workflow C (Feeder Optimization)** | Target metro station $\to$ Road width filtering $\to$ Route generation $\to$ Fleet scheduling $\to$ GeoJSON map. | **BROKEN** | Completely non-existent on both backend and frontend. |
| **Workflow D (Corridor Crowding)** | Corridor selection $\to$ Segment load calculation $\to$ Congestion bottleneck alerts. | **BROKEN** | Next.js displays static table with 3 mock routes; no live segment load calculation. |
| **Workflow E (Boarding Handshake)** | Passenger requests assistance $\to$ Redis geofence $\to$ Driver console alert $\to$ Acknowledgment. | **BROKEN** | Both Flutter apps use local stateful booleans; no WebSocket or Redis server. |

---

## 5. Architectural Recommendations

1. **Monolithic Backend Consolidation:** Eliminate the separate empty directories under `services/`. Fold `crowding-engine`, `travel-time-engine`, `od-engine`, and `feeder-optimizer` into clean Python packages within `services/api/app/engines/`. This eliminates inter-service network overhead and simplifies testing.
2. **Immediate ORM Migration:** Implement SQLAlchemy 2.0 async models for `bus_stops`, `bus_routes`, and `segment_metrics`. Generate Alembic migrations.
3. **Seed Script Pipeline:** Implement `scripts/seed_database.py` to ingest real or high-fidelity synthetic Delhi transit data into PostGIS.
