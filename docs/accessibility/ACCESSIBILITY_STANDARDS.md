# YATRA — Accessibility Standards & Implementation Guide

**Target Standard:** WCAG 2.2 AA (Web) / Android & iOS Accessibility Guidelines (Mobile)  
**Author:** Accessibility Lead & Principal Architect  

---

## 1. Universal Accessibility Manifesto

In public transit technology, accessibility is not a secondary convenience feature—it is the foundational architecture. YATRA is engineered to ensure that any commuter, regardless of visual, motor, auditory, linguistic, or cognitive capability, can navigate the transit network with independence and dignity.

---

## 2. Core Implementation Requirements

### 2.1 Screen-Reader Compatibility (TalkBack, VoiceOver, NVDA)
- **Semantic HTML & Flutter Semantics:**
  - All interactive elements must use semantic tags (`<button>`, `<main>`, `<nav>`, `<header>`) or Flutter `Semantics(label: ..., button: true)`.
  - No unlabelled icon-only buttons. Every icon button must declare an accessible label (e.g., `aria-label="Request wheelchair ramp"`).
  - Dynamic status changes (e.g., *"Driver acknowledged your boarding request"*) must be announced immediately using `aria-live="polite"` or `SemanticsService.announce()`.

### 2.2 Keyboard Navigation & Focus Management
- Complete keyboard operability without requiring mouse or touch.
- Logical tab order matching visual flow (`tabindex="0"`, no positive tab indices).
- High-visibility focus indicators with a minimum 3:1 contrast ratio against the adjacent background (`focus-visible:ring-2 focus-visible:ring-offset-2`).
- Skip navigation link (`<a href="#main-content">Skip to main content</a>`) on all web pages.

### 2.3 Color Contrast & Visual Design
- **Normal Text (< 18pt / 24px):** Minimum contrast ratio of **4.5:1** against the background.
- **Large Text (>= 18pt or 14pt bold):** Minimum contrast ratio of **3:1**.
- **UI Components & Graphical Objects:** Minimum contrast ratio of **3:1** for borders and state indicators.
- **Information Conveyance:** Never use color alone to convey meaning (e.g., crowding status must include both distinct color and text badge like *"Low (24%)"* or icon).

### 2.4 Scalable Typography & Dynamic Type
- Responsive fonts supporting up to 200% zoom without truncation, horizontal scrolling, or overlapping containers.
- Relative sizing units (`rem`, `em`, `clamp()`) throughout CSS and Flutter scalable text scaling factors.

### 2.5 Audio & Visual Redundancy (Dual Modality)
- Every critical event must be delivered via both visual and auditory channels:
  - Driver alerts present a high-contrast visual banner accompanied by an audible chime and speech announcement: *"Upcoming Stop: AIIMS. Wheelchair assistance requested."*
  - Passenger boarding alerts trigger device haptic vibration, audible notification, and screen flash.

### 2.6 Voice Interaction & Hands-Free Driver Mode
- Drivers cannot safely look at or touch mobile screens while maneuvering heavy urban buses in traffic.
- DriverAssist supports hands-free operation: automatic geo-triggered popups and spoken announcements.
- Single large-target button (occupying 50%+ of screen width) for physical one-tap acknowledgment if needed.

### 2.7 Cognitive Simplification
- Clear, plain language avoiding bureaucratic transit jargon.
- Progressive disclosure: show essential journey information upfront (Next Bus, Time, Crowding, Ramp); hide complex schedules behind an expander.
- Google Gemini 2.5 Flash is integrated to summarize complex detour or service disruption notices into 1-2 sentence plain-language bullet points.

### 2.8 Multilingual Support (Indic Transit Context)
- Native support for key regional languages of the National Capital Region (NCR):
  - Hindi (हिन्दी)
  - English
  - Punjabi (ਪੰਜਾਬੀ)
  - Urdu (اردو)
- Full support for Right-to-Left (RTL) layout mirroring when Urdu is selected.

### 2.9 Accessible Map Alternatives
- Digital maps (MapLibre/Leaflet) can be inaccessible to screen-reader users.
- YATRA mandates a **Text / List View Toggle** alongside every map view:
  - Users can switch from the visual map to a structured, ordered HTML table/list of stops, arrival times, and accessibility features.

### 2.10 Offline & Low-Bandwidth Graceful Degradation
- In crowded transit corridors or underground metro interchanges, mobile connectivity drops.
- Core schedule data and the AccessGraph for favorited routes are cached locally using IndexedDB (Web) and SQLite/Hive (Mobile).
- Offline banner clearly indicates cached status with timestamp.

