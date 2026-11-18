# YATRA — Visual Asset & Image Generation Inventory

**Document Version:** 1.0.0  
**Design System:** Editorial Warm Ivory / Delhi Transit Heritage  
**Status:** Ready for Studio Art Production  
**Lead Designer & Architect:** Senior Design Technologist & Visual Lead  

---

## 1. Overview & Art Direction Guidelines

The YATRA visual identity blends **modern civic digital infrastructure** with **timeless Indian architectural heritage**. Unlike generic blue-and-purple SaaS applications, YATRA’s aesthetic is inspired by premium editorial cartography, New Delhi’s monumental stone architecture (India Gate, Rashtrapati Bhavan, Mughal arched gateways), and the recognizable DTC emerald-green bus livery.

### Visual Principles:
- **Warm Parchment Atmosphere:** Backgrounds utilize warm ivory (`#F7F2E9`) and crisp surface cream (`#FFFCF7`) instead of clinical cool grey or pure `#FFFFFF`.
- **Editorial Typography:** Display headlines set in classical high-contrast serif (Playfair Display / Georgia), paired with razor-sharp geometric sans-serif (Inter) for data and operational indicators.
- **Restrained Chromatic Hierarchy:** Deep ink navy (`#101B3A` / `#172653`) forms the primary structure, accented by terracotta orange (`#E96835` / `#F07835`) and heritage emerald green (`#16764C`).
- **Human-Centric Empathy:** Accessibility illustrations depict dignity, smooth physical boarding, and cooperation between passengers and transit workers—avoiding clinical medical tropes.

---

## 2. Complete Asset Inventory

---

### Asset ID: YATRA-ILL-001
- **Filename:** `india-gate-hero.webp`
- **Screen & Component:** Passenger Introduction Screen (`IntroScreen.tsx`) & Government Intelligence Portal (`GovtIntelligenceView.tsx`)
- **Purpose:** Primary civic architectural centerpiece establishing Delhi context with transit movement.
- **Detailed Visual Description:** A majestic, architectural rendering of India Gate (All India War Memorial) under a warm dusk sky. Organic terracotta-tinted sun arches rise behind the monument, framed by delicate tropical Neem and Jamun foliage. In the immediate foreground, a modern low-floor DTC Delhi municipal bus in two-tone green and white cruises gracefully on Rajpath, demonstrating accessible urban transit in harmony with national heritage.
- **Subject & Composition:** India Gate centered in the upper two-thirds; bus moving from left-to-right in lower third; balanced negative space on left and right for headline typography.
- **Perspective / Angle:** Low eye-level frontal architectural perspective, conveying grandeur and municipal reliability.
- **Background:** Seamless warm ivory and soft amber gradient (`#F7F2E9` to `#FCECDD`), zero text or UI overlays.
- **Colour Palette:** Sandstone beige (`#E5C39E`), Deep navy ink (`#101B3A`), Terracotta orange (`#E96835`), Foliage emerald (`#16764C`), Warm parchment (`#F7F2E9`).
- **Lighting & Style:** Contemporary editorial vector/gouache with fine architectural ink outlines, soft textured risograph shading, and painterly light washes.
- **Aspect Ratio:** 4:5 (Mobile) / 16:9 (Desktop banner adaptation).
- **Recommended Resolution:** 1600 × 2000 px (300 DPI source).
- **Transparent Background:** Optional (seamless blending with `#F7F2E9` preferred).
- **Target Platform:** Both Mobile and Desktop.
- **Asset Set:** Part of the Delhi Civic Monument Series.
- **Priority:** **CRITICAL**.
- **Placeholder Component Location:** `<AssetPlaceholder assetId="YATRA-ILL-001" />` in `apps/operator-web/src/components/design/IntroScreen.tsx` and `GovtIntelligenceView.tsx`.

---

