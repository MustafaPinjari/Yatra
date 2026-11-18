# YATRA — Complete Image Placement & Code Mapping Guide

**Document Version:** 2.0.0  
**Design Direction:** Living Atlas (Editorial Warm Ivory & Delhi Transit Heritage)  
**Target:** Visual Designers, AI Art Prompters, Frontend Developers, QA Engineers  

---

## 1. Master Image Placement Matrix

This table lists **every single image required**, the exact code file and widget/component where it is displayed, the required dimensions, and the disk path where the image file must be placed.

| Asset ID | Filename | App / Target | Code File Path | Component / Widget & Line | Dimensions & Aspect Ratio | Transparent Bg? | Priority |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`YATRA-ILL-001`** | `india-gate-hero.webp` | **Passenger Mobile** | `apps/passenger-mobile/lib/features/intro/presentation/intro_screen.dart` | `YatraAssetPlaceholder(assetId: 'YATRA-ILL-001')` (~line 58) | **1600 × 2000 px**<br>`4:5` (or `4:3`) | Seamless with `#F7F2E9` | **CRITICAL** |
| **`YATRA-ILL-001`** | `india-gate-hero.webp` | **Operator Web** | `apps/operator-web/src/components/screens/GovtIntelligenceView.tsx` | `<AssetPlaceholder assetId="YATRA-ILL-001" />` | **1920 × 1080 px**<br>`16:9` banner | No | **CRITICAL** |
| **`YATRA-ILL-002`** | `delhi-bus-isometric.webp` | **Passenger Mobile** | `apps/passenger-mobile/lib/features/home/presentation/home_screen.dart` | `YatraAssetPlaceholder(assetId: 'YATRA-ILL-002')` (~line 267) | **1200 × 750 px**<br>`16:10` | **YES (Alpha)** | **CRITICAL** |
| **`YATRA-ILL-002`** | `delhi-bus-isometric.webp` | **Operator Web** | `apps/operator-web/src/components/FleetOverview.tsx` | `<AssetPlaceholder assetId="YATRA-ILL-002" />` | **1200 × 750 px**<br>`16:10` | **YES (Alpha)** | **CRITICAL** |
| **`YATRA-ILL-003`** | `delhi-skyline-arch.webp` | **Passenger Mobile** | `apps/passenger-mobile/lib/features/home/presentation/home_screen.dart` | `YatraAssetPlaceholder(assetId: 'YATRA-ILL-003')` (~line 103) | **1800 × 600 px**<br>`21:9` or `21:8` | **YES (Alpha)** | High |
| **`YATRA-ILL-004`** | `boarding-assistance-empathy.webp` | **Passenger Mobile** | `apps/passenger-mobile/lib/features/assistance/presentation/assistance_screen.dart` | `YatraAssetPlaceholder(assetId: 'YATRA-ILL-004')` (~line 93) | **1600 × 900 px**<br>`16:9` | No (Full Bleed) | **CRITICAL** |
| **`YATRA-ILL-004`** | `boarding-assistance-empathy.webp` | **Operator Web** | `apps/operator-web/src/components/AssistanceRequestsTable.tsx` | `<AssetPlaceholder assetId="YATRA-ILL-004" />` | **1600 × 900 px**<br>`16:9` | No | **CRITICAL** |
| **`YATRA-ILL-005`** | `wheelchair-ramp-card.webp` | **Passenger Mobile** | `apps/passenger-mobile/lib/features/assistance/presentation/assistance_screen.dart` | `_categories[0]` Tile Thumbnail | **400 × 400 px**<br>`1:1` | **YES (Alpha)** | High |
| **`YATRA-ILL-006`** | `vision-support-card.webp` | **Passenger Mobile** | `apps/passenger-mobile/lib/features/assistance/presentation/assistance_screen.dart` | `_categories[1]` Tile Thumbnail | **400 × 400 px**<br>`1:1` | **YES (Alpha)** | High |
| **`YATRA-ILL-007`** | `elderly-mobility-card.webp` | **Passenger Mobile** | `apps/passenger-mobile/lib/features/assistance/presentation/assistance_screen.dart` | `_categories[3]` Tile Thumbnail | **400 × 400 px**<br>`1:1` | **YES (Alpha)** | High |
| **`YATRA-ILL-008`** | `accessible-stop-photo.webp` | **Passenger Mobile** | `apps/passenger-mobile/lib/features/stops/presentation/accessible_stops_screen.dart` | Stop Detail Dialog / Card Header | **1200 × 675 px**<br>`16:9` | No | High |
| **`YATRA-ILL-009`** | `delhi-dark-map-texture.webp` | **Operator Web** | `apps/operator-web/src/components/screens/OperatorCommandView.tsx` | Transit Map Canvas Container | **1920 × 1200 px**<br>`16:10` | No | High |
| **`YATRA-ILL-010`** | `govt-india-gate-engraving.webp` | **Operator Web** | `apps/operator-web/src/components/screens/GovtIntelligenceView.tsx` | `<AssetPlaceholder assetId="YATRA-ILL-010" />` (~line 52) | **800 × 800 px**<br>`1:1` | **YES (Alpha)** | High |
| **`YATRA-BRAND-001`**| `yatra-brand-symbol.svg` | **Both Mobile & Web**| Navbars, Splash, App Bars, Drawer | `YatraBrandLogo` / AppBar | **Vector SVG**<br>`1:1` | **YES** | **CRITICAL** |
| **`YATRA-BRAND-002`**| `yatra-wordmark.svg` | **Both Mobile & Web**| Headers, Hero Masthead, Auth | `YatraBrandLogo` / Masthead | **Vector SVG**<br>`4:1` | **YES** | **CRITICAL** |

