# YATRA — Product Requirements Document (PRD)

**Document Version:** 1.0.0  
**Status:** Approved for Phase 1 Prototype  
**Author:** Technical Product Lead & System Architect  

---

## 1. Executive Summary & Vision

**Product Name:** YATRA (Your Accessible Transport & Reliable Assistance Platform)  
**Tagline:** *Every Passenger. Every Bus. Every Journey.*  

YATRA is a universal public transit accessibility, operations, and intelligence platform. It bridges the critical physical, communicative, and cognitive accessibility gap in urban municipal bus networks by enabling proactive communication between passengers with accessibility requirements, on-duty bus drivers, fleet dispatchers, and urban planning authorities.

The platform combines deterministic transit data engines (crowding prediction, ETA calculation, curb-to-bus accessibility graphs) with assistive generative AI (multilingual accessibility explanations, audio guidance, structured incident triaging) and decentralized verification (on-chain inspection and resolution audit trails).

---

## 2. Problem Statement

Public bus transport in megacities such as Delhi operates at immense scale, serving over 4 million passenger trips daily across thousands of buses and bus stops. Despite this scale, severe systemic pain points persist:

1. **Boarding Uncertainty for Persons with Disabilities (PwD):**
   - Wheelchair users, visually impaired commuters, and mobility-impaired passengers often wait at bus stops without knowing whether an arriving bus is low-floor, equipped with an operational ramp, or has free wheelchair bay capacity.
   - Drivers frequently stop in the middle lane or pull away before an impaired passenger can reach the door, because the driver has no advance notification that an assistance request exists at the upcoming stop.

2. **Severe, Unpredictable Crowding:**
   - Overcrowding causes severe discomfort and poses insurmountable barriers to elderly and disabled commuters. Existing passenger transit apps provide static timetables without real-time, stop-by-stop passenger occupancy forecasting.

3. **Driver Cognitive Overload:**
   - Bus drivers operate under heavy traffic stress and tight headway schedules. Demanding that drivers monitor complex mobile interfaces leads to distraction. Driver interfaces must be minimal, glanceable, and voice-assisted.

4. **Lack of Verifiable Accountability:**
   - Accessibility audits (e.g., verifying whether a bus ramp was inspected, or whether a broken kneeling mechanism was fixed) are currently recorded in opaque paper logs or vulnerable internal databases, making independent auditing and trust verification impossible.

---

## 3. Target User Groups & Personas

### Persona 1: Sunita (Passenger with Mobility Impairment)
- **Profile:** 34-year-old daily commuter using a motorized wheelchair.
- **Pain Point:** Bus stops lack curb ramps; arrives at stop only to discover arriving buses have non-functioning hydraulic ramps or are too crowded to board.
- **YATRA Journey:** Plans route filtering strictly for "Level Boarding / Low-Floor". Signals an "AccessHandshake" 5 minutes before bus arrival. Arriving driver is alerted 400m before the stop to position adjacent to the curb and deploy the ramp.

### Persona 2: Rajesh (Bus Driver)
- **Profile:** 48-year-old DTC municipal bus driver on Route 502 (Mehrauli to Kashmere Gate).
- **Pain Point:** Cannot see small crowds waiting in poorly lit bus shelters at night; does not know a wheelchair user is waiting until past the stop line.
- **YATRA Journey:** DriverAssist audio cue announces: *"Upcoming Stop: AIIMS. Wheelchair boarding requested on Door 2."* Driver pulls smoothly to the designated accessible boarding bay.

### Persona 3: Ananya (Fleet Operations Dispatcher)
- **Profile:** Central Command Centre officer monitoring fleet performance across Delhi's South Zone.
- **Pain Point:** Receives passenger grievance reports hours after incidents occur; no real-time visibility into accessibility compliance or crowding bottlenecks.
- **YATRA Journey:** Monitors Operator Command dashboard. Receives real-time alerts on passenger assistance outcomes, crowding surges, and maintenance defects.

### Persona 4: Amit (Daily Office Commuter)
- **Profile:** 27-year-old commuter traveling between Rohini and Connaught Place.
- **Pain Point:** Frustrated by buses arriving completely packed, requiring waiting for 3 consecutive buses.
- **YATRA Journey:** Views real-time occupancy heatmaps on YATRA Passenger Mobile, chooses a bus with low crowding departing 8 minutes later, guaranteeing a seated journey.

### Persona 5: Dr. Verma (Transport Authority Official)
- **Profile:** Joint Director, Department of Transport.
- **Pain Point:** Needs verifiable, unalterable proof of depot accessibility inspections and compliance metrics to disburse operator viability gap funding.
- **YATRA Journey:** Accesses Government Intelligence portal and verifies depot inspection hashes on the Ethereum Sepolia Trust Ledger.

---

## 4. Functional Requirements

