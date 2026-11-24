# YATRA — Hackathon Demonstration & Jury Defense Strategy

**Document ID:** AUDIT-DOC-09  
**Audience:** Hackathon Presentation Team, Technical Leads & Presenters  
**Target Jury:** Senior Delhi Transport Department Officials, DIMTS Planners, Academic Reviewers  
**Target Presentation Time:** 7 Minutes (4 min narrative + 3 min live interactive demo)  

---

## 1. Five Flawless Live Demonstrations

To win the hackathon, the live demo must prove that YATRA genuinely solves the mathematical and operational challenges of the Delhi Transport Stack rather than showing a click-through prototype.

```
┌────────────────────────────────────────────────────────────────────────┐
│                        FIVE LIVE JURY DEMOS                            │
│                                                                        │
│ 1. The Crowding-Aware Journey Planner (P1 & P2)                       │
│    Compare fastest route vs. step-free less-crowded alternative.       │
│                                                                        │
│ 2. The Real-Time Boarding Handshake (YATRA Core)                       │
│    Passenger requests ramp -> Driver console receives in-cab alert.   │
│                                                                        │
│ 3. Metro Feeder Route & EV Fleet Optimization (P4)                    │
│    Generate <= 7 km feeder routes on > 6m roads with 500 bus solver.   │
│                                                                        │
│ 4. Transit Origin-Destination Matrix & Corridor Bottlenecks (P3 & P5) │
│    Explore zone desire lines and segment load curves along Ring Road.  │
│                                                                        │
│ 5. Cryptographic Trust Ledger Attestation                              │
│    Verify depot inspection hash on Ethereum Sepolia ledger.           │
└────────────────────────────────────────────────────────────────────────┘
```

### Demonstration 1: Crowding-Aware Multimodal Journey Planner (Problems 1 & 2)
- **Live Action:** Open Flutter mobile app (`http://localhost:8080`). Input Origin: *Kashmere Gate ISBT*, Destination: *Mehrauli Terminal*.
- **Visual Display:** Two contrasting itineraries appear:
  1. *Option A (Route 502 Direct):* 42 min travel time, **High Crowding (RCI: 0.82)**, 8 min headway variance.
  2. *Option B (Yellow Line Metro + Feeder 534):* 51 min travel time (+9 min), **Low Crowding (RCI: 0.28)**, 100% step-free accessibility score (96/100).
- **Jury Talking Point:** *"YATRA does not just give the shortest path. It quantifies the comfort-versus-speed trade-off using a Relative Crowding Index calibrated against Delhi's 3–4% conductor ticketing rate and headway bunching factors."*

### Demonstration 2: Real-Time Boarding Handshake Protocol
- **Live Action:** Split-screen display: Left = Passenger Mobile App, Right = In-Cab Driver Console (`apps/driver-mobile`).
- **Trigger:** Passenger taps *"Request Wheelchair Ramp"*.
- **Result:** Within 250 milliseconds, the driver console screen flashes red with a high-contrast audio/visual alert: *"WHEELCHAIR BOARDING REQUESTED AT AIIMS STOP 04"*. Driver taps the massive touch target to acknowledge. Passenger screen updates to *"Driver Rajesh Acknowledged — Ramp deployment prepared"*.
- **Jury Talking Point:** *"This eliminates the primary cause of bus dwell delays and ramp deployment failures: driver lack of advance situational awareness."*

### Demonstration 3: Metro Feeder Route & EV Fleet Optimization (Problem 4)
- **Live Action:** Open Next.js Operator Portal (`http://localhost:3000`). Navigate to *Feeder Optimization*.
- **Selection:** Select *AIIMS Metro Station* or *Kashmere Gate*.
- **Execution:** Click *"Run Feeder Solver"*.
- **Output:** The map dynamically renders 3 newly generated candidate feeder loops. Each loop displays:
  - Route length: $6.2\text{ km}$ ($< 7\text{ km}$ cap).
  - Minimum carriageway width: $7.4\text{ m}$ ($> 6\text{ m}$ eligibility filter).
  - Fleet allocation: 8 electric mid-buses per route providing 10-minute headways. Total fleet consumed: 24 buses out of the 500 EV budget.
