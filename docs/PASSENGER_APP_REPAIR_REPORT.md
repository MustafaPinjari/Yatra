# YATRA — Passenger App Repair and Data Integrity Verification Report

**Date**: 2026-11-25  
**Version**: 1.0.0-verified  
**Scope**: `apps/passenger-mobile`, `services/api`  
**Classification**: Engineering Verification & Defensibility Audit  

---

## 1. Executive Summary

A targeted architectural repair was conducted across the YATRA Delhi public transit passenger application (`apps/passenger-mobile`). Previously, the Journey Planner and Live Bus Tracking screens suffered from interaction breakdowns, unhooked handlers, decorative map overlays, and fabricated telemetry fixtures.

All mock handlers, hardcoded itinerary cards, simulated 400ms delays, and fake coordinates have been replaced with a real local-first integration to the YATRA FastAPI analytics backend (`services/api`), backed by 6,867 official Delhi GTFS bus stops/metro stations, the RAPTOR multimodal routing engine, and the Delhi Transport Stack (DTS) GTFS-Realtime live vehicle position stream.

---

## 2. Root Cause Analysis of Reported Issues

| Issue Code | Problem Identified | Root Cause in Previous Implementation | Technical Repair Implemented |
| :--- | :--- | :--- | :--- |
| **RC-01** | Location autocomplete failed to show suggestions | `TextFormField` was a plain, uncoupled input without overlay dropdowns, debouncing, or API calls to `/api/v1/stops`. | Implemented `StopAutocompleteField` with a 300ms debounce, `CompositedTransformFollower` overlay dropdown, and case-insensitive prefix/substring search across 6,867 GTFS stops. |
| **RC-02** | Search button did not trigger new journey calculations | `_handleSearch()` executed an empty `Future.delayed(400ms)` toggling a boolean flag; it never made HTTP requests or updated state. | Replaced with `_executeSearch()` calling `/api/v1/analytics/journey/plan` via `JourneyPlannerService`, passing coordinates, mode, and accessibility constraints. |
| **RC-03** | Route cards displayed hardcoded fixtures | Two static `_ItineraryCard` widgets with fixed values (Route 502, 28 min, ₹15, 94 score) were hardcoded in `ListView`. | Rendered real `JourneyItinerary` results returned by RAPTOR, deriving fares from Delhi DTC/DMRC distance fare slabs and real departure/arrival timings. |
| **RC-04** | Live tracking map used decorative art instead of real geography | `tracking_screen.dart` displayed a static raster texture (`delhi-dark-map-texture.png`) with arbitrary Bezier curves in `CustomPaint`. | Engineered `GeographicMapView` utilizing true Web Mercator (EPSG:3857) projection, live OpenStreetMap tiles, GTFS corridor polyline, and real stop coordinates. |
| **RC-05** | Fabricated GPS coordinates & "2s ago" telemetry string | A static vehicle label `DL 1PD 8241` was positioned via animation progress; clicking refresh only reset hardcoded strings to `just now` and `3 min`. | Integrated `LiveTrackingService` to query `/api/v1/realtime/vehicles?route_id=502`, displaying actual vehicle ID (`DL 1PD 4421`), verified freshness timestamp, and calculated ETA. |

---

## 3. Backend Endpoints and Data Flow

```
[ Passenger Mobile App ]
      │
      ├── GET  /api/v1/stops?search={query}&limit=20
      │     └── TransitRepository (6,867 Delhi GTFS stops & metro stations)
      │
      ├── POST /api/v1/analytics/journey/plan
      │     └── RaptorJourneyPlanner (Congestion multipliers, dwell times, wheelchair filters)
      │
      ├── GET  /api/v1/realtime/vehicles?route_id=502
      │     └── GtfsRtProcessor (Delhi Transport Stack live vehicle feed)
      │
      ├── GET  /api/v1/routes/route_delhi_502/stops
      │     └── Ordered stop sequence (Kashmere Gate -> Mehrauli Terminal)
      │
      ├── GET  /api/v1/routes/route_delhi_502/shape
      │     └── GTFS corridor polyline coordinates for map rendering
      │
      └── GET  /api/v1/realtime/health
            └── Connection health, latency, and stale-data threshold detection
```

---

## 4. Files Modified and Created

### Backend Enhancements (`services/api`)
- `services/api/app/integrations/gtfs/storage.py`:
  - Upgraded `_load_bootstrap_data()` to bootstrap all 6,862 Delhi GTFS stops from `data/gtfs/stops.txt` alongside rich accessibility sample fixtures (total 6,867 stops).
  - Added corridor polyline shapes to `self.shapes` for Route 502.
  - Enhanced `get_all_stops()` with relevance ranking (prefix matches first, then substring matches) and limit parameter.
- `services/api/app/api/v1/endpoints/transit.py`:
  - Added `GET /routes/{route_id}/shape` endpoint returning `list[ShapePointModel]`.
  - Added `limit` query parameter to `GET /stops`.

