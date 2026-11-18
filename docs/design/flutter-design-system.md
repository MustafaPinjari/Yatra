# YATRA — Flutter Mobile Design System & Implementation Guide

**Document Version:** 1.0.0  
**Target Package:** `apps/passenger-mobile/`  
**Framework:** Flutter 3.47+ / Dart 3.13+ (Material 3)  
**Status:** Canonical Implementation Reference  

---

## 1. Architectural Philosophy

The passenger mobile application is built strictly as a **native Flutter application**. It directly implements the YATRA Living Atlas design system without webviews, iframes, or simulated DOM wrappers.

### Core Principles
- **Native Material 3 Customization:** Completely custom `ThemeData` mapped to YATRA's warm ivory, deep ink navy, and terracotta palette.
- **Custom Vector Drawing via CustomPainter:** High-fidelity architectural illustrations (India Gate, Delhi Skyline, low-floor DTC bus, Boarding Empathy) rendered natively on the Skia/Impeller canvas with zero image loading delay or network dependencies.
- **Accessible State Management (Riverpod):** Clean separation of UI and business logic, providing instant reactivity for route planning, live ETA updates, and boarding assistance signaling.
- **Semantic Navigation (GoRouter):** Deep linking and declarative navigation across all primary passenger workflows.

---

## 2. Color Palette & Token Mapping

```dart
class YatraColors {
  // Surfaces & Backgrounds
  static const Color parchmentBg = Color(0xFFF7F2E9);
  static const Color surfaceCream = Color(0xFFFFFCF7);
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  // Inks & Typography
  static const Color inkPrimary = Color(0xFF101B3A);
  static const Color inkSecondary = Color(0xFF4A5568);
  static const Color inkMuted = Color(0xFF718096);

  // Brand Accents
  static const Color navyDeep = Color(0xFF172653);
  static const Color terracotta = Color(0xFFE96835);
  static const Color accentOrange = Color(0xFFF07835);
  static const Color sandGold = Color(0xFFD4A373);

  // Semantic & Transit States
  static const Color heritageGreen = Color(0xFF16764C);
  static const Color paleGreen = Color(0xFFE4F1E5);
  static const Color amberWarning = Color(0xFFD97706);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color errorRed = Color(0xFFDC2626);
  static const Color softBorder = Color(0xFFE6DDD0);
}
```

---

## 3. Typography Hierarchy

```dart
class YatraTypography {
  // Classical Editorial Display Serif (Playfair Display / Serif fallback)
  static TextStyle headlineSerif({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w700,
    Color color = YatraColors.inkPrimary,
  }) {
    return TextStyle(
      fontFamily: 'Playfair Display',
      fontFamilyFallback: const ['Georgia', 'serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.2,
      letterSpacing: -0.5,
    );
  }

  // Modern Clean Sans-Serif (Inter / Roboto fallback)
  static TextStyle bodySans({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = YatraColors.inkPrimary,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontFamilyFallback: const ['Roboto', 'sans-serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.4,
    );
  }

  // Large Statistical Numerals
  static TextStyle metricSerif({
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.bold,
    Color color = YatraColors.inkPrimary,
  }) {
    return TextStyle(
      fontFamily: 'Playfair Display',
      fontFamilyFallback: const ['Georgia', 'serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
```

---

## 4. Screen-by-Screen Mobile Inventory

| Route | Screen Name | Description & Key Features |
| :--- | :--- | :--- |
| `/` | **IntroScreen** | "Move Delhi Together" hero headline, India Gate custom painter, orange architectural arches, onboarding CTA. |
| `/home` | **PassengerHomeScreen** | City switcher, Delhi skyline masthead, destination search bar, 4 primary action buttons, nearest approaching low-floor bus card. |
| `/planner` | **JourneyPlannerScreen** | Transit mode toggles (Bus / Metro / Multimodal), origin & destination input, accessibility filter chips, route recommendation cards with serif ETA. |
| `/tracking` | **LiveTrackingScreen** | Map visualization canvas with bus marker, real-time stop timeline, vehicle registration & ramp status, speed/occupancy meter. |
| `/assistance` | **AssistanceScreen** | Boarding assistance request flow, assistance category selector (Wheelchair, Blind/Low Vision, Elderly, Sensory), route picker, driver signaling beacon. |
| `/stops` | **AccessibleStopsScreen** | AccessGraph stop explorer, filter chips (Ramp, Tactile Paving, Audio Announcements), stop accessibility score card (0-100). |
| `/history` | **TripHistoryScreen** | Log of previous journeys, carbon savings indicator, verified accessible route badges. |
| `/notifications` | **NotificationsScreen** | Operational alerts, route diversion notices, handshake acknowledgment signals from drivers. |
| `/profile` | **ProfileScreen** | Passenger accessibility profile, disability concession passes, emergency contact configuration, screen-reader optimizations. |

---

## 5. Accessibility Implementation (WCAG 2.2 AA)

- Every custom painted visual element is wrapped in an explicit `Semantics` widget with descriptive labels.
- Interactive tap targets strictly adhere to minimum dimensions of `48 × 48 dp`.
- High-contrast text exceeds WCAG AAA ratio (`> 7:1`) on `#F7F2E9` backgrounds.
- Screen reader accessibility toggles dynamically expand descriptive text.
