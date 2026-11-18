# YATRA — Brand Guidelines & Design Foundations

**Version:** 1.0.0  
**Status:** Approved Reference  
**Product:** YATRA (Your Accessible Transport & Reliable Assistance Platform)  
**Tagline:** *Every Passenger. Every Bus. Every Journey.*

---

## 1. Product Identity & Purpose

YATRA is Delhi's universal public bus service accessibility and operations platform. It unifies five key transit stakeholders into a synchronized digital mobility ecosystem:

1. **Daily Commuters & Passengers:** Seeking dependable, crowdedness-aware multimodal trip planning.
2. **Passengers with Disabilities & Reduced Mobility:** Requiring accessible stop information, tactile route planning, and real-time boarding assistance.
3. **Bus Drivers & In-Cabin Crew:** Receiving advance boarding signals via AccessHandshake to deploy ramps and allocate boarding time safely.
4. **Depot Operators & Dispatchers:** Managing fleet headway, accessibility incident triage, and service reliability through Operator Command.
5. **Government & Transport Authorities:** Monitoring systemic transit equity, concession utilization, and cryptographically verified service records on the Trust Ledger.

---

## 2. Core Art Direction: The Living Atlas

Unlike conventional transit apps that default to clinical blues or generic SaaS grays, YATRA is styled as a **Living Editorial Atlas**. Its visual language honors the architectural majesty of New Delhi—the sandstone monuments of Lutyens' Delhi, historic Mughal arches, and the familiar DTC emerald-green bus fleet—reimagined as a modern, human-centric transit interface.

### Key Visual Pillars
- **Warm Parchment Atmosphere:** Screens sit on warm ivory (`#F7F2E9`) and crisp surface cream (`#FFFCF7`), creating a soft, welcoming, non-fatiguing reading experience.
- **Editorial Typography:** Display headlines and key numerical data are rendered in classical, high-contrast serif (`Playfair Display` or system serif), establishing authority and elegance. Operational data and controls use clean, geometric sans-serif (`Inter`).
- **Restrained Chromatic Hierarchy:** Deep ink navy (`#101B3A`) provides crisp structural legibility, accented by warm terracotta (`#E96835`), vivid orange (`#F07835`), and DTC transit emerald (`#16764C`).
- **Empathetic Dignity in Accessibility:** Illustrations and interface metaphors emphasize passenger independence and human cooperation rather than medicalized vulnerability.

---

## 3. Color Tokens

### 3.1 Primary & Background Palette
| Token Name | Hex Code | Purpose / Usage | WCAG AA Contrast on Ivory |
| :--- | :--- | :--- | :--- |
| `parchment-bg` | `#F7F2E9` | Primary screen and application background | N/A (Base) |
| `surface-cream` | `#FFFCF7` | Card surfaces, modals, elevated sheets | N/A (Surface) |
| `ink-primary` | `#101B3A` | Headlines, primary text, prominent borders | 14.8:1 (AAA) |
| `navy-deep` | `#172653` | Navigation bars, primary CTAs, active tab indicators | 12.5:1 (AAA) |
| `navy-darkest` | `#0B132B` | Desktop Operator Command Center dark canvas | N/A (Dark canvas) |
| `terracotta` | `#E96835` | Primary action highlights, assistance alert buttons | 3.4:1 (Accents/Graphics) |
| `accent-orange` | `#F07835` | Boarding badges, route markers, high-priority notifications | 3.1:1 (Badges/Pills) |
| `heritage-green`| `#16764C` | Accessible route indicators, live status beacons, DTC green | 5.2:1 (AA compliant) |
| `pale-green` | `#E4F1E5` | Low crowding indicators, verified badge backgrounds | N/A (Fill) |
| `soft-border` | `#E6DDD0` | Card borders, dividing rules, timeline connectors | N/A (Subtle rule) |

### 3.2 Semantic State Colors
- **Success / High Accessibility:** `#16764C` (Emerald), background `#E4F1E5`
- **Warning / Medium Crowding:** `#D97706` (Amber), background `#FEF3C7`
- **Critical / Heavy Crowding / Fault:** `#DC2626` (Crimson), background `#FEE2E2`
- **Informational / Handshake Pending:** `#2563EB` (Cobalt), background `#EFF6FF`

---

## 4. Typography Hierarchy

### 4.1 Display Typeface: Playfair Display / Editorial Serif
Used exclusively for:
- Hero headlines (e.g., "Move Delhi Together", "Journey Planner")
- Large numerical trip durations (e.g., **28 min**, **14 km**)
- Accessibility rating scores and municipal KPI counters
- Brand wordmarks and section titles

```css
font-family: 'Playfair Display', Georgia, Cambria, 'Times New Roman', serif;
font-feature-settings: 'lnum' 1; /* Lining numerals */
```

### 4.2 Interface Typeface: Inter / Geometric Sans
Used for:
- Navigation labels, tab titles, and button CTAs
- Form inputs, placeholder labels, and route codes (e.g., `502`, `TMS(+)`)
- Stop sequence timelines and schedule arrival times
- Accessibility metadata tags (e.g., `RAMP EQUIPPED`, `TACTILE PAVING`)

```css
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
```

---

## 5. Brand Glyph & Wordmark

### 5.1 The YATRA Glyph
The official YATRA logo integrates two resonant symbols:
1. An **architectural arched gateway** inspired by India Gate and classic Indian civic gateways.
2. An **interlocking wheel & transit track** representing continuous, accessible urban movement across Delhi.

### 5.2 Wordmark Treatment
- Wordmark is always typeset in uppercase serif (`YATRA`).
- Tracking: `+0.12em` letter spacing for an architectural, balanced inscription feel.
- Subtitle: `Accessible · Inclusive · Reliable` in uppercase sans-serif at 10pt with `+0.15em` tracking.

---

## 6. Accessibility & Inclusivity Rules

1. **Touch Target Size:** All touchable interactive elements must meet or exceed `48 × 48 dp` (WCAG 2.2 Success Criterion 2.5.8).
2. **Color Contrast:** Text and critical UI controls must satisfy at least WCAG Level AA (`4.5:1` for normal text, `3:1` for large text). Text in `#101B3A` against `#F7F2E9` achieves `14.8:1` (exceeding AAA).
3. **Screen Reader Semantics:** Every interactive button, selector, card, and map marker must carry descriptive `Semantics` in Flutter and `aria-label` / semantic HTML tags in Next.js.
4. **Haptic & Visual Redundancy:** Operational alerts (such as boarding handshake confirmation) must never rely on color alone; always pair color with text badges, high-contrast icons, and auditory/haptic cues.

