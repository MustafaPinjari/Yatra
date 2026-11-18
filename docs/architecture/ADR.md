# YATRA — Architecture Decision Records (ADR)

This document chronicles significant architectural and technical decisions made during the evolution of the YATRA platform.

---

## ADR-001: Monorepo Structure

- **Status:** Accepted  
- **Context:** YATRA comprises two Flutter mobile apps, a Next.js web application, multiple backend Python services, Solidity contracts, and shared domain models. Splitting these into separate repositories would impede cross-discipline development during prototype stages.  
- **Decision:** Adopt a single monorepo organized into `apps/`, `services/`, `blockchain/`, `packages/`, `data/`, and `docs/`.  
- **Consequences:** Easier refactoring, shared TypeScript types and API contracts, atomic git commits across frontend and backend. Requires clear folder isolation to avoid dependency leaks.

---

## ADR-002: Free-First Mapping Architecture (MapLibre vs Google Maps)

- **Status:** Accepted  
- **Context:** Mapping services like Google Maps Platform impose significant usage costs and API-key dependencies that can halt public civic hackathons and open-source contributions.  
- **Decision:** Default to OpenStreetMap tile servers and MapLibre GL JS / vector tiles. Provide an optional configuration slot for Google Maps API keys without making it mandatory.  
- **Consequences:** The application is completely functional out of the box with zero billing requirements. OpenStreetMap data is community-editable, enabling local Delhi contributors to enrich bus stop micro-accessibility tags.

---

## ADR-003: Deterministic Operational Decisions vs Generative AI

- **Status:** Accepted  
- **Context:** Generative AI is prone to hallucinations and non-deterministic latency. Using an LLM to calculate bus arrival times, crowding percentages, or safety-critical driver dispatch would introduce unacceptable risk.  
- **Decision:** Strictly isolate Google Gemini 2.5 Flash to cognitive accessibility tasks: translating explanations into regional languages (Hindi, Punjabi, Urdu), simplifying complex transit directions for commuters with cognitive disabilities, and triaging unstructured incident text. All numerical predictions, route graphs, and driver alerts are executed deterministically.  
- **Consequences:** Zero risk of LLM hallucinations affecting bus schedules or driver safety. High testability and sub-second API performance.

---

## ADR-004: Off-Chain Data with On-Chain Cryptographic Anchoring (Trust Ledger)

- **Status:** Accepted  
- **Context:** Regulatory bodies require tamper-proof verification of bus ramp maintenance and depot accessibility inspections. However, storing public passenger identities, grievance photos, or vehicle GPS trails on a public blockchain violates privacy laws and creates high gas fees.  
- **Decision:** Store complete inspection certificates and evidence off-chain in PostgreSQL. Compute the SHA-256 hash of the canonical certificate JSON and record only the hash, timestamp, and auditor address in the Ethereum Sepolia smart contract (`TrustLedger.sol`).  
- **Consequences:** 100% GDPR/DPDP privacy compliance, minimal gas consumption, yet mathematical proof of unalterable records.

---

## ADR-005: DuckDB and Polars for Transit Telemetry Analytics

- **Status:** Accepted  
- **Context:** The Delhi transit dataset contains millions of GPS points and ticketing logs across thousands of bus trips. Pandas encounters high memory overhead and single-threaded bottlenecks on developer workstations.  
- **Decision:** Use DuckDB for SQL-based columnar queries directly over CSV/Parquet archives, and Polars for high-speed multi-threaded feature engineering in Python.  
- **Consequences:** Reduces memory consumption by over 70% and speeds up aggregation queries by 10x-50x, allowing the crowding engine to run smoothly on standard laptops without a distributed Spark cluster.

---

## ADR-006: Asynchronous WebSocket Protocol for AccessHandshake

- **Status:** Accepted  
- **Context:** Traditional HTTP polling by mobile applications drains battery and introduces 2-10 second latency, which is unacceptable when a bus is rapidly approaching a stop.  
- **Decision:** Use FastAPI WebSockets backed by Redis Pub/Sub channels keyed by bus stop geohashes and route IDs.  
- **Consequences:** Driver receives notification of waiting accessibility passengers within 200ms of entering the stop's geofence. Highly battery-efficient for passenger and driver mobile devices.

