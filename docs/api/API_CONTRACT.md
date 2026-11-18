# YATRA — API Contract & Endpoint Specification

**Document Version:** 1.0.0  
**Base URL:** `/api/v1`  
**Protocol:** REST (HTTP/2) + WebSockets (WSS)  
**Author:** Principal Software Architect  

---

## 1. API Design Principles & Conventions

1. **RESTful Resource Modeling:** Nouns are pluralized (`/routes`, `/stops`, `/assistance-requests`).
2. **Kebab-Case URLs:** All URL path segments use lowercase alphanumeric characters with hyphens.
3. **CamelCase JSON:** Request and response body attributes use standard camelCase.
4. **Versioning:** The major API version is explicitly prefixed in the path (`/api/v1/...`).
5. **Standard Timestamps:** All dates and times are formatted in ISO-8601 UTC (`YYYY-MM-DDTHH:MM:SSZ`).
6. **Geospatial Formats:** GeoJSON schemas (`Point`, `LineString`, `FeatureCollection`) are standard for spatial endpoints.

---

## 2. Authentication & Authorization

Authentication utilizes Bearer JWT tokens in the `Authorization` header:
```http
Authorization: Bearer <jwt_access_token>
```

### Roles:
- `COMMUTER`: Public passenger queries, initiating handshakes, reporting incidents.
- `DRIVER`: Acknowledging handshakes, updating shift status, viewing route alerts.
- `OPERATOR`: Dispatch operations, fleet management, incident resolution.
- `INSPECTOR`: Depot accessibility audits and signing Trust Ledger records.
- `ADMIN`: Full platform configuration.

---

## 3. Standard Response & Error Envelope

All responses adhere to the standard envelope format:

### Success Response (`200 OK`, `201 Created`):
```json
{
  "success": true,
  "data": { ... },
  "metadata": {
    "timestamp": "2026-11-18T09:30:00Z",
    "requestId": "req_8f1a23c4"
  }
}
```

### Error Response (`400`, `401`, `403`, `404`, `422`, `500`):
```json
{
  "success": false,
  "error": {
    "code": "ACCESSIBILITY_PROFILE_NOT_FOUND",
    "message": "No accessibility profile exists for bus stop stop_delhi_502_04.",
    "details": []
  },
  "metadata": {
    "timestamp": "2026-11-18T09:30:00Z",
    "requestId": "req_8f1a23c4"
  }
}
```

---

## 4. Initial Endpoint Inventory

### 4.1 System & Health (Unauthenticated)
- `GET /health` — Basic uptime probe.
- `GET /api/v1/health` — Detailed health probe checking PostgreSQL and Redis connectivity.
- `GET /api/v1/system/info` — System version, active environment, and module status.

### 4.2 Authentication & User Profiles
- `POST /api/v1/auth/login` — Login via phone/password, returns JWT access and refresh tokens.
- `POST /api/v1/auth/refresh` — Exchange refresh token for new access token.
- `GET /api/v1/users/me` — Retrieve current authenticated profile.
- `PATCH /api/v1/users/me/accessibility` — Update passenger accessibility preferences (ramp, visual, hearing).

### 4.3 Transit Network & Accessibility (AccessGraph)
- `GET /api/v1/stops` — Query stops with geospatial filters (`lat`, `lng`, `radiusKm`).
- `GET /api/v1/stops/{stopId}` — Detailed stop information including micro-accessibility score and features.
- `GET /api/v1/routes` — List transit routes with origin, destination, and operator details.
- `GET /api/v1/routes/{routeId}` — Full route geometry, ordered stop list, and active vehicle count.
- `POST /api/v1/planner/plan-trip` — Accessible trip planner balancing travel time, accessibility scores, and predicted crowding.

### 4.4 Crowd Intelligence
- `GET /api/v1/crowding/routes/{routeId}` — Historical and predicted occupancy tiers per stop for a route.
- `GET /api/v1/crowding/vehicles/{vehicleId}/live` — Current estimated passenger count and crowding tier for a bus.

### 4.5 AccessHandshake (Passenger-to-Driver)
- `POST /api/v1/handshake/requests` — Initiate boarding assistance request for an approaching bus.
- `GET /api/v1/handshake/requests/{requestId}` — Check request status.
- `POST /api/v1/handshake/requests/{requestId}/cancel` — Cancel active request.
- `POST /api/v1/handshake/requests/{requestId}/acknowledge` — (Driver only) Acknowledge assistance request.
- `POST /api/v1/handshake/requests/{requestId}/outcome` — (Driver/Conductor) Log post-stop resolution.
- `WS /api/v1/handshake/ws/passenger/{passengerId}` — Real-time WebSocket connection for passenger updates.
- `WS /api/v1/handshake/ws/driver/{driverId}` — Real-time WebSocket connection for in-cab driver alerts.

### 4.6 Operations, Incidents & AI Triage
- `GET /api/v1/operator/fleet/live` — Operator overview of active vehicles, locations, and crowding statuses.
- `GET /api/v1/operator/incidents` — Triage queue of accessibility grievances and defects.
- `POST /api/v1/incidents` — Commuter/driver submits an accessibility incident report.
- `POST /api/v1/incidents/{incidentId}/triage` — Trigger Google Gemini 2.5 Flash to generate structured summary, severity score, and recommended action.

### 4.7 Trust Ledger (Blockchain Verification)
- `GET /api/v1/trust/inspections/{inspectionId}` — Retrieve inspection certificate data and its SHA-256 hash.
- `POST /api/v1/trust/verify` — Validate that a raw certificate JSON matches the on-chain recorded hash on Ethereum Sepolia.
- `GET /api/v1/trust/records` — List recent on-chain synchronization receipts.