### Asset ID: YATRA-ILL-002
- **Filename:** `delhi-bus-isometric.webp`
- **Screen & Component:** Passenger Home (`PassengerHomeScreen.tsx`) & Nearest Bus Card
- **Purpose:** Demonstrates modern, low-floor accessible fleet capability to commuters.
- **Detailed Visual Description:** Three-quarter perspective of an ultra-modern Delhi electric low-floor AC bus. The bus displays route LED sign "502 KASHMERE GATE", open front and middle double doors with an extended neon-yellow edged wheelchair ramp flush with an elevated curb. Clear glass windows reveal accessible wheelchair priority seating and interior grab poles.
- **Subject & Composition:** Bus oriented at 30-degree isometric angle, highlighting low-floor entry and hydraulic kneeling suspension.
- **Perspective / Angle:** 3/4 isometric perspective.
- **Background:** Transparent background with subtle soft drop shadow.
- **Colour Palette:** DTC transit green (`#16764C`), Crisp white (`#FFFFFF`), Safety yellow (`#FACC15`), Deep ink navy (`#101B3A`), Chrome silver (`#CBD5E1`).
- **Lighting & Style:** Crisp vector-editorial product illustration, clean geometric linework with subtle metallic reflections.
- **Aspect Ratio:** 16:10.
- **Recommended Resolution:** 1200 × 750 px.
- **Transparent Background:** **YES (PNG/WebP with Alpha)**.
- **Target Platform:** Mobile and Desktop cards.
- **Asset Set:** YATRA Fleet Vehicle Series.
- **Priority:** **CRITICAL**.
- **Placeholder Component Location:** `<AssetPlaceholder assetId="YATRA-ILL-002" />` in `PassengerHomeScreen.tsx` and `JourneyPlannerView.tsx`.

---

### Asset ID: YATRA-ILL-003
- **Filename:** `delhi-skyline-arch.webp`
- **Screen & Component:** Passenger Home Header (`PassengerHomeScreen.tsx`)
- **Purpose:** Subtle cultural atmospheric header celebrating Delhi’s architectural diversity.
- **Detailed Visual Description:** Panoramic architectural silhouette capturing iconic landmarks of Delhi in continuous line: Qutub Minar, Lotus Temple, Red Fort Lahore Gate domes, and Humayun's Tomb, subtly interlaced with Metro viaduct pillars and electric bus overhead lines.
- **Subject & Composition:** Horizontal silhouette band across bottom with expansive ivory sky above for time and city selectors.
- **Perspective / Angle:** Flat architectural elevation profile.
- **Background:** Warm parchment (`#F7F2E9`).
- **Colour Palette:** Monochromatic terracotta tints (`#E96835`, `#FCECDD`, `#D97706`) and slate navy (`#1E293B`).
- **Lighting & Style:** Minimalist architectural silhouette with subtle stipple texture.
- **Aspect Ratio:** 21:9.
- **Recommended Resolution:** 1800 × 600 px.
- **Transparent Background:** YES.
- **Target Platform:** Mobile Header and Desktop Masthead.
- **Asset Set:** Delhi Civic Monument Series.
- **Priority:** High.
- **Placeholder Component Location:** `<AssetPlaceholder assetId="YATRA-ILL-003" />` in `PassengerHomeScreen.tsx`.

---

### Asset ID: YATRA-ILL-004
- **Filename:** `boarding-assistance-empathy.webp`
- **Screen & Component:** Assistance Request Screen (`AssistanceScreen.tsx`)
- **Purpose:** Hero visual conveying dignified, seamless passenger-to-crew boarding cooperation.
- **Detailed Visual Description:** A heartwarming, dignified interaction at a Delhi bus stop shelter. A smiling commuter in an active manual wheelchair is boarding effortlessly across an integrated yellow ramp into a low-floor DTC bus. A female transit conductor in uniform stands beside the door holding the handrail welcoming the passenger, while a gentleman with a white cane approaches guided by bright yellow tactile paving tiles.
- **Subject & Composition:** Balanced three-character narrative scene centered around the bus boarding doorway.
- **Perspective / Angle:** Eye-level side angle with shallow depth of field focusing on the boarding ramp.
- **Background:** Soft warm architectural wash of a Delhi transit shelter with foliage shadows.
- **Colour Palette:** Navy ink (`#101B3A`), Terracotta (`#E96835`), Emerald green (`#16764C`), Soft marigold (`#F59E0B`), Parchment (`#F7F2E9`).
- **Lighting & Style:** Empathetic editorial character illustration, warm golden hour natural ambient lighting, expressive but non-cartoonish human proportions.
- **Aspect Ratio:** 16:9.
- **Recommended Resolution:** 1600 × 900 px.
- **Transparent Background:** No (full-bleed background in card).
- **Target Platform:** Both Mobile and Desktop.
- **Asset Set:** Universal Accessibility Interaction Series.
- **Priority:** **CRITICAL**.
- **Placeholder Component Location:** `<AssetPlaceholder assetId="YATRA-ILL-004" />` in `AssistanceScreen.tsx`.

