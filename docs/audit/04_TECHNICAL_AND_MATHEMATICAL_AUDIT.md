# YATRA — Technical & Mathematical Correctness Audit

**Document ID:** AUDIT-DOC-04  
**Domain:** Statistical Rigor, Algorithmic Feasibility, Machine Learning & Mathematical Modeling  
**Evaluator:** Principal Transport Data Scientist & ML Engineer  
**Audit Scope:** Problems 1 through 5  

---

## 1. Problem 1: Real-Time Bus Traffic Model & Journey Planner

### 1.1 Claimed Mathematical Model
The system claims to ingest 10-second historical bus GPS traces, perform map matching, detect dwell times, predict dynamic segment travel times, and provide optimal transit routing.

### 1.2 Reality & Mathematical Flaws Found
1. **Zero Map Matching Code:**
   - GPS in Delhi exhibits high spatial noise in urban canyons (e.g., flyovers, Connaught Place, Old Delhi).
   - *Requirement:* A Hidden Markov Model (HMM) using emission probabilities based on distance to road segments:
     $$p(z_t | x_t) = \frac{1}{\sqrt{2\pi}\sigma_z} \exp\left(-\frac{\text{dist}(z_t, x_t)^2}{2\sigma_z^2}\right)$$
     and transition probabilities based on routing network distance vs. Euclidean distance:
     $$p(x_t | x_{t-1}) = \frac{1}{\beta} \exp\left(-\frac{|\Delta d_{net} - \Delta d_{euc}|}{\beta}\right)$$
   - *Current Code:* **Completely missing.** No HMM, no KD-Tree, no Shapely snapping exists.
2. **Absence of Dwell Time vs. Traffic Delay Disaggregation:**
   - Total segment delay consists of:
     $$T_{segment} = T_{free\_flow} + T_{traffic\_congestion} + \sum_{s \in Stops} D_{dwell}(s)$$
   - Dwell time $D_{dwell}$ is a function of passenger boarding/alighting volume and bus kneeling/ramp deployment.
   - *Current Code:* Travel time in the Flutter app is hardcoded to a fixed constant (42 minutes for Route 502).

---

## 2. Problem 2: Crowdedness-Aware Journey Planner

### 2.1 The Critical ETM Expansion Problem
The Delhi bus Electronic Ticketing Machine (ETM) dataset represents **only ~3% to 4% of total daily bus passengers** because:
- Daily and monthly bus pass holders do not scan their passes on conductor ETMs.
- Women traveling on free "Pink Tickets" are often issued batched or manual slips.
- Cash transactions during high crowding are frequently skipped or logged late.

### 2.2 Mathematical Violation in Current Architecture
- The existing design documentation states:
  $$\text{Occupancy}(t) = \sum \text{Boardings}(t) - \sum \text{Alightings}(t)$$
  and multiplies ticket counts by an arbitrary constant to calculate seats available.
- **Why this fails:**
  - Multiplying observed ETM counts by a scalar $\alpha = \frac{1}{0.04} = 25$ amplifies Poisson variance by $25\times$.
  - In periods of severe crowding, conductor movement is physically blocked, causing ticket issuance to drop to zero precisely when the bus is 100% full. A naive ticket count treats the bus as empty.
- **Required Scientific Formulation:**
  A calibrated **Relative Crowding Index (RCI)** bounded between 0 and 1, combining:
  1. Base historical demand profile from GTFS-schedule capacity.
  2. ETM ticketing rate normalized against corridor baseline.
  3. Headway deviation (bunching factor):
     $$\Delta H = \frac{H_{observed} - H_{scheduled}}{H_{scheduled}}$$
     When $\Delta H \gg 0$, passenger accumulation at downstream stops increases linearly with headway delay.

---

## 3. Problem 3: Public-Transit Origin–Destination (OD) Matrix

### 3.1 Matrix Construction Challenge
ETM records capture only the boarding stage (where the ticket was bought), rarely the alighting stop. Metro gate data captures entry/exit station marginal totals ($O_i$ and $D_j$), not individual trajectory pairs $(i, j)$.

### 3.2 Evaluation of Current Implementation
- *Current Code:* No OD matrix construction exists. `GovtIntelligenceView.tsx` shows static text cards.
- *Required Mathematical Formulation:*
  **Iterative Proportional Fitting (IPF) / Biproportional Scaling (Furness Algorithm):**
  $$T_{ij}^{(k+1)} = T_{ij}^{(k)} \cdot \frac{O_i}{\sum_j T_{ij}^{(k)}} \cdot \frac{D_j}{\sum_i T_{ij}^{(k)}}$$
  calibrated against an impedance friction function $f(c_{ij}) = \exp(-\gamma c_{ij})$ based on travel time between zones.

---

## 4. Problem 4: Feeder Bus Route & Fleet Optimization

### 4.1 Strict Constraints Mandated
- Target: Metro station feeder connectivity.
- Constraint 1: Maximum route length $\le 7\text{ km}$.
- Constraint 2: Road width eligibility filtering ($> 6\text{ m}$ carriageway).
- Constraint 3: Fixed planning fleet constraint: approximately **500 Electric Buses**.
- Objective: Maximize population / employment coverage in underserved transit deserts.

### 4.2 Evaluation of Current Implementation
- *Current Code:* **0% implementation.** Neither road network graph, width filters, nor optimization solver exists.
- *Required Formulation:*
  **Mixed-Integer Linear Program (MILP) or Column Generation with CP-SAT:**
  $$\max \sum_{r \in \mathcal{R}} \sum_{p \in \mathcal{P}} w_p \cdot y_{pr} - \sum_{r \in \mathcal{R}} c_r \cdot x_r$$
  subject to:
  $$\text{Length}(r) \le 7.0\text{ km} \quad \forall r \in \mathcal{R}$$
  $$\text{Width}(e) \ge 6.0\text{ m} \quad \forall e \in \text{Edges}(r)$$
  $$\sum_{r \in \mathcal{R}} \left\lceil \frac{2 \cdot \text{RoundTrip}(r)}{H_r} \right\rceil \le 500 \quad (\text{Fleet constraint})$$

---

## 5. Problem 5: Metro & Bus Segment-Level Crowding

### 5.1 Conservation of Passenger Flow
For any stop sequence $s_1, s_2, \dots, s_n$ along a directional route:
$$L_{s_i \to s_{i+1}} = L_{s_{i-1} \to s_i} + B(s_i) - A(s_i)$$
Boundary conditions:
$$L_{s_0 \to s_1} = 0, \quad L_{s_n \to s_{n+1}} = 0$$
$$\sum_{i=1}^n B(s_i) = \sum_{i=1}^n A(s_i)$$

### 5.2 Evaluation of Current Implementation
- *Current Code:* Static table displaying hardcoded passenger loads (e.g. `Route 502: 84% load`).
- *Missing Logic:* No alighting probability distribution or trip-chaining inference implemented.