---

## 2. Directory Tree — Where to Save Each Image File

Save generated image files in the following standard repository locations:

```
c:\Users\mustafa\Desktop\Yatra\
├── assets/                                        <-- Master Shared Art Assets
│   ├── illustrations/
│   │   ├── india-gate-hero.webp                  <-- YATRA-ILL-001
│   │   ├── delhi-bus-isometric.webp              <-- YATRA-ILL-002
│   │   ├── delhi-skyline-arch.webp               <-- YATRA-ILL-003
│   │   ├── boarding-assistance-empathy.webp      <-- YATRA-ILL-004
│   │   ├── wheelchair-ramp-card.webp             <-- YATRA-ILL-005
│   │   ├── vision-support-card.webp              <-- YATRA-ILL-006
│   │   ├── elderly-mobility-card.webp            <-- YATRA-ILL-007
│   │   ├── accessible-stop-photo.webp            <-- YATRA-ILL-008
│   │   ├── delhi-dark-map-texture.webp           <-- YATRA-ILL-009
│   │   └── govt-india-gate-engraving.webp        <-- YATRA-ILL-010
│   └── brand/
│       ├── yatra-brand-symbol.svg                <-- YATRA-BRAND-001
│       └── yatra-wordmark.svg                    <-- YATRA-BRAND-002
│
├── apps/
│   ├── passenger-mobile/
│   │   └── assets/
│   │       ├── images/                           <-- Copy .webp files here for Flutter
│   │       │   ├── india-gate-hero.webp
│   │       │   ├── delhi-bus-isometric.webp
│   │       │   ├── delhi-skyline-arch.webp
│   │       │   └── boarding-assistance-empathy.webp
│   │       └── brand/                            <-- Copy brand SVGs here
│   │           ├── yatra-logo.svg
│   │           └── yatra-wordmark.svg
│   │
│   └── operator-web/
│       └── public/
│           └── assets/
│               ├── illustrations/                <-- Copy .webp files here for Next.js
│               │   ├── india-gate-hero.webp
│               │   ├── delhi-bus-isometric.webp
│               │   ├── delhi-dark-map-texture.webp
│               │   ├── boarding-assistance-empathy.webp
│               │   └── govt-india-gate-engraving.webp
│               └── brand/
│                   ├── yatra-logo.svg
│                   └── yatra-wordmark.svg
```

---

## 3. Screen-by-Screen Breakdown: Mobile (Flutter)