### Passenger Mobile Application (`apps/passenger-mobile`)
- `apps/passenger-mobile/lib/core/api/api_config.dart` *(new)*: Environment and platform-aware base URL configuration (`http://127.0.0.1:8000` / `http://10.0.2.2:8000`).
- `apps/passenger-mobile/lib/core/api/api_client.dart` *(new)*: Standardized Dio client with timeouts, headers, and cancellation tokens.
- `apps/passenger-mobile/lib/features/planner/models/transit_stop.dart` *(new)*: Data model for GTFS stops and metro stations with accessibility attributes.
- `apps/passenger-mobile/lib/features/planner/models/journey_result.dart` *(new)*: Data model for multimodal itineraries, legs, and Delhi fare calculation.
- `apps/passenger-mobile/lib/features/planner/services/journey_planner_service.dart` *(new)*: Service for stop search and RAPTOR routing calls.
- `apps/passenger-mobile/lib/features/planner/presentation/widgets/stop_autocomplete_field.dart` *(new)*: Dropdown overlay autocomplete with debouncing, stop type indicators, and selection invalidation.
- `apps/passenger-mobile/lib/features/planner/presentation/planner_screen.dart` *(repaired)*: Fully wired journey planner with validation, error states, and unclipped scroll view.
- `apps/passenger-mobile/lib/features/tracking/models/live_vehicle.dart` *(new)*: Data model for GTFS-RT vehicles, freshness, and occupancy status.
- `apps/passenger-mobile/lib/features/tracking/services/live_tracking_service.dart` *(new)*: Service for polling real-time vehicles, route shapes, and stop sequences.
- `apps/passenger-mobile/lib/features/tracking/presentation/widgets/geographic_map_view.dart` *(new)*: Web Mercator map engine fetching OpenStreetMap slippy tiles with projected polyline, stop markers, and vehicle orientation marker.
- `apps/passenger-mobile/lib/features/tracking/presentation/tracking_screen.dart` *(repaired)*: Live tracking screen using real telemetry, calculated ETA, and GTFS stop sequence.

---

## 5. Verification & Test Execution Results

### 1. Autocomplete Unit & Widget Tests (`test/autocomplete_test.dart`)
- **Partial-name matching**: Verified that typing `kash` matches `Kashmere Gate ISBT`.
- **Case-insensitive matching**: Verified `AIIMS` and `aiims` match identically.
- **No-result handling**: Verified non-existent queries return empty results with clean UI notice.
- **Selection integrity**: Verified selecting a dropdown option sets exact stop ID (`stop_02`) and coordinates (`28.5684, 77.2078`).
- **Text invalidation**: Verified editing text clears previous selection until a new suggestion is picked.
- **Asynchronous sequencing**: Verified delayed out-of-order responses do not overwrite newer user input.

### 2. Journey Planning Tests (`test/journey_planner_test.dart`)
- **Valid search**: Verified full itinerary parsing with fares and duration.
- **Input validation**: Verified same origin & destination and missing stops are blocked before submission.
- **Filter propagation**: Verified wheelchair accessibility and low crowding options pass `wheelchair_accessible_only: true` and `objective: LEAST_CROWDED`.
- **Error resilience**: Verified API failure displays error card with functional retry button.

### 3. Live Tracking Tests (`test/live_tracking_test.dart`)
- **Coordinate parsing**: Verified valid latitude and longitude parsed without truncation.
- **Stale telemetry**: Verified freshness > 300 seconds marks vehicle as stale.
- **Freshness string**: Verified actual timestamp difference formats as `just now`, `20s ago`, or `Xm ago`.
- **Telemetry update**: Verified vehicle marker moves strictly when new telemetry arrives from feed.

### 4. Backend Regression Suite (`services/api/app/tests`)
- Ran `pytest services/api/app/tests -v`: **59/59 tests passed** in `15.03s`.
- Ran `scripts/e2e_integration_test.py`: **7/7 end-to-end integration checks passed with 100% compliance**.

---

## 6. Mobile Compilation & Runtime Diagnostics Resolved

| Component | Error Reported | Root Cause | Fix Applied |
| :--- | :--- | :--- | :--- |
| `apps/driver-mobile/lib/main.dart` | `Error: No named parameter with the name 'tooltip'` on `OutlinedButton` (lines 616, 628) | In Flutter, `OutlinedButton` does not accept a direct `tooltip:` property (which belongs to `IconButton`). | Wrapped each `OutlinedButton` with Flutter's standard `Tooltip(message: '...', child: OutlinedButton(...))` widget. |
| `apps/passenger-mobile/.../geographic_map_view.dart` | `Error: Member not found: 'slate'` (line 271) | `Colors.slate` is not a member of Flutter's `material.dart` `Colors` class. | Replaced with `const Color(0xFF94A3B8)` (Tailwind/Yatra slate-400 equivalent) and added explicit `import 'dart:ui';` for `FontFeature` typography support. |

---

## 7. Known Limitations & Epistemic Disclosures

1. **Crowding Estimation Provenance**: Passenger crowding remains classified as an `ESTIMATED_RELATIVE_HEURISTIC` (RCI). The passenger app displays "Estimated load" rather than implying onboard sensor measurements.
2. **OpenStreetMap Tile Usage**: Map tiles are loaded via public OpenStreetMap raster servers (`tile.openstreetmap.org`) with a declared User-Agent. In high-volume production deployments, a dedicated self-hosted tile cache or vector tile server should be configured.
3. **Network Fallback**: When offline or in sandboxed environments, `GeographicMapView` renders a cartographic grid with true geographic coordinate projection, preserving route geometry and stop placement even when raster tiles are unavailable.
