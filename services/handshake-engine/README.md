# YATRA Handshake Engine (`services/handshake-engine`)

Real-time passenger-to-driver boarding assistance coordination protocol.

## Core Responsibilities

1. **Assistance State Machine:** `REQUESTED` -> `ACKNOWLEDGED` -> `BOARDING` -> `COMPLETED`.
2. **Geofenced Alerts:** Redis pub/sub triggers driver console alerts when an approaching bus enters within 500m of an active assistance request.
3. **Auditory & Visual Dispatch:** Transmits structured payloads containing required accommodations (e.g. wheelchair ramp, vision assist).

