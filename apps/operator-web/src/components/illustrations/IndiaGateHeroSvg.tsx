import React from "react";

export function IndiaGateHeroSvg({ className = "w-full h-full" }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 600 500"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
    >
      <defs>
        <radialGradient id="sunGlow" cx="50%" cy="50%" r="50%">
          <stop offset="0%" stopColor="#F97316" stopOpacity="0.4" />
          <stop offset="70%" stopColor="#E96835" stopOpacity="0.1" />
          <stop offset="100%" stopColor="#F7F2E9" stopOpacity="0" />
        </radialGradient>
        <linearGradient id="sandstoneGrad" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stopColor="#EBD7C1" />
          <stop offset="50%" stopColor="#D9BF9E" />
          <stop offset="100%" stopColor="#C4A682" />
        </linearGradient>
        <linearGradient id="foliageGrad" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" stopColor="#1E8256" />
          <stop offset="100%" stopColor="#16764C" />
        </linearGradient>
        <linearGradient id="busGreen" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" stopColor="#16764C" />
          <stop offset="70%" stopColor="#1D9A64" />
          <stop offset="100%" stopColor="#16764C" />
        </linearGradient>
      </defs>

      {/* Organic Sun Aura & Foliage Background */}
      <circle cx="300" cy="210" r="180" fill="url(#sunGlow)" />
      <path
        d="M60 420 C140 380, 200 410, 300 395 C400 380, 480 410, 540 420 L540 480 L60 480 Z"
        fill="#EFE7DA"
      />

      {/* Tropical Canopy / Foliage Left & Right */}
      <g opacity="0.85">
        <ellipse cx="110" cy="300" rx="60" ry="75" fill="url(#foliageGrad)" />
        <ellipse cx="150" cy="320" rx="45" ry="60" fill="#16764C" opacity="0.9" />
        <ellipse cx="80" cy="340" rx="40" ry="50" fill="#0D5434" />
        
        <ellipse cx="490" cy="300" rx="60" ry="75" fill="url(#foliageGrad)" />
        <ellipse cx="450" cy="320" rx="45" ry="60" fill="#16764C" opacity="0.9" />
        <ellipse cx="520" cy="340" rx="40" ry="50" fill="#0D5434" />
      </g>

      {/* India Gate Architectural Geometry */}
      <g>
        {/* Base steps */}
        <rect x="190" y="360" width="220" height="12" rx="2" fill="#B39371" />
        <rect x="180" y="372" width="240" height="10" rx="2" fill="#9E7D59" />
        <rect x="170" y="382" width="260" height="10" rx="2" fill="#8C6B48" />

        {/* Main Pylons */}
        <rect x="205" y="150" width="55" height="210" fill="url(#sandstoneGrad)" stroke="#8C6B48" strokeWidth="1.5" />
        <rect x="340" y="150" width="55" height="210" fill="url(#sandstoneGrad)" stroke="#8C6B48" strokeWidth="1.5" />

        {/* Central Gateway Arch */}
        <path
          d="M260 360 V240 C260 205, 340 205, 340 240 V360 Z"
          fill="#F7F2E9"
          stroke="#8C6B48"
          strokeWidth="2"
        />
        {/* Inner Arch shadow */}
        <path
          d="M268 360 V245 C268 215, 332 215, 332 245 V360 Z"
          fill="#E7D8C5"
          opacity="0.6"
        />

        {/* Arch Cornice and Dentils */}
        <line x1="200" y1="210" x2="400" y2="210" stroke="#8C6B48" strokeWidth="2.5" />
        <line x1="200" y1="216" x2="400" y2="216" stroke="#9E7D59" strokeWidth="1.5" />

        {/* Upper Attic Entablature */}
        <rect x="195" y="100" width="210" height="50" fill="url(#sandstoneGrad)" stroke="#8C6B48" strokeWidth="2" />
        {/* Attic decorative panel */}
        <rect x="210" y="110" width="180" height="30" fill="#E2CCB2" stroke="#9E7D59" strokeWidth="1" />
        {/* Classical cornice top */}
        <rect x="185" y="88" width="230" height="12" rx="2" fill="#9E7D59" stroke="#7A5A38" strokeWidth="1.5" />
        <rect x="235" y="72" width="130" height="16" rx="2" fill="#B39371" stroke="#7A5A38" strokeWidth="1.5" />
        {/* Top urn bowl */}
        <path d="M280 72 C280 62, 320 62, 320 72 Z" fill="#E96835" />

        {/* Fine architectural panel linework */}
        <line x1="220" y1="160" x2="245" y2="160" stroke="#8C6B48" strokeWidth="1" />
        <line x1="220" y1="200" x2="245" y2="200" stroke="#8C6B48" strokeWidth="1" />
        <line x1="220" y1="280" x2="245" y2="280" stroke="#8C6B48" strokeWidth="1" />

        <line x1="355" y1="160" x2="380" y2="160" stroke="#8C6B48" strokeWidth="1" />
        <line x1="355" y1="200" x2="380" y2="200" stroke="#8C6B48" strokeWidth="1" />
        <line x1="355" y1="280" x2="380" y2="280" stroke="#8C6B48" strokeWidth="1" />
      </g>

      {/* Modern DTC Transit Bus in Foreground */}
      <g transform="translate(140, 370)">
        {/* Bus Shadow */}
        <ellipse cx="160" cy="65" rx="150" ry="10" fill="#101B3A" opacity="0.18" />

        {/* Bus Main Chassis (Green low-floor) */}
        <rect x="20" y="10" width="280" height="48" rx="8" fill="url(#busGreen)" stroke="#101B3A" strokeWidth="2" />
        {/* White roof & upper band */}
        <path d="M28 10 H292 C296 10 300 14 300 18 V24 H20 V18 C20 14 24 10 28 10 Z" fill="#FFFFFF" />

        {/* Panoramic Glass Windows */}
        <rect x="35" y="16" width="38" height="18" rx="2" fill="#101B3A" />
        <rect x="78" y="16" width="48" height="18" rx="2" fill="#101B3A" />
        <rect x="131" y="16" width="48" height="18" rx="2" fill="#101B3A" />
        <rect x="184" y="16" width="48" height="18" rx="2" fill="#101B3A" />
        {/* Front Windshield */}
        <path d="M237 16 H285 C290 16 294 20 294 25 V34 H237 V16 Z" fill="#101B3A" />

        {/* Route Destination Display Matrix (Amber LED) */}
        <rect x="242" y="18" width="42" height="6" rx="1" fill="#000000" />
        <text x="245" y="23" fill="#F59E0B" fontSize="4.5" fontFamily="monospace" fontWeight="bold">502 AIIMS</text>

        {/* Middle Door with Wheelchair Ramp Badge */}
        <rect x="132" y="24" width="22" height="34" fill="#FFFFFF" opacity="0.9" stroke="#16764C" strokeWidth="1" />
        <circle cx="143" cy="40" r="4.5" fill="#16764C" />
        {/* International accessibility wheelchair symbol */}
        <path d="M141.5 38 A 1.2 1.2 0 1 1 143.9 38 A 1.2 1.2 0 1 1 141.5 38 M143 40 V42 H145 M141.5 41 A 2 2 0 0 0 143.5 43.5 H145" stroke="#FFFFFF" strokeWidth="0.8" fill="none" strokeLinecap="round" />

        {/* Front Door */}
        <rect x="238" y="24" width="20" height="34" fill="#FFFFFF" opacity="0.9" stroke="#16764C" strokeWidth="1" />

        {/* Terracotta Livery Accent Stripe */}
        <line x1="20" y1="36" x2="238" y2="36" stroke="#E96835" strokeWidth="3" />

        {/* Low-Floor Wheels with Silver Hubcaps */}
        <g>
          <circle cx="65" cy="58" r="15" fill="#101B3A" />
          <circle cx="65" cy="58" r="8" fill="#94A3B8" />
          <circle cx="65" cy="58" r="3" fill="#101B3A" />

          <circle cx="235" cy="58" r="15" fill="#101B3A" />
          <circle cx="235" cy="58" r="8" fill="#94A3B8" />
          <circle cx="235" cy="58" r="3" fill="#101B3A" />
        </g>
      </g>
    </svg>
  );
}

