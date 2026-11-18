import React from "react";

export function DelhiBusHeroSvg({ className = "w-full h-full" }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 500 320"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
    >
      <defs>
        <linearGradient id="busGreenIso" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stopColor="#1E8256" />
          <stop offset="60%" stopColor="#16764C" />
          <stop offset="100%" stopColor="#0E5434" />
        </linearGradient>
        <linearGradient id="rampYellow" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" stopColor="#FACC15" />
          <stop offset="100%" stopColor="#EAB308" />
        </linearGradient>
      </defs>

      {/* Ground platform / curb cut */}
      <polygon points="50,260 450,260 420,290 20,290" fill="#E6DDD0" />
      {/* Yellow tactile blister band on curb */}
      <polygon points="55,262 445,262 435,270 45,270" fill="#FDE047" opacity="0.8" />

      {/* Bus Shadow */}
      <ellipse cx="250" cy="255" rx="190" ry="16" fill="#101B3A" opacity="0.12" />

      {/* Main Bus Body */}
      <g>
        {/* Chassis */}
        <rect x="70" y="90" width="360" height="135" rx="14" fill="url(#busGreenIso)" stroke="#101B3A" strokeWidth="2.5" />
        
        {/* White Roofline */}
        <path d="M84 90 H416 C424 90 430 96 430 104 V116 H70 V104 C70 96 76 90 84 90 Z" fill="#FFFFFF" />

        {/* Terracotta Livery Accent Band */}
        <rect x="70" y="162" width="360" height="9" fill="#E96835" />

        {/* Windows */}
        <rect x="90" y="105" width="55" height="50" rx="4" fill="#101B3A" />
        <rect x="155" y="105" width="65" height="50" rx="4" fill="#101B3A" />
        <rect x="230" y="105" width="65" height="50" rx="4" fill="#101B3A" />
        <rect x="305" y="105" width="55" height="50" rx="4" fill="#101B3A" />
        {/* Front Panoramic Windshield */}
        <path d="M370 105 H416 C422 105 426 110 426 116 V148 H370 V105 Z" fill="#101B3A" />

        {/* LED Destination Matrix Display */}
        <rect x="375" y="110" width="45" height="12" rx="2" fill="#000000" />
        <text x="378" y="119" fill="#F59E0B" fontSize="7" fontFamily="monospace" fontWeight="bold">502 AIIMS</text>

        {/* Middle Accessible Entrance Doors (Open) */}
        <rect x="228" y="125" width="38" height="95" rx="2" fill="#FFFFFF" opacity="0.95" stroke="#101B3A" strokeWidth="1.5" />
        <line x1="247" y1="125" x2="247" y2="220" stroke="#16764C" strokeWidth="2" />
        
        {/* Deployed Hydraulic Wheelchair Ramp onto Curb */}
        <polygon points="228,218 266,218 274,260 220,260" fill="url(#rampYellow)" stroke="#CA8A04" strokeWidth="2" />
        {/* Ramp ribbed grip lines */}
        <line x1="226" y1="230" x2="268" y2="230" stroke="#A16207" strokeWidth="1.5" strokeDasharray="3 3" />
        <line x1="224" y1="242" x2="270" y2="242" stroke="#A16207" strokeWidth="1.5" strokeDasharray="3 3" />
        <line x1="222" y1="254" x2="272" y2="254" stroke="#A16207" strokeWidth="1.5" strokeDasharray="3 3" />

        {/* Wheelchair Accessibility Symbol on Door Panel */}
        <circle cx="205" cy="185" r="9" fill="#16764C" />
        <circle cx="205" cy="182" r="2.5" fill="#FFFFFF" />
        <path d="M205 185 V189 H209 M203 186.5 A 3.5 3.5 0 0 0 206.5 191 H209" stroke="#FFFFFF" strokeWidth="1.5" fill="none" strokeLinecap="round" />

        {/* Low Floor Wheels */}
        <g>
          <circle cx="130" cy="225" r="26" fill="#101B3A" />
          <circle cx="130" cy="225" r="14" fill="#94A3B8" />
          <circle cx="130" cy="225" r="5" fill="#101B3A" />

          <circle cx="340" cy="225" r="26" fill="#101B3A" />
          <circle cx="340" cy="225" r="14" fill="#94A3B8" />
          <circle cx="340" cy="225" r="5" fill="#101B3A" />
        </g>
      </g>
    </svg>
  );
}
