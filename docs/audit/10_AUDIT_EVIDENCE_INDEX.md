# YATRA — Technical Audit Evidence Index & Verification Log

**Document ID:** AUDIT-DOC-10  
**Audit Executed:** November 2026  
**Operating System:** Windows 11 (PowerShell 5.1 / cmd.exe)  
**Host Environment:** Node.js 20+, Python 3.12.10, Flutter 3.47.1, Solidity 0.8.20  
**Verification Tools:** Flutter Analyze, Flutter Test, ESLint, Next.js Turbopack Build, Pytest, Foundry, Netstat  

---

## 1. Physical Files Inspected

### Frontend Applications:
1. `apps/passenger-mobile/lib/main.dart` (App entry, Riverpod ProviderScope, GoRouter)
2. `apps/passenger-mobile/lib/features/intro/presentation/intro_screen.dart` (Onboarding, accessibility toggles)
3. `apps/passenger-mobile/lib/features/home/presentation/home_screen.dart` (Search bar, quick chips, approaching bus card)
4. `apps/passenger-mobile/lib/features/planner/presentation/planner_screen.dart` (Itinerary list, step-free badges, travel time)
5. `apps/passenger-mobile/lib/features/assistance/presentation/assistance_screen.dart` (Handshake transmission, state machine)
6. `apps/passenger-mobile/lib/features/stops/presentation/accessible_stops_screen.dart` (AccessGraph ratings, curb height, filters)
7. `apps/passenger-mobile/lib/features/tracking/presentation/tracking_screen.dart` (Vehicle coordinates, speed, heading)
8. `apps/passenger-mobile/lib/core/router/app_router.dart` (GoRouter routes)
9. `apps/driver-mobile/lib/main.dart` (High-contrast driver console, acknowledgment toggle)
10. `apps/operator-web/src/app/page.tsx` (Root dashboard, view switcher)
11. `apps/operator-web/src/components/screens/OperatorCommandView.tsx` (KPI strip, fleet map, assistance queue)
12. `apps/operator-web/src/components/screens/GovtIntelligenceView.tsx` (4.2M ridership, compliance metrics, Sepolia badge)
13. `apps/operator-web/src/components/FleetOverview.tsx` (Corridor crowding table, load percentages)
14. `apps/operator-web/src/components/AssistanceRequestsTable.tsx` (Live requests, priority badges)
15. `apps/operator-web/src/components/IncidentQueue.tsx` (Incident triage, depot work orders)

### Backend & Packages:
16. `services/api/app/main.py` (FastAPI app, CORS, lifespan, root `/health`)
17. `services/api/app/api/v1/api.py` (APIRouter, health and system subrouters)
18. `services/api/app/api/v1/endpoints/health.py` (Health endpoint returning JSON)
19. `services/api/app/api/v1/endpoints/system.py` (System info returning module list)
20. `services/api/app/core/config.py` (Settings, pydantic_settings, env loading)
21. `services/api/app/db/session.py` (SQLAlchemy async engine and sessionmaker)
22. `services/api/app/models/__init__.py` (Empty models module, 18 bytes)
23. `packages/shared-types/src/index.ts` (Domain models: BusStop, BusRoute, VehicleTelemetry)
24. `packages/api-contracts/src/index.ts` (Request/response interfaces: PlanJourney, Handshake)
25. `packages/api-client/src/index.ts` (YatraApiClient fetch wrapper)
26. `blockchain/contracts/TrustLedger.sol` (Solidity smart contract, inspection recording)
27. `blockchain/contracts/ITrustLedger.sol` (Solidity interface)
28. `blockchain/test/TrustLedger.t.sol` (Foundry unit tests)

### Data & Specifications:
29. `data/sample/sample_routes.json` (3 sample bus routes)
30. `data/sample/sample_stops.json` (5 sample bus stops with accessibility scores)
31. `docs/product/PRODUCT_REQUIREMENTS.md` (Product requirements specification)
32. `docs/architecture/SYSTEM_ARCHITECTURE.md` (System architecture specification)
33. `docs/database/DATABASE_DESIGN.md` (PostGIS entity dictionary and schema specs)
34. `docs/research/DELHI_DATA_STRATEGY.md` (Data strategy and ML pipeline plan)
35. `YATRA_Antigravity_Hackathon_Implementation_Spec.md` (810-line comprehensive hackathon brief)