---

### Asset ID: YATRA-ILL-005
- **Filename:** `wheelchair-ramp-card.webp`
- **Screen & Component:** Assistance Category Selector (`AssistanceScreen.tsx`)
- **Purpose:** Visual iconographic tile for "Wheelchair Ramp Deployment" request option.
- **Detailed Visual Description:** Close-up technical illustration of an electric bus door kneeling mechanism and hydraulic ramp unfolding onto a curbed tactile boarding pad.
- **Subject & Composition:** Tight zoom on low-floor threshold and ramp angle.
- **Perspective / Angle:** Isometric close-up.
- **Background:** Clean ivory container (`#FFFCF7`).
- **Colour Palette:** Navy (`#172653`), Orange (`#F07835`), Pale green (`#E4F1E5`).
- **Lighting & Style:** Clean iconography with editorial risograph depth.
- **Aspect Ratio:** 1:1.
- **Recommended Resolution:** 400 × 400 px.
- **Transparent Background:** YES.
- **Target Platform:** Mobile and Desktop.
- **Asset Set:** Assistance Modality Iconography.
- **Priority:** High.
- **Placeholder Component Location:** `<AssetPlaceholder assetId="YATRA-ILL-005" />` in `AssistanceScreen.tsx`.

---

### Asset ID: YATRA-ILL-006
- **Filename:** `vision-support-card.webp`
- **Screen & Component:** Assistance Category Selector (`AssistanceScreen.tsx`)
- **Purpose:** Visual iconographic tile for "Vision & Audio Support" option.
- **Detailed Visual Description:** Close-up depiction of a commuter with tactile cane stepping onto directional yellow blister paving, with subtle acoustic beacon waves emanating from an overhead bus speaker.
- **Subject & Composition:** Centered figure and acoustic sound wave geometry.
- **Perspective / Angle:** Frontal isometric.
- **Background:** Clean ivory container (`#FFFCF7`).
- **Colour Palette:** Deep navy (`#101B3A`), Amber yellow (`#F59E0B`), Warm ivory (`#F7F2E9`).
- **Lighting & Style:** Modern editorial iconographic illustration.
- **Aspect Ratio:** 1:1.
- **Recommended Resolution:** 400 × 400 px.
- **Transparent Background:** YES.
- **Target Platform:** Mobile and Desktop.
- **Asset Set:** Assistance Modality Iconography.
- **Priority:** High.
- **Placeholder Component Location:** `<AssetPlaceholder assetId="YATRA-ILL-006" />` in `AssistanceScreen.tsx`.

---

### Asset ID: YATRA-ILL-007
- **Filename:** `elderly-mobility-card.webp`
- **Screen & Component:** Assistance Category Selector (`AssistanceScreen.tsx`)
- **Purpose:** Visual iconographic tile for "Elderly & Mobility Support" option.
- **Detailed Visual Description:** Depiction of an elderly commuter with walking stick boarding via low-step entry with driver extending supportive guidance hand.
- **Subject & Composition:** Two hands clasping bus entrance rail with comfortable footing.
- **Perspective / Angle:** Profile close-up.
- **Background:** Clean ivory container (`#FFFCF7`).
- **Colour Palette:** Navy (`#172653`), Emerald green (`#16764C`), Soft beige.
- **Lighting & Style:** Warm, dignified character linework.
- **Aspect Ratio:** 1:1.
- **Recommended Resolution:** 400 × 400 px.
- **Transparent Background:** YES.
- **Target Platform:** Mobile and Desktop.
- **Asset Set:** Assistance Modality Iconography.
- **Priority:** High.
- **Placeholder Component Location:** `<AssetPlaceholder assetId="YATRA-ILL-007" />` in `AssistanceScreen.tsx`.

---

