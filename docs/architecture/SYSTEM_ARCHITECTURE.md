# YATRA — System Architecture Specification

**Document Version:** 1.0.0  
**Status:** Approved  
**Author:** Principal Software Architect  

---

## 1. High-Level Architecture Overview

YATRA is engineered as an event-driven, modular monorepo system. The architecture isolates user-facing touchpoints (Passenger Mobile, Driver Tablet, Operator Web) from core computation engines (Crowding, Accessibility, Handshake, Intelligence), unified by a high-throughput asynchronous API Gateway.

```mermaid
flowchart TB
    subgraph Clients["Client Layer"]
        PWA["Passenger Mobile<br/>(Flutter / Dart)"]
        DMA["Driver Assist App<br/>(Flutter / Dart)"]
        OWD["Operator Command<br/>(Next.js 15 / React)"]
    end

    subgraph Edge["Gateway & Communication Layer"]
        APIGW["FastAPI Core Gateway<br/>(:8000)"]
        WSHUB["WebSocket Manager<br/>(Handshake Engine)"]
    end

    subgraph DomainServices["Domain & Intelligence Services"]
        CE["Crowding Engine<br/>(DuckDB / Polars / Scikit)"]
        AG["Accessibility Engine<br/>(PostGIS AccessGraph)"]
        IE["Intelligence Engine<br/>(Google Gemini 2.5 Flash)"]
        NS["Notification Service<br/>(Push / TTS Audio)"]
    end

    subgraph DataPersistence["Storage & Verification Layer"]
        POSTGRES[("PostgreSQL 16 + PostGIS<br/>Spatial & Relational Store")]
        REDIS[("Redis 7<br/>Pub/Sub & Geospatial Cache")]
        CHAIN[("Trust Ledger<br/>Ethereum Sepolia (Solidity)")]
    end

    subgraph ExternalSources["Transit Data Inputs"]
        GTFS[("Delhi Open GTFS<br/>Static Schedules")]
        GPS[("Delhi Live Telemetry<br/>GPS Oct 2026")]
        TICKETS[("E-Ticketing Summaries<br/>Fare & Boarding Counts")]
    end

    %% Client communication
    PWA -->|HTTPS / REST| APIGW
    PWA <-->|WSS (Handshake)| WSHUB
    DMA <-->|WSS (Driver Alerts)| WSHUB
    OWD -->|HTTPS / REST| APIGW

    %% Gateway to services & state
    APIGW <--> POSTGRES
    APIGW <--> REDIS
    WSHUB <--> REDIS
    APIGW --> CE
    APIGW --> AG
    APIGW --> IE
    APIGW --> NS

    %% Intelligence to data
    CE --> GTFS
    CE --> GPS
    CE --> TICKETS
    AG <--> POSTGRES
    APIGW -->|Audit Hashes| CHAIN
```

---

## 2. Frontend & Backend Communication Protocols

1. **RESTful APIs (HTTP/2 with TLS 1.3):**
   - Standard CRUD operations: route schedules, stop queries, incident submissions, operator administrative tasks.
   - Standardized JSON responses following the JSend/RFC-7807 specification.

2. **WebSocket & Redis Pub/Sub (Real-Time Communication):**
   - Real-time `AccessHandshake` protocol runs over persistent WebSockets.
   - Redis Geospatial indexes (`GEOADD`, `GEORADIUSBYMEMBER`) track approaching buses relative to waiting passengers at bus stops.
   - When a bus enters the 500m threshold of an active assistance request, Redis publishes an event consumed by the driver's active WebSocket channel.

---

## 3. Service Responsibilities

### 3.1 API Gateway (`services/api`)
- Central entry point and request router.
- Enforces authentication (JWT), role-based permissions (Commuter, Driver, Operator, Admin), request validation, and rate limiting.
- Provides standard health check endpoints (`/health`, `/api/v1/health`, `/api/v1/system/info`).

### 3.2 Crowding Engine (`services/crowding-engine`)
- Processes raw Delhi transit data (GTFS, GPS streams, ticketing logs).
- Uses **DuckDB** and **Polars** for memory-efficient vectorized aggregations.
- Applies deterministic headway-occupancy heuristics and LightGBM regression models to predict bus crowding levels per stop and time slot.

