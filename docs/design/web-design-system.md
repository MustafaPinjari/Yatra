# YATRA — Web Operations & Intelligence Design System

**Document Version:** 1.0.0  
**Target Package:** `apps/operator-web/`  
**Framework:** Next.js 15 (App Router), React 19, TypeScript, Tailwind CSS v4, Lucide Icons  
**Status:** Canonical Implementation Reference  

---

## 1. Architectural Mandate

The Next.js web application is built strictly for **desktop and tablet operational workflows**. It serves depot superintendents, transit dispatchers, accessibility compliance officers, and transport department officials.

> [!IMPORTANT]
> The passenger mobile interface is built natively in Flutter (`apps/passenger-mobile/`). The web portal must never render mobile phone frames, mobile screen simulators, or mobile preview iframes in production. All web views are designed for wide, multi-column desktop workflows.

---

## 2. Desktop Portals & Workflows

### 2.1 Operator Command Centre (`/` or `/operator`)
- **Theme:** High-contrast Dark Navy canvas (`#0B132B` / `#101B3A`) optimized for 24/7 control room viewing.
- **Components:**
  - **KPI Status Ribbon:** Active fleet count, low-floor accessibility ratio, open boarding requests, on-time headway percentage.
  - **Live Dispatch Map Canvas:** Interactive cartographic view of bus routes, GPS vehicle markers, accessibility status pins.
  - **Real-Time Boarding Assistance Queue:** Incoming handshake signals from passengers at stops, remaining time to arrival, designated boarding bay.
  - **Incident Triage Panel:** Gemini AI-assisted operational incident summarization and one-click dispatch actions.

### 2.2 Boarding Assistance Dispatcher Queue (`/assistance`)
- **Workflow:** High-throughput triage interface for transit accessibility officers.
- **Features:**
  - Passenger boarding signal status (Pending, Acknowledged by Driver, Ramp Deployed, Completed).
  - Passenger requirement tags (`WHEELCHAIR_RAMP`, `AUDIO_ASSIST`, `EXTRA_BOARDING_TIME`).
  - Vehicle telemetry: Bus number, conductor ID, route code, GPS distance to stop.
  - Audio and visual notification on incoming boarding requests.

### 2.3 Accessibility & Fleet Issue Management (`/incidents`)
- **Workflow:** Depot maintenance tracking and public infrastructure accessibility repair logs.
- **Features:**
  - Work order ticket table (Ramp hydraulic faults, kneeling suspension alarms, tactile paving damage).
  - Severity classification (Critical / Major / Minor) with SLA countdown timer.
  - Verification audit trail with depot mechanic sign-off.

### 2.4 Government Intelligence & Compliance Portal (`/government`)
- **Theme:** Editorial Warm Ivory (`#F7F2E9`) canvas matching YATRA's civic brand identity.
- **Components:**
  - **Delhi Civic Masthead:** India Gate architectural engraving and official NCT Delhi transit badge.
  - **Accessibility Compliance Metrics:** Percentage of stops with wheelchair ramps, accessible boarding completion rate, concession trip count.
  - **Crowd Intelligence Heatmap:** Peak-hour passenger crowding by corridor (Ring Road, Outer Ring Road, BRT).
  - **Trust Ledger Attestation Badge:** Cryptographic hash of inspection records anchored to Ethereum Sepolia testnet.

---

## 3. Web Design Tokens

```css
@theme {
  --color-parchment: #F7F2E9;
  --color-cream: #FFFCF7;
  --color-ink-primary: #101B3A;
  --color-ink-navy: #172653;
  --color-ink-darkest: #0B132B;
  --color-terracotta: #E96835;
  --color-accent-orange: #F07835;
  --color-heritage-green: #16764C;
  --color-pale-green: #E4F1E5;
  --color-soft-border: #E6DDD0;
  
  --font-serif: 'Playfair Display', Georgia, Cambria, serif;
  --font-sans: 'Inter', system-ui, -apple-system, sans-serif;
}
```

---

## 4. Desktop Navigation Structure

```
[Sidebar Navigation]
├── Operator Command Center (/)
├── Assistance Dispatch Queue (/assistance)
├── Fleet & Accessibility Incidents (/incidents)
└── Government Intelligence Portal (/government)
```

Each page utilizes high-density data tables, accessible modal dialogues, and responsive desktop grid layouts (12-column layout on `>= 1280px`).

