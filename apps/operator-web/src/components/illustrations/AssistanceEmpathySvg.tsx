import React from "react";

export function AssistanceEmpathySvg({ className = "w-full h-full" }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 600 380"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
    >
      <defs>
        <linearGradient id="warmBg" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stopColor="#FFF9F0" />
          <stop offset="100%" stopColor="#F5ECE0" />
        </linearGradient>
      </defs>

      {/* Warm Background Wash */}
      <rect width="600" height="380" rx="16" fill="url(#warmBg)" />

      {/* Modern Accessible Bus Stop Shelter in Background */}
      <g opacity="0.4">
        {/* Shelter cantilever canopy */}
        <path d="M100 120 C220 90, 480 90, 560 120 V130 C480 105, 220 105, 100 130 Z" fill="#172653" />
        <line x1="160" y1="125" x2="160" y2="310" stroke="#172653" strokeWidth="4" />
        <line x1="480" y1="125" x2="480" y2="310" stroke="#172653" strokeWidth="4" />
        {/* Shelter glass panel */}
        <rect x="160" y="140" width="320" height="150" fill="#E2E8F0" opacity="0.3" stroke="#CBD5E1" strokeWidth="1" />
      </g>

      {/* Low-Floor Bus Entry on Right */}
      <g transform="translate(360, 110)">
        {/* Bus Door Framework */}
        <rect x="0" y="10" width="220" height="200" fill="#16764C" stroke="#101B3A" strokeWidth="3" />
        <rect x="15" y="25" width="85" height="155" rx="4" fill="#FFFFFF" opacity="0.9" />
        <rect x="105" y="25" width="85" height="155" rx="4" fill="#FFFFFF" opacity="0.9" />
        {/* Yellow Accessibility Ramp flush to sidewalk */}
        <polygon points="15,180 190,180 205,200 0,200" fill="#FACC15" stroke="#CA8A04" strokeWidth="2" />
        {/* Door grab bar */}
        <line x1="25" y1="60" x2="25" y2="170" stroke="#E96835" strokeWidth="4" strokeLinecap="round" />
      </g>

      {/* Sidewalk & Tactile Paving Band */}
      <rect x="0" y="300" width="600" height="80" fill="#E6DDD0" />
      <rect x="80" y="305" width="460" height="18" fill="#FDE047" opacity="0.9" />
      {/* Blister dots */}
      <g fill="#CA8A04" opacity="0.7">
        <circle cx="100" cy="314" r="2.5" />
        <circle cx="130" cy="314" r="2.5" />
        <circle cx="160" cy="314" r="2.5" />
        <circle cx="190" cy="314" r="2.5" />
        <circle cx="220" cy="314" r="2.5" />
        <circle cx="250" cy="314" r="2.5" />
      </g>

      {/* Figure 1: Smiling Transit Conductor Assisting (Right) */}
      <g transform="translate(385, 135)">
        {/* Uniform body */}
        <path d="M25 60 C15 60, 5 75, 5 95 V160 H55 V95 C55 75, 45 60, 25 60 Z" fill="#172653" />
        {/* Head */}
        <circle cx="30" cy="35" r="16" fill="#D9BF9E" />
        <path d="M15 30 C15 20, 45 20, 45 30 Z" fill="#101B3A" /> {/* Hair */}
        {/* Arm extending welcomingly toward commuter */}
        <path d="M10 80 Q -15 95, -25 110" stroke="#172653" strokeWidth="8" strokeLinecap="round" />
        <circle cx="-25" cy="110" r="5" fill="#D9BF9E" />
        {/* High-visibility safety sash */}
        <path d="M15 60 L45 120" stroke="#E96835" strokeWidth="4" />
      </g>

      {/* Figure 2: Commuter in Wheelchair Boarding Up Ramp (Center) */}
      <g transform="translate(200, 150)">
        {/* Wheelchair big wheel */}
        <circle cx="50" cy="110" r="38" stroke="#101B3A" strokeWidth="4" fill="none" />
        <circle cx="50" cy="110" r="6" fill="#101B3A" />
        <line x1="50" y1="110" x2="30" y2="85" stroke="#101B3A" strokeWidth="2" />
        <line x1="50" y1="110" x2="75" y2="90" stroke="#101B3A" strokeWidth="2" />
        <line x1="50" y1="110" x2="50" y2="145" stroke="#101B3A" strokeWidth="2" />
        {/* Front castor wheel */}
        <circle cx="105" cy="138" r="10" stroke="#101B3A" strokeWidth="3" fill="#FFFFFF" />

        {/* Wheelchair Chair frame in Terracotta */}
        <path d="M35 55 L45 105 L95 105 L105 130" stroke="#E96835" strokeWidth="4.5" fill="none" strokeLinecap="round" />

        {/* Commuter figure */}
        <circle cx="60" cy="30" r="15" fill="#D9BF9E" /> {/* Head */}
        <path d="M48 24 C48 15, 72 15, 72 24 Z" fill="#101B3A" /> {/* Hair */}
        {/* Torso */}
        <path d="M48 45 C48 45, 60 45, 68 55 L75 88 L52 88 Z" fill="#16764C" />
        {/* Arms pushing wheels / holding handrail */}
        <path d="M55 58 Q 75 75, 95 72" stroke="#16764C" strokeWidth="6" strokeLinecap="round" />
        <circle cx="95" cy="72" r="4.5" fill="#D9BF9E" />
      </g>

      {/* Figure 3: Commuter with White Cane (Left) */}
      <g transform="translate(60, 160)">
        {/* Head */}
        <circle cx="30" cy="25" r="14" fill="#D9BF9E" />
        <path d="M16 20 C16 12, 44 12, 44 20 Z" fill="#475569" />
        {/* Body */}
        <rect x="18" y="40" width="24" height="65" rx="6" fill="#F07835" />
        <rect x="20" y="105" width="9" height="42" fill="#101B3A" />
        <rect x="31" y="105" width="9" height="42" fill="#101B3A" />
        {/* White cane resting on yellow tactile band */}
        <line x1="38" y1="75" x2="78" y2="148" stroke="#FFFFFF" strokeWidth="3.5" strokeLinecap="round" />
        <circle cx="78" cy="148" r="3" fill="#EF4444" /> {/* Red cane tip */}
      </g>
    </svg>
  );
}

