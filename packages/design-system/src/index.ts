// ==============================================================================
// YATRA Design System - Accessible Color Tokens & Standards (WCAG 2.2 AA)
// ==============================================================================

export const colors = {
  // Primary brand (deep indigo / public transit authority tone)
  primary: {
    50: '#eef2ff',
    100: '#e0e7ff',
    200: '#c7d2fe',
    500: '#4f46e5',
    600: '#4338ca',
    700: '#3730a3',
    900: '#1e1b4b',
  },
  // Accessibility accent (vibrant emerald for verified ramps & accessible paths)
  accessibility: {
    50: '#ecfdf5',
    500: '#10b981',
    600: '#059669',
    700: '#047857',
  },
  // Crowding tiers (designed for colorblind legibility + distinct luminance)
  crowding: {
    low: {
      bg: '#ecfdf5',
      text: '#065f46',
      border: '#a7f3d0',
      label: 'Low Crowding (< 30%)',
    },
    medium: {
      bg: '#fffbeb',
      text: '#92400e',
      border: '#fde68a',
      label: 'Moderate Seats Available (30-70%)',
    },
    high: {
      bg: '#fff7ed',
      text: '#9a3412',
      border: '#fed7aa',
      label: 'Standing Room Only (70-95%)',
    },
    overcrowded: {
      bg: '#fef2f2',
      text: '#991b1b',
      border: '#fecaca',
      label: 'Overcrowded / Boarding Constrained (> 95%)',
    },
  },
  neutral: {
    white: '#ffffff',
    background: '#f8fafc',
    surface: '#ffffff',
    border: '#e2e8f0',
    textPrimary: '#0f172a',
    textSecondary: '#475569',
    textMuted: '#64748b',
  },
};

export const typography = {
  fontFamily: 'system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
  minTapTargetSize: '48px', // Meets WCAG 2.5.5 Target Size (Enhanced)
  focusRing: '3px solid #4f46e5',
};