---

## 2. Command Execution Log & Output Evidence

| # | Command Executed | Execution Mode | Exit Code | Observed Output / Evidence |
| :-: | :--- | :---: | :-: | :--- |
| **C01** | `flutter analyze` (in `apps/passenger-mobile`) | Elevated (BypassSandbox) | `0` | `No issues found! (ran in 58.6s)`. 0 warnings, 0 errors. |
| **C02** | `flutter test` (in `apps/passenger-mobile`) | Elevated (BypassSandbox) | `0` | `00:02 +3: All tests passed!`. Verified 3 widget test specs. |
| **C03** | `npm run lint` (in `apps/operator-web`) | Sandboxed | `0` | `eslint` passed with 0 errors. |
| **C04** | `npm run build` (in `apps/operator-web`) | Sandboxed | `0` | `Compiled successfully in 2.7s`. Prerendered static pages `/` and `/_not-found`. |
| **C05** | `.venv\Scripts\pytest` (root) | Sandboxed | `0` | `3 passed in 0.25s` (`test_health.py`: root health, v1 health, v1 system info). |
| **C06** | `uvicorn app.main:app --port 8000` | Elevated Daemon | Running | `Uvicorn running on http://0.0.0.0:8000`. PID 22268. |
| **C07** | `npm run dev` (in `apps/operator-web`) | Elevated Daemon | Running | `Ready in 1713ms`. Next.js dev server listening on `http://localhost:3000`. |
| **C08** | `flutter run -d web-server --web-port 8080` | Elevated Daemon | Running | `lib\main.dart is being served at http://0.0.0.0:8080`. |
| **C09** | `Invoke-RestMethod http://localhost:8000/health` | Elevated | `0` | Returned `{"success": true, "data": {"status": "healthy"}}`. |
| **C10** | `Invoke-WebRequest http://localhost:3000` | Elevated | `0` | Returned HTTP `200 OK`. |
| **C11** | `Invoke-WebRequest http://localhost:8080` | Elevated | `0` | Returned HTTP `200 OK`. |

---

## 3. Dataset Audit Evidence

```
Directory: C:\Users\mustafa\Desktop\Yatra\data
├── gps\ (.gitkeep only — 0 bytes)
├── gtfs\ (empty — 0 bytes)
├── processed\ (.gitkeep only — 0 bytes)
├── raw\ (.gitkeep only — 0 bytes)
├── ticketing\ (.gitkeep only — 0 bytes)
├── sample\
│   ├── sample_routes.json (714 bytes, 3 routes)
│   └── sample_stops.json (1,871 bytes, 5 stops)
└── README.md (510 bytes)
```

**Finding:** Out of an estimated ~125 GB of required raw transport data, only **2.58 KB of synthetic sample JSON fixtures** exist on disk.

---

## 4. Unverified Assumptions & Hardcoded Artifacts

1. **Hardcoded Travel Times:** `apps/passenger-mobile/.../planner_screen.dart` hardcodes route durations to 42 min and 51 min without querying any travel-time model.
2. **Hardcoded Crowding Levels:** `apps/passenger-mobile/.../planner_screen.dart` hardcodes crowding to "Low" and "Medium" without evaluating ETM logs or headway bunching.
3. **Hardcoded Telemetry:** `apps/passenger-mobile/.../tracking_screen.dart` hardcodes coordinates `28.5684, 77.2078`, speed `24 km/h`, and heading `182°`.
4. **Hardcoded Fleet Occupancy:** `apps/operator-web/.../OperatorCommandView.tsx` hardcodes 48 active buses, 62% fleet occupancy, and 3 live handshakes.
5. **Hardcoded Municipal Ridership:** `apps/operator-web/.../GovtIntelligenceView.tsx` hardcodes 4.2M daily ridership and 420 audited stops.

---

## 5. Auditor Sign-Off & Verification Stamp

- **Audit Completion Timestamp:** 2026-11-24T21:44:00+05:30
- **Auditor Role:** Principal Software Architect, Transport Data Scientist & Hackathon Evaluator
- **Monorepo Git SHA:** `e24e1eb`
- **Integrity Status:** All 10 audit documents written to `docs/audit/` without modifying application source code.
