# YATRA — Technology Stack Evaluation & Selection

**Document Version:** 1.0.0  
**Author:** Principal Software Architect  

---

## 1. Overview & Architectural Philosophy

YATRA adheres to a **free-first, open-source-friendly, and deterministic-core** philosophy:
1. **Zero Mandatory Paid Subscriptions:** Base functionality must run without requiring proprietary paid APIs (such as Google Maps Platform fees). OpenStreetMap and MapLibre provide free cartography.
2. **Deterministic Safety:** Transit scheduling, route calculations, and driver communications are strictly executed by deterministic algorithms. Generative AI is reserved for assistive cognitive simplification and multilingual translation.
3. **High Performance & Resource Efficiency:** Vectorized data processing (DuckDB, Polars) handles millions of telemetry points without heavy distributed cluster overhead.

---

## 2. Frontend Technologies

### 2.1 Mobile Applications (Passenger & Driver)
- **Selected:** **Flutter & Dart (v3.13+)**
- **Purpose:** Cross-platform mobile clients targeting Android, iOS, and in-vehicle tablets.
- **Why Selected:**
  - Single codebase for both mobile operating systems with 60/120 FPS native graphics rendering.
  - Robust accessibility APIs (`Semantics`, screen-reader announcements, high-contrast theming).
  - First-class support for audio synthesis, background WebSockets, and Bluetooth BLE.
- **Alternatives Considered:** React Native (slower performance on low-end transit tablets; more complex native bridging for accessibility semantics), Native Kotlin/Swift (requires maintaining dual codebases during rapid prototype iteration).
- **Licensing:** BSD-3-Clause (Open Source).

### 2.2 Operator Web Dashboard
- **Selected:** **Next.js 15 (React 19, TypeScript, App Router, Tailwind CSS)**
- **Purpose:** Central fleet dispatch, accessibility incident triage, and authority audit interface.
- **Why Selected:**
  - Modern React Server Components (RSC) provide high performance and low client bundle sizes.
  - Tailwind CSS enables WCAG 2.2 AA compliant accessible palettes and responsive design tokens.
  - Native TypeScript guarantees end-to-end type safety when consuming shared API models.
- **Alternatives Considered:** Vite + React SPA (lacks server-side rendering for audit report generation), Angular (steeper learning curve for community transit contributors).
- **Licensing:** MIT License.

### 2.3 Mapping & Geovisualization
- **Selected:** **MapLibre GL JS & OpenStreetMap**
- **Purpose:** Interactive vector maps, route lines, stop markers, and bus telemetry visualization.
- **Why Selected:** Open-source fork of Mapbox GL without licensing fees or tile-request metering limits.
- **Licensing:** BSD-3-Clause / ODbL.

---

## 3. Backend Technologies

### 3.1 API Framework
- **Selected:** **FastAPI (Python 3.12)**
- **Purpose:** High-throughput asynchronous REST and WebSocket API Gateway.
- **Why Selected:**
  - Native asynchronous I/O (`asyncio`) allows thousands of concurrent WebSocket handshake connections.
  - Automatic OpenAPI (Swagger) schema generation guarantees transparent API contracts.
  - Deep integration with Pydantic v2 ensures strict runtime data validation.
- **Alternatives Considered:** Django REST Framework (heavier footprint, slower async throughput), Go / Gin (superb performance, but lacks immediate ecosystem compatibility with Python ML and GIS libraries like GeoPandas and Shapely).
- **Licensing:** MIT License.

### 3.2 Data Persistence & Spatial Store
- **Selected:** **PostgreSQL 16 with PostGIS 3.4**
- **Purpose:** Spatial and relational database holding stops, routes, assistance requests, and audit logs.
- **Why Selected:** PostGIS is the global standard for geospatial data operations (`ST_DWithin`, `ST_Intersects`, `ST_Distance`).
- **Licensing:** PostgreSQL License / GPL-2.0 (PostGIS).

### 3.3 Cache & Event Broker
- **Selected:** **Redis 7 (Alpine)**
- **Purpose:** High-speed in-memory caching, vehicle geofencing (`GEO` commands), and real-time Pub/Sub for passenger-driver handshakes.
- **Licensing:** BSD-3-Clause / RSALv2.

---

## 4. Data Engineering & Intelligence

### 4.1 Vectorized Analytics & Data Processing
- **Selected:** **DuckDB & Polars**
- **Purpose:** In-memory OLAP processing of massive Delhi GTFS schedules, GPS traces, and ticketing files.
- **Why Selected:**
  - DuckDB can execute SQL directly on compressed Parquet and CSV files faster than traditional data warehouses.
  - Polars provides lightning-fast multi-threaded DataFrame transformations with minimal memory consumption compared to Pandas.
- **Licensing:** MIT License.

### 4.2 Machine Learning
- **Selected:** **LightGBM & Scikit-learn**
- **Purpose:** Headway-based bus crowding prediction and ETA variance modeling.
- **Licensing:** MIT / BSD.

### 4.3 Generative AI
- **Selected:** **Google Gemini 2.5 Flash via official Google Gen AI SDK (`google-genai`)**
- **Purpose:** Multilingual assistance explanations (Hindi, English, Punjabi, Urdu) and structured incident description extraction.
- **Free-Tier Considerations:** Accessible via free Google AI Studio developer keys with generous rate limits.
- **Licensing:** Commercial / Free developer tier.

---

## 5. Blockchain & Verification

### 5.1 Smart Contract Framework
- **Selected:** **Solidity 0.8.24 + Foundry + OpenZeppelin Contracts**
- **Target Network:** **Ethereum Sepolia Testnet**
- **Purpose:** Tamper-proof public verification of depot accessibility inspections and resolved service tickets.
- **Why Selected:** Foundry provides blazing fast Rust-based compilation and testing without Node.js tooling bloat; OpenZeppelin provides battle-tested security standards (`AccessControl`, `ReentrancyGuard`).
- **Licensing:** MIT License.

---

## 6. Development & Quality Tooling

| Category | Tool | License | Purpose |
| :--- | :--- | :--- | :--- |
| **Python Linter & Formatter** | Ruff | MIT | 10x-100x faster than Flake8/Black/isort |
| **Python Type Checker** | Mypy | MIT | Static typing validation |
| **Testing** | Pytest + pytest-asyncio | MIT | Asynchronous unit and integration tests |
| **Frontend Linter** | ESLint + Prettier | MIT | Code quality and accessibility linting |

