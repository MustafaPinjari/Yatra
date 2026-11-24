# YATRA — Hackathon Technical Evaluator Scorecard

**Document ID:** AUDIT-DOC-06  
**Evaluation Perspective:** Senior Hackathon Jury, Lead Transport Scientist & Systems Architect  
**Scoring Model:** 15 Objective Technical Dimensions (0 to 10 each, Max Score = 150)  
**Event:** Delhi Transport Stack Hackathon 2026  

---

## 1. Dimension-by-Dimension Scorecard

| # | Evaluation Dimension | Score (0-10) | Code / Data Evidence | Justification & Gaps to Reach 10/10 |
| :-: | :--- | :-: | :--- | :--- |
| **1** | **Problem Understanding** | **9 / 10** | `docs/product/PRODUCT_REQUIREMENTS.md`, `README.md` | Deep, nuanced understanding of Delhi transit challenges, bus bunching, conductor ticketing constraints, and commuter accessibility barriers. |
| **2** | **Coverage of All 5 Problems** | **2 / 10** | `apps/`, `services/`, `data/` | Problem 1 & 2 have UI mockups only (5% each). Problem 3 & 5 have static text cards (2-3%). Problem 4 is 0% implemented. |
| **3** | **Data Quality & Availability** | **1 / 10** | `data/sample/` (2 files, 2.5 KB total) | Zero real Delhi GPS traces, ETM ticket logs, GTFS feeds, or metro gate datasets exist in the repository. |
| **4** | **Mathematical Correctness** | **3 / 10** | `docs/research/DELHI_DATA_STRATEGY.md` | Theoretical formulas in docs are sound, but the ETM expansion assumption ($Occupancy = B - A$ with scalar multiplier) is mathematically flawed. Zero algorithmic code written. |
| **5** | **Predictive Modelling Quality** | **1 / 10** | `services/crowding-engine/` (empty) | No machine learning models, loss functions, validation splits, or baseline comparisons exist. |
| **6** | **GIS & Route Intelligence** | **2 / 10** | `data/sample/sample_stops.json` | Coordinates exist for 5 stops, but no routing graph, no map matching, and no spatial PostGIS queries are implemented. |
| **7** | **Optimization Quality** | **0 / 10** | None | 0 lines of optimization code for Problem 4 (feeder routes, fleet allocation, 7 km route constraints). |
| **8** | **Backend Architecture** | **3 / 10** | `services/api/app/main.py` | FastAPI app runs with clean error handling, but domain models, database tables, and transit routes are missing. |
| **9** | **Frontend Usability & Craft** | **8 / 10** | `apps/passenger-mobile`, `apps/operator-web` | Beautiful, high-contrast, accessible editorial UI. Unslop writing guidelines followed. The strongest area of the current repo. |
| **10**| **Integration Between Modules** | **2 / 10** | `packages/api-client` | Interfaces match on paper, but client apps are not connected to backend services. Workflows A, B, C, D are broken. |
| **11**| **Validation & Measurable Results** | **1 / 10** | `services/api/app/tests/test_health.py` | Only 3 health-check unit tests and 3 widget tests exist. No model evaluation metrics (MAE, RMSE, MAPE) exist. |
| **12**| **Innovation & Differentiation** | **8 / 10** | Boarding Handshake, AccessGraph, Trust Ledger | Combining universal accessibility with operational telemetry and verifiable smart contract audits is highly innovative. |
| **13**| **Practical Transport Usefulness** | **7 / 10** | Accessibility focus, driver console | Solves real pain points for passengers with disabilities and bus dispatchers if backed by real data. |
| **14**| **Demonstration Readiness** | **3 / 10** | Running servers on ports 3000, 8000, 8080 | Visually demonstrable, but fails technical scrutiny once interactive queries or data drill-downs are requested. |
| **15**| **Reproducibility & Engineering** | **6 / 10** | `Makefile`, `docker-compose.yml`, `pytest` | Monorepo structure, formatting, linting, and automated test runners work reliably. |

---

## 2. Overall Score & Category

```
┌────────────────────────────────────────────────────────┐
│ TOTAL RAW EVALUATION SCORE:                 47 / 150   │
│ NORMALIZED SCORE:                           31.3%      │
│ CODE-EXECUTABLE TRANSIT SCORE:              18.0 / 100 │
│                                                        │
│ JURY CLASSIFICATION:               EARLY PROTOTYPE     │
└────────────────────────────────────────────────────────┘
```

---

## 3. The Seven Critical Jury Questions Answered

### 1. What would cause the jury to reject our solution?
Exposing hardcoded sample data during a live technical defense. If an evaluator asks to plan a journey from *Rohini* to *Saket* and the app only shows *Kashmere Gate to Mehrauli*, or asks to inspect the LightGBM weights for crowding and finds an empty `services/crowding-engine/` directory.

### 2. Which claims would be challenged immediately?
- *"Live GPS telemetry synced 2 seconds ago."*
- *"4.2 Million daily ridership analyzed across 420 stops."*
- *"Seats available: 12 (Low Crowding)."*

### 3. Which calculations are the weakest?
The bus occupancy estimation. Claiming vehicle-level passenger occupancy based on a 3–4% conductor ETM ticketing sample without modeling daily pass holders, free travel, or headway bunching.

### 4. Which modules are only superficial?
All five hackathon intelligence engines (`crowding-engine`, `accessibility-engine`, `handshake-engine`, `intelligence-engine`, `notification-service`).

### 5. What differentiates YATRA from a basic transport dashboard?
1. The **AccessHandshake** protocol (direct passenger-to-driver boarding communication).
2. The **AccessGraph** accessibility scoring framework.
3. The **Trust Ledger** cryptographic audit trail for maintenance verifiability.
4. Editorial-grade, distraction-free visual design.

### 6. What would make the solution genuinely valuable to Delhi transport authorities?
1. Verifiable headway reliability and bus bunching indexes across key corridors (e.g. Outer Ring Road).
2. Data-driven feeder bus route generation that connects underserved colonies to DMRC stations within the 7 km cap and 500 EV bus constraint.
3. Quantifiable boarding assistance fulfillment tracking anchored to cryptographic audit trails.

### 7. What are the five strongest demonstrations we can show?
1. **Interactive Multimodal Journey Planner:** Selecting origin/destination and comparing travel-time vs. crowding tradeoffs.
2. **Real-Time Boarding Handshake:** Passenger app sending an assistance signal $\to$ Driver console immediately receiving high-contrast alert $\to$ Driver acknowledging.
3. **Corridor Crowding & Headway Heatmap:** Demonstrating where bus bunching causes crowding spikes along Route 502.
4. **Feeder Route Optimization Map:** Displaying generated candidate feeder routes around Kashmere Gate or AIIMS within 7 km.
5. **Trust Ledger Blockchain Attestation:** Resolving a maintenance ticket and verifying the transaction hash on Ethereum Sepolia.