### Asset ID: YATRA-ILL-008
- **Filename:** `accessible-stop-photo.webp`
- **Screen & Component:** Accessible Stop Detail Panel (`AccessibleStopsView.tsx`)
- **Purpose:** Photographic/rendered proof of audited bus stop accessibility infrastructure.
- **Detailed Visual Description:** Realistic architectural rendering of "AIIMS Metro Bus Stop (Bay 2)". Shows stainless-steel curved shelter, illuminated route matrix LED display, tactile guide strips from metro exit to bus curb, continuous 1:12 ramp with twin handrails, and zero curb drop-off.
- **Subject & Composition:** Wide view of bus stop platform showing curb interface and shelter seating.
- **Perspective / Angle:** Eye-level architectural perspective.
- **Background:** Modern Delhi streetscape with landscaped greenery and metro viaduct in background.
- **Colour Palette:** Granite grey (`#64748B`), Transit green (`#16764C`), Warm sunlight amber, Brushed steel.
- **Lighting & Style:** Photorealistic architectural render with crisp morning daylight.
- **Aspect Ratio:** 16:9.
- **Recommended Resolution:** 1200 × 675 px.
- **Transparent Background:** No.
- **Target Platform:** Mobile and Desktop stop detail panels.
- **Asset Set:** AccessGraph Physical Infrastructure Series.
- **Priority:** High.
- **Placeholder Component Location:** `<AssetPlaceholder assetId="YATRA-ILL-008" />` in `AccessibleStopsView.tsx`.

---

### Asset ID: YATRA-ILL-009
- **Filename:** `delhi-dark-map-texture.webp`
- **Screen & Component:** Operator Command Center (`OperatorCommandView.tsx`)
- **Purpose:** Sophisticated dark cartographic background texture representing Delhi transit ring network.
- **Detailed Visual Description:** High-density vector cartography of Delhi NCT in deep slate-blue and charcoal. Major transit arteries (Ring Road, Outer Ring Road, Grand Trunk Road, Mehrauli-Badarpur Road) glow in subtle electric cyan and amber lines. Water bodies (Yamuna River) rendered in dark muted indigo.
- **Subject & Composition:** Bird's eye cartographic view of the National Capital Territory centered on Connaught Place / Ring Road.
- **Perspective / Angle:** 2D Nadir (top-down) map projection.
- **Background:** Dark slate navy (`#0B132B` to `#172653`).
- **Colour Palette:** Midnight navy (`#0B132B`), Arterial cyan (`#38BDF8`), Route amber (`#F59E0B`), Transit green (`#10B981`).
- **Lighting & Style:** High-tech digital transit operations map, glowing neon vector lines with subtle topographic contour textures.
- **Aspect Ratio:** 16:10.
- **Recommended Resolution:** 1920 × 1200 px.
- **Transparent Background:** No.
- **Target Platform:** Desktop Operator Dashboard.
- **Asset Set:** Operator Cartographic Series.
- **Priority:** High.
- **Placeholder Component Location:** `<AssetPlaceholder assetId="YATRA-ILL-009" />` in `OperatorCommandView.tsx`.

---

### Asset ID: YATRA-ILL-010
- **Filename:** `govt-india-gate-engraving.webp`
- **Screen & Component:** Government Intelligence Portal (`GovtIntelligenceView.tsx`)
- **Purpose:** Classical architectural header illustration evoking authority, state planning, and timeless civic pride.
- **Detailed Visual Description:** Fine-line classical architectural engraving of India Gate viewed through a Mughal decorative archway. Fine hatching on stone cornices, delicate botanical border motifs around the arch perimeter, rendered in rich navy ink on cream parchment.
- **Subject & Composition:** Symmetrical frontal view of India Gate framed by ornate heritage stonework arch.
- **Perspective / Angle:** Straight-on architectural elevation.
- **Background:** Warm cream parchment (`#F7F2E9`).
- **Colour Palette:** Monochromatic Deep Navy Ink (`#101B3A`) on Cream (`#F7F2E9`).
- **Lighting & Style:** 19th-century copperplate engraving aesthetic modernized with clean vector precision.
- **Aspect Ratio:** 1:1 or 4:3.
- **Recommended Resolution:** 800 × 600 px.
- **Transparent Background:** YES.
- **Target Platform:** Desktop Government Analytics Header.
- **Asset Set:** Delhi Civic Monument Series.
- **Priority:** High.
- **Placeholder Component Location:** `<AssetPlaceholder assetId="YATRA-ILL-010" />` in `GovtIntelligenceView.tsx`.