### 4.1 AccessGraph (Accessibility Intelligence)
- **FR-AG-01:** System shall store and score micro-accessibility attributes for bus stops: curb height, tactile paving, shelter availability, ramp incline, lighting, and audio signage.
- **FR-AG-02:** Routing engine shall support filtering by accessibility tier (Standard, Wheelchair Accessible, Vision Assist, Senior Friendly).
- **FR-AG-03:** Inaccessible segments along walking paths shall trigger alternate accessible stop suggestions.

### 4.2 AccessHandshake (Passenger-to-Driver Communication)
- **FR-AH-01:** Passengers can initiate an assistance request for an approaching bus within 15 minutes of scheduled arrival.
- **FR-AH-02:** Handshake request shall specify assistance category (Wheelchair ramp deployment, Visual assistance, Cognitive/boarding extra time, General mobility aid).
- **FR-AH-03:** DriverAssist receives handshake via low-latency Redis WebSocket stream when the vehicle crosses the 500-metre geofence of the stop.
- **FR-AH-04:** Driver acknowledges the alert with a single physical/large-target tap or voice acknowledgment.
- **FR-AH-05:** Outcome is logged automatically upon vehicle departure (Completed, Missed, Overcrowded).

### 4.3 DriverAssist (Driver Operational Console)
- **FR-DA-01:** High-contrast, glanceable UI designed for tablet/in-cab mount with dark mode default.
- **FR-DA-02:** Spoken audio cues in Hindi and English using text-to-speech for critical alerts.
- **FR-DA-03:** Current route progression, next stop name, passenger assistance badges, and headway status.

### 4.4 Crowd Intelligence (Occupancy & Travel Time)
- **FR-CI-01:** Process Delhi GTFS schedules, October 2026 bus GPS records, and e-ticketing transaction summaries to estimate bus occupancy.
- **FR-CI-02:** Classify crowding into 4 standardized tiers: Low (<30%), Medium (30-70%), High (70-95%), Overcrowded (>95%).
- **FR-CI-03:** Expose REST and streaming endpoints returning route-level and stop-level crowding forecasts.

### 4.5 Operator Command (Dispatch & Fleet Management)
- **FR-OC-01:** Live fleet overview map with vehicle markers color-coded by crowding and accessibility status.
- **FR-OC-02:** Incident triage queue displaying unresolved accessibility grievances and maintenance flags.
- **FR-OC-03:** Accessibility inspection verification panel displaying off-chain details and on-chain ledger hashes.

### 4.6 Trust Ledger (Decentralized Verification)
- **FR-TL-01:** Smart contract on Ethereum Sepolia testnet recording immutable inspection completion hashes.
- **FR-TL-02:** Verification endpoint allows anyone to cross-check an inspection certificate JSON payload against its on-chain hash.
- **FR-TL-03:** Zero PII, passenger identities, or GPS coordinates shall ever be submitted to the contract.

---

## 5. Non-Functional Requirements

- **Accessibility:** Full compliance with WCAG 2.2 AA for web applications and Android/iOS Accessibility Guidelines for mobile apps.
- **Latency:** Real-time handshake events delivered in < 500ms under standard 4G mobile conditions.
- **Resilience:** Offline-first caching on mobile clients; routes and stop schedules cached locally.
- **Security:** Strict Role-Based Access Control (RBAC), TLS 1.3 encryption, SHA-256 integrity verification.
- **Data Privacy:** Passenger location data anonymized; GPS retention limited to 30 days in production.
- **Free-First Dependency Architecture:** OpenStreetMap and MapLibre GL JS utilized to avoid proprietary mapping license dependencies.

---

## 6. MVP Scope (Phase 1 Hackathon Deliverable)

| Feature | In Scope (MVP) | Out of Scope (Future) |
| :--- | :--- | :--- |
| **Crowding-Aware Trip Planner** | Yes (using Delhi GTFS & sample telemetry) | Machine learning edge inferencing inside vehicle CAN bus |
| **AccessHandshake Simulation** | Yes (WebSockets + Redis pub/sub) | Hardware OBD-II / CAN-bus integration |
| **Operator Web Dashboard** | Yes (Fleet map, incidents, inspections) | Automated drone-based depot inspections |
| **DriverAssist UI** | Yes (Glanceable route view & audio cues) | Direct steering-wheel hardware buttons |
| **Trust Ledger Smart Contract** | Yes (Deployed on Sepolia testnet) | Mainnet gas token economics / staking |
| **Multilingual AI Assistance** | Yes (Google Gemini 2.5 Flash SDK) | Proprietary offline LLM running on device |

---

## 7. Hackathon Success Criteria

1. **Working End-to-End Handshake Flow:** A passenger requests assistance on Route 502; the driver console alerts the driver before reaching the stop; the driver acknowledges; the event logs to the operator console.
2. **Crowding-Aware Route Planning:** Commuter queries a route between two Delhi stops (e.g., Kashmere Gate to AIIMS) and receives route options with clear crowding forecasts (Low, Medium, High).
3. **Verifiable Trust Ledger:** Inspection certification hash verified against Ethereum Sepolia testnet contract.
4. **Accessible Design:** Verified keyboard navigation, screen-reader semantic landmarks, and WCAG 2.2 AA contrast ratios.