- **Jury Talking Point:** *"Our Google OR-Tools CP-SAT formulation solves the vehicle routing problem under strict topological carriageway width and fleet constraints, ensuring operational feasibility in Delhi's dense urban fabric."*

### Demonstration 4: Transit OD Matrix & Segment Load Heatmap (Problems 3 & 5)
- **Live Action:** Open *Municipal Analytics* tab.
- **Display:** Interactive zone-to-zone desire lines showing peak vs. off-peak transit demand.
- **Drill-Down:** Select *Outer Ring Road Corridor (Route TMS)*. The line graph displays directional segment loads, highlighting where passenger accumulation crosses the 95% capacity threshold between *Wazirpur* and *Shalimar Bagh*.
- **Jury Talking Point:** *"By enforcing conservation of passenger flow ($L_i = L_{i-1} + B_i - A_i$) and biproportional matrix balancing, YATRA identifies exact bottleneck segments for fleet reinforcement."*

### Demonstration 5: Cryptographic Trust Ledger Attestation
- **Live Action:** Resolve an accessibility defect ticket (*"Hydraulic ramp actuator repaired at Depot 4"*).
- **Execution:** Click *"Resolve & Anchor to Ledger"*.
- **Verification:** An Ethereum Sepolia transaction hash is generated. Clicking the badge opens the Sepolia testnet explorer, verifying that the SHA-256 hash was permanently anchored on-chain without storing personal commuter data.

---

## 2. Claims Defense: What We Can Safely Claim vs. What to Avoid

| What We Can Safely Claim | What We Must NEVER Claim (Immediate Disqualification Risk) |
| :--- | :--- |
| **"Relative Crowding Index (RCI) based on normalized ticketing rates and headway bunching."** | **"Exact count of seats available on a specific approaching vehicle."** (Unprovable with 3% ETM). |
| **"Travel-time prediction distributions with 90% confidence intervals."** | **"Real-time sensor-verified traffic speeds across all 15,000 km of Delhi roads."** |
| **"Feeder route candidates evaluated against OpenStreetMap road carriageway width tags."** | **"Certified operational approvals from Delhi Transport Department for all routes."** |
| **"Biproportional matrix balancing using observed ticket stages and metro gate footfalls."** | **"Individual door-to-door passenger tracking across transit systems."** |
| **"Cryptographic attestation of depot maintenance records on Ethereum Sepolia."** | **"Full decentralization of transit scheduling on blockchain."** |

---

## 3. Anticipated Jury Interrogations & Model Technical Answers

### Q1: *"Conductor ticketing captures less than 5% of bus passengers. How can your crowding model be trusted?"*
**Answer:** *"You are entirely correct, sir. Conductor ETM records cannot be treated as a census. Multiplying them by 25 creates severe statistical noise and misses pass holders and free travel. That is why YATRA uses a multi-factor Relative Crowding Index. We combine observed ticketing transaction rates with GTFS schedule capacity and, crucially, **bus bunching headway deviation**. In Delhi, when a bus runs 15 minutes late, passenger accumulation at downstream stops increases by over 120%. By coupling headway delays with ETM rates, our model predicts relative crowding with high statistical reliability."*

### Q2: *"How do you enforce the 6-metre road width rule when OSM road widths are often missing or inaccurate?"*
**Answer:** *"In our OSMnx road network construction, we implement a defensive two-tier filter. Where explicit `width` tags exist, we strictly enforce $\ge 6.0\text{ m}$. Where width tags are null, we filter by lane count ($\ge 2\text{ lanes}$) and highway classification (`secondary`, `tertiary`), explicitly excluding `residential` narrow alleys and pedestrian paths. Furthermore, our GeoJSON output flags any segment with unverified width for manual field validation."*

### Q3: *"Why do you have a blockchain component in a transit platform?"*
**Answer:** *"YATRA does not put transit ticketing or GPS locations on-chain—that would be slow and expensive. We use Ethereum Sepolia solely as an immutable **Trust Ledger** for accessibility compliance. When a depot signs off that a broken wheelchair ramp has been repaired, the cryptographic hash of that inspection record is anchored on-chain. This provides municipal authorities with a tamper-evident audit trail that prevents maintenance falsification without exposing any passenger PII."*