---

### Asset ID: YATRA-BRAND-001
- **Filename:** `yatra-brand-symbol.svg`
- **Screen & Component:** Universal Navigation & Brand Logos (`Navbar`, `MobileHeader`)
- **Purpose:** Primary symbol mark of YATRA platform.
- **Detailed Visual Description:** An elegant geometric emblem intertwining an architectural archway, a continuous accessible pathway, and a rolling transit wheel. The upper curve forms the arch of India Gate, seamlessly transitioning into an open mobility loop.
- **Subject & Composition:** Centered compact emblem.
- **Perspective / Angle:** 2D flat geometric.
- **Background:** Transparent.
- **Colour Palette:** Navy (`#172653`) and Terracotta Orange (`#E96835`).
- **Lighting & Style:** Scalable SVG vector icon.
- **Aspect Ratio:** 1:1.
- **Recommended Resolution:** Vector SVG (scalable).
- **Transparent Background:** YES.
- **Target Platform:** All screens.
- **Asset Set:** Brand Identity Core.
- **Priority:** **CRITICAL**.
- **Placeholder Component Location:** `<AssetPlaceholder assetId="YATRA-BRAND-001" />` in `YatraBrandLogo.tsx`.

---

## 3. Inventory Summary Table

| Asset ID | Filename | Screen Location | Format | Aspect Ratio | Priority | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **YATRA-ILL-001** | `india-gate-hero.webp` | Passenger Intro & Govt Portal | WebP | 4:5 | **CRITICAL** | Placeholder Mounted |
| **YATRA-ILL-002** | `delhi-bus-isometric.webp` | Passenger Home & Nearest Bus | WebP/PNG | 16:10 | **CRITICAL** | Placeholder Mounted |
| **YATRA-ILL-003** | `delhi-skyline-arch.webp` | Passenger Home Header | WebP/PNG | 21:9 | High | Placeholder Mounted |
| **YATRA-ILL-004** | `boarding-assistance-empathy.webp` | Assistance Screen | WebP | 16:9 | **CRITICAL** | Placeholder Mounted |
| **YATRA-ILL-005** | `wheelchair-ramp-card.webp` | Assistance Category Card | WebP/PNG | 1:1 | High | Placeholder Mounted |
| **YATRA-ILL-006** | `vision-support-card.webp` | Assistance Category Card | WebP/PNG | 1:1 | High | Placeholder Mounted |
| **YATRA-ILL-007** | `elderly-mobility-card.webp` | Assistance Category Card | WebP/PNG | 1:1 | High | Placeholder Mounted |
| **YATRA-ILL-008** | `accessible-stop-photo.webp` | Accessible Stop Detail Panel | WebP | 16:9 | High | Placeholder Mounted |
| **YATRA-ILL-009** | `delhi-dark-map-texture.webp` | Operator Operations Map | WebP | 16:10 | High | Placeholder Mounted |
| **YATRA-ILL-010** | `govt-india-gate-engraving.webp` | Government Intelligence Portal | WebP/PNG | 4:3 | High | Placeholder Mounted |
| **YATRA-BRAND-001** | `yatra-brand-symbol.svg` | All Screen Navbars & Headers | SVG | 1:1 | **CRITICAL** | SVG Implemented |
| **YATRA-BRAND-002** | `yatra-wordmark.svg` | Hero & Splash Branding | SVG | 4:1 | **CRITICAL** | SVG Implemented |

---

## 4. Developer Instructions for Asset Replacement

When the production assets are rendered:
1. Place the generated `.webp` and `.svg` files into `apps/operator-web/public/assets/illustrations/`.
2. The `<AssetPlaceholder>` component automatically resolves any matching filename in `/assets/illustrations/${filename}`. If found, it renders the optimized high-resolution image; if not found, it seamlessly displays the calibrated editorial placeholder with the asset ID tag.
3. Development Mode badge displays `[Asset ID]` in small monospace font; set `NEXT_PUBLIC_SHOW_ASSET_IDS=false` or compile for production to hide debug tags automatically.