### Screen 1: Passenger Introduction & Onboarding (`IntroScreen`)
- **Code Path:** [apps/passenger-mobile/lib/features/intro/presentation/intro_screen.dart](file:///c:/Users/mustafa/Desktop/Yatra/apps/passenger-mobile/lib/features/intro/presentation/intro_screen.dart)
- **Widget Placement:**
  ```dart
  const Expanded(
    flex: 5,
    child: YatraAssetPlaceholder(
      assetId: 'YATRA-ILL-001',
      aspectRatio: 4 / 3,
      semanticLabel: 'Architectural illustration of India Gate with a low-floor DTC bus traveling in the foreground',
    ),
  ),
  ```
- **Required Image:** `india-gate-hero.webp`
- **Visual Description:** India Gate centered under a warm amber dusk sky (`#FCECDD` to `#F7F2E9`). Terracotta sun arches rise behind the monument, framed by tropical Neem foliage. A modern green-and-white low-floor DTC electric bus travels on Rajpath in the foreground.

---

### Screen 2: Passenger Home Screen (`PassengerHomeScreen`)
- **Code Path:** [apps/passenger-mobile/lib/features/home/presentation/home_screen.dart](file:///c:/Users/mustafa/Desktop/Yatra/apps/passenger-mobile/lib/features/home/presentation/home_screen.dart)
- **Widget Placement 1 (Skyline Masthead):**
  ```dart
  const YatraAssetPlaceholder(
    assetId: 'YATRA-ILL-003',
    aspectRatio: 21 / 8,
    semanticLabel: 'Delhi skyline silhouette featuring Qutub Minar, Metro, Red Fort domes, and Lotus Temple',
  ),
  ```
  - **Required Image:** `delhi-skyline-arch.webp` (Aspect Ratio: `21:8`, Transparent background).
- **Widget Placement 2 (Approaching Low-Floor Bus Card):**
  ```dart
  const YatraAssetPlaceholder(
    assetId: 'YATRA-ILL-002',
    aspectRatio: 16 / 7,
    semanticLabel: 'Modern DTC electric low-floor bus with deployed ramp',
  ),
  ```
  - **Required Image:** `delhi-bus-isometric.webp` (Aspect Ratio: `16:10`, Transparent PNG/WebP with alpha).
  - **Visual Description:** Ultra-modern Delhi AC electric bus displaying "502 KASHMERE GATE" with extended neon-yellow wheelchair ramp flush with sidewalk curb.

---

### Screen 3: Boarding Assistance Screen (`AssistanceScreen`)
- **Code Path:** [apps/passenger-mobile/lib/features/assistance/presentation/assistance_screen.dart](file:///c:/Users/mustafa/Desktop/Yatra/apps/passenger-mobile/lib/features/assistance/presentation/assistance_screen.dart)
- **Widget Placement (Narrative Hero):**
  ```dart
  const YatraAssetPlaceholder(
    assetId: 'YATRA-ILL-004',
    aspectRatio: 16 / 9,
    semanticLabel: 'Empathetic illustration showing a wheelchair commuter boarding a DTC bus via ramp with helpful conductor',
  ),
  ```
- **Required Image:** `boarding-assistance-empathy.webp`
- **Visual Description:** Commuter in active manual wheelchair boarding effortlessly into a kneeling low-floor DTC bus. A welcoming conductor stands beside the entrance handrail, while a commuter with white cane walks along bright yellow tactile paving.

---

### Screen 4: Accessible Stops Screen (`AccessibleStopsScreen`)
- **Code Path:** [apps/passenger-mobile/lib/features/stops/presentation/accessible_stops_screen.dart](file:///c:/Users/mustafa/Desktop/Yatra/apps/passenger-mobile/lib/features/stops/presentation/accessible_stops_screen.dart)
- **Widget Placement:** Stop Inspection & AccessGraph Score Details
- **Required Image:** `accessible-stop-photo.webp` (Aspect Ratio: `16:9`, `1200 × 675 px`).
- **Visual Description:** Verified curb platform at AIIMS Metro Bus Stop with flush ramp interface, shelter canopy, tactile paving, and LED route sign.

---

## 4. Screen-by-Screen Breakdown: Desktop Web (Next.js)

### Screen 1: Government Intelligence Portal (`GovtIntelligenceView`)
- **Code Path:** [apps/operator-web/src/components/screens/GovtIntelligenceView.tsx](file:///c:/Users/mustafa/Desktop/Yatra/apps/operator-web/src/components/screens/GovtIntelligenceView.tsx)
- **Widget Placement (Header Engraving):**
  ```tsx
  <AssetPlaceholder
    assetId="YATRA-ILL-010"
    filename="govt-india-gate-engraving.webp"
    alt="Classical architectural engraving of India Gate on cream parchment"
    aspectRatio="1/1"
    className="rounded-xl border border-[#E6DDD0] bg-[#FFFCF7]"
    title="India Gate Engraving"
  />
  ```
- **Required Image:** `govt-india-gate-engraving.webp` (Aspect Ratio: `1:1`, `800 × 800 px`, Transparent background).
- **Visual Description:** Monochromatic fine-line copperplate engraving of India Gate seen through a traditional archway, evoking authority and municipal planning.

---

### Screen 2: Operator Command Centre (`OperatorCommandView`)
- **Code Path:** [apps/operator-web/src/components/screens/OperatorCommandView.tsx](file:///c:/Users/mustafa/Desktop/Yatra/apps/operator-web/src/components/screens/OperatorCommandView.tsx)
- **Widget Placement:** Live Operations Map Canvas
- **Required Image:** `delhi-dark-map-texture.webp` (Aspect Ratio: `16:10`, `1920 × 1200 px`).
- **Visual Description:** Dark high-tech vector map of Delhi transit corridors (Ring Road, GT Road, Mehrauli Road) glowing on a midnight navy canvas (`#0B132B`).

---

### Screen 3: Live Fleet Overview & Maintenance
- **Code Path:** [apps/operator-web/src/components/FleetOverview.tsx](file:///c:/Users/mustafa/Desktop/Yatra/apps/operator-web/src/components/FleetOverview.tsx)
- **Widget Placement:** Fleet Status Card
- **Required Image:** `delhi-bus-isometric.webp` (`YATRA-ILL-002`)

---

## 5. Ready-to-Use AI Generation Prompts

Copy and paste these exact prompts into Midjourney, DALL-E 3, or Google Imagen:

### Prompt 1: India Gate Hero (`YATRA-ILL-001`)
> `Contemporary editorial vector gouache illustration of India Gate monument in New Delhi under warm golden hour dusk sky. Organic terracotta-tinted sun arches in background, framed by tropical neem and jamun leaves in emerald green. In foreground, a modern Delhi DTC green and white low-floor electric bus moving smoothly on Rajpath. Fine ink architectural outlines, soft risograph texture, warm parchment background #F7F2E9, high contrast, elegant travel magazine style, no text, 4:5 aspect ratio --ar 4:5 --v 6.0`

### Prompt 2: Modern Delhi Low-Floor Bus (`YATRA-ILL-002`)
> `Clean 3/4 isometric product illustration of modern Delhi DTC electric AC low-floor city bus. Two-tone emerald transit green #16764C and white body. Kneeling suspension active, front doors open with deployed bright yellow wheelchair ramp meeting elevated curb flush. Large glass windows showing wheelchair priority seating area. Clean geometric vector linework, subtle metallic reflections, transparent background, isolated, 16:10 aspect ratio --ar 16:10 --v 6.0`

### Prompt 3: Delhi Panoramic Skyline (`YATRA-ILL-003`)
> `Minimalist architectural continuous silhouette band of Delhi landmarks in horizontal panoramic composition: Qutub Minar tower, elevated Metro rail viaduct on concrete pillars, Red Fort Mughal onion domes, and Lotus Temple petals. Terracotta orange and slate navy tones on clean warm parchment background #F7F2E9. Flat architectural elevation profile, transparent background, 21:9 aspect ratio --ar 21:9 --v 6.0`

### Prompt 4: Boarding Assistance Empathy (`YATRA-ILL-004`)
> `Warm and empathetic editorial character illustration of an accessible bus stop in Delhi. A smiling confident commuter in an active manual wheelchair is boarding effortlessly across an integrated yellow ramp into a low-floor DTC bus. A female transit conductor in uniform stands welcoming at the doorway. A gentleman with dark glasses and white cane walks along bright yellow tactile paving. Dignified, inclusive, warm golden hour ambient lighting, editorial storybook style, warm ivory tones, 16:9 aspect ratio --ar 16:9 --v 6.0`

### Prompt 5: Government India Gate Engraving (`YATRA-ILL-010`)
> `Fine-line classical 19th-century copperplate architectural engraving of India Gate viewed through an ornate Mughal stone archway. Detailed stone hatching, delicate botanical border motifs, rich navy ink on warm cream parchment #F7F2E9, vintage cartographic emblem, symmetrical, dignified civic authority, transparent background, 1:1 square aspect ratio --ar 1:1 --v 6.0`

---

## 6. How the Code Loads These Assets

- **Next.js (`apps/operator-web`)**:
  `<AssetPlaceholder assetId="YATRA-ILL-001" filename="india-gate-hero.webp" />` automatically checks `public/assets/illustrations/${filename}`. If the file exists, it displays the high-res image; if not, it automatically falls back to an inline vector illustration with the catalog tag badge.
- **Flutter (`apps/passenger-mobile`)**:
  `YatraAssetPlaceholder(assetId: 'YATRA-ILL-001')` renders the native canvas `CustomPainter` (`IndiaGatePainter`, `LowFloorBusPainter`, etc.). Once raster assets are saved into `apps/passenger-mobile/assets/images/`, `Image.asset()` will render them with zero delay.