### 3.3 Accessibility Engine (`services/accessibility-engine`)
- Manages the **AccessGraph** data structure stored in PostGIS.
- Computes accessibility scores (0.0 - 100.0) for stops and pedestrian paths.
- Provides multi-criteria route optimization balancing distance, transfers, and physical accessibility features (ramps, tactile paving).

### 3.4 Handshake Engine (`services/handshake-engine`)
- Manages state machines for passenger boarding assistance:
  `REQUESTED` $\rightarrow$ `ACKNOWLEDGED` $\rightarrow$ `BOARDING` $\rightarrow$ `COMPLETED` (or `EXPIRED` / `MISSED`).
- Low-latency bi-directional messaging between passenger app and driver tablet.

### 3.5 Intelligence Engine (`services/intelligence-engine`)
- Integrates with **Google Gemini 2.5 Flash** using the official Google Gen AI SDK (`google-genai`).
- Generates natural-language accessibility descriptions in multiple languages (Hindi, English, Punjabi, Urdu).
- Interprets unstructured passenger feedback and classifies accessibility incidents into structured schemas for operator resolution.
- **Architectural Boundary:** All routing calculations, fare evaluations, and bus occupancy predictions remain 100% deterministic in Python; Gemini is strictly used for cognitive simplification, translation, and structured content extraction.

### 3.6 Notification Service (`services/notification-service`)
- Dispatches in-app banners, push alerts, and audio-synthesis payloads.
- Converts upcoming stop alerts into driver audio cues using local or platform TTS.

---

## 4. Database Architecture (PostgreSQL + PostGIS)

PostgreSQL 16 with the PostGIS extension serves as the single source of truth for all spatial, relational, and audit data:
- **Spatial Tables:** `bus_stops`, `bus_routes`, `pedestrian_segments`, `depots`, `vehicle_locations`.
- **Relational Tables:** `users`, `passenger_profiles`, `driver_profiles`, `vehicles`, `assistance_requests`, `incident_reports`, `accessibility_inspections`, `trust_records`.
- **Spatial Indexing:** GIST indexes on all geometry/geography columns ensure sub-millisecond proximity and spatial-join queries.

---

## 5. Blockchain Integration (Trust Ledger)

To ensure verifiable compliance without compromising user privacy, YATRA utilizes a smart contract deployed on the **Ethereum Sepolia testnet**:
- **Anchor Hash Scheme:** An off-chain inspection certificate containing inspector ID, depot, vehicle VIN, checklist items, and timestamp is serialized to canonical JSON. The SHA-256 hash of this JSON is calculated.
- **On-Chain Storage:** The smart contract stores:
  - `recordHash` (`bytes32`): The cryptographic hash of the audit record.
  - `recordType` (`uint8`): 1 for Inspection, 2 for Incident Resolution, 3 for Compliance.
  - `inspectorAddress` (`address`): Authorized transport authority or depot auditor.
  - `timestamp` (`uint256`): Block timestamp when anchored.
- **Privacy Assurance:** No PII, no passenger photos, no GPS tracks, and no medical conditions are ever sent to the blockchain.

---

## 6. External Data Sources & Integration Boundaries

- **Delhi Open Transit Data (DIMTS / DTC):**
  - Static GTFS: stop locations, route lines, trips, stop times.
  - Real-time GPS: 10-second vehicle telemetry.
  - E-ticketing transactions: hourly boarding counts.
- **OpenStreetMap & MapLibre GL JS:**
  - Free, open-source cartographic tiles and geocoding primitives.
  - Avoids paid third-party vendor lock-in.

---

## 7. Security Boundaries

- **Network Boundary:** Public web and mobile clients communicate over HTTPS/WSS with TLS 1.3. Internal engines and database services communicate on a private Docker bridge network.
- **Authentication:** Asymmetric/symmetric JWT verification with short-lived access tokens (60 min) and rotating refresh tokens.
- **Database Boundary:** Parameterized queries via SQLAlchemy 2 ORM prevent SQL injection; PostGIS operations use safe spatial functions (`ST_DWithin`, `ST_MakePoint`).
- **Secrets:** All credentials, private keys, and API tokens loaded strictly via environment variables conforming to 12-factor application methodology.

