# YATRA — Security Policy & Privacy Architecture

**Document Version:** 1.0.0  
**Compliance Standards:** DPDP Act (India, 2023), GDPR, OWASP Top 10  
**Author:** Technical Lead & Systems Architect  

---

## 1. Authentication & Role-Based Access Control (RBAC)

1. **Token Hierarchy:**
   - Stateless **JSON Web Tokens (JWT)** signed via HMAC-SHA256 (`HS256`) or RS256.
   - **Access Tokens:** 60-minute expiration to minimize damage from token leakage.
   - **Refresh Tokens:** 7-day expiration, stored in encrypted Redis cache with automatic rotation.

2. **Role Enforcements:**
   - Requests are intercepted by FastAPI dependency injection (`get_current_active_user`).
   - Endpoint decorators enforce explicit role permissions (e.g., `@require_roles([Role.OPERATOR, Role.ADMIN])`).

---

## 2. Passenger Privacy & Sensitive Health Data

1. **Disability & Assistance Data Protection:**
   - Specific medical diagnoses or disability documentation are **never collected**.
   - The platform strictly stores functional assistance capabilities (e.g., `requires_ramp`, `requires_visual_assistance`, `requires_extra_time`).
   - Assistance request records are detached from passenger identities in reporting aggregates.

2. **Explicit User Consent:**
   - First-time passenger registration requires explicit opt-in consent for sharing boarding assistance needs with on-duty drivers on designated trips.

---

## 3. Location Privacy & GPS Retention Policy

1. **Passenger Real-Time Geolocation:**
   - Passenger location is processed ephemerally in device memory to determine the nearest bus stop.
   - Passenger GPS coordinates are **never persisted** to database disk storage; only the selected `stop_id` is recorded during assistance requests.

2. **Bus Fleet GPS Telemetry:**
   - High-frequency GPS traces (10-second vehicle intervals) are retained for 30 days for operational optimization, after which they are aggregated into hourly route metrics and purged from operational stores.

---

## 4. Blockchain Privacy Boundary (Trust Ledger)

Public blockchain networks (Ethereum Sepolia testnet) are accessible to anyone globally. Storing sensitive data on-chain creates irreversible privacy violations.

### Strictly Prohibited from On-Chain Storage:
- :x: Passenger names, phone numbers, or account IDs.
- :x: Passenger disability tags or assistance logs.
- :x: Vehicle GPS trajectories or raw telemetry.
- :x: Incident complaint photos, witness statements, or driver personal details.

### Permitted On-Chain Data:
- :white_check_mark: Cryptographic SHA-256 hashes of depot accessibility inspection certificates.
- :white_check_mark: Cryptographic SHA-256 hashes of resolved maintenance tickets.
- :white_check_mark: Non-sensitive depot inspector public Ethereum address (`0x...`).
- :white_check_mark: Block timestamp.

---

## 5. Data Encryption & Secrets Management

1. **In-Transit:**
   - All external HTTP/WebSocket communication mandates TLS 1.3 encryption.
2. **At-Rest:**
   - PostgreSQL and Redis volumes utilize AES-256 volume encryption.
   - Passwords hashed using Argon2id or bcrypt with high work factors.
3. **Secrets Management:**
   - Zero hardcoded API keys or private keys in source code.
   - Enforced by pre-commit hooks and `.gitignore` patterns.
   - Configurations loaded strictly via runtime environment variables (`.env`).

---

## 6. API Rate Limiting & Protection

- To prevent denial-of-service and scraping of public transit assets, API endpoints enforce rate limits via Redis sliding windows:
  - Public search/routing queries: 60 requests/minute per IP.
  - Handshake requests: 10 requests/minute per authenticated commuter.
  - Driver status updates: 120 requests/minute per authenticated driver.
- Global exception middleware catches all unhandled exceptions and sanitizes stack traces before returning generic error messages to clients.

