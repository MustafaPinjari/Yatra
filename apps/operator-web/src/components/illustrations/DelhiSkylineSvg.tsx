import React from "react";

export function DelhiSkylineSvg({ className = "w-full h-full" }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 900 180"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
    >
      <g fill="#172653" opacity="0.15">
        {/* Qutub Minar (Left) */}
        <path d="M90 160 L102 30 H108 L120 160 Z" />
        <rect x="98" y="70" width="14" height="4" fill="#E96835" />
        <rect x="100" y="110" width="10" height="4" fill="#E96835" />
        <circle cx="105" cy="25" r="4" fill="#172653" />

        {/* Humayun's Tomb Dome */}
        <path d="M220 160 V110 C220 75, 270 75, 270 110 V160 Z" />
        <circle cx="245" cy="68" r="18" />
        <line x1="245" y1="50" x2="245" y2="40" stroke="#172653" strokeWidth="2" />

        {/* Lotus Temple Petals (Center) */}
        <path d="M430 160 C420 100, 445 70, 450 60 C455 70, 480 100, 470 160 Z" />
        <path d="M400 160 C395 115, 415 90, 430 85 C420 115, 425 140, 410 160 Z" />
        <path d="M500 160 C505 115, 485 90, 470 85 C480 115, 475 140, 490 160 Z" />

        {/* India Gate Silhouette (Right-Center) */}
        <rect x="610" y="75" width="60" height="85" rx="2" />
        <path d="M625 160 V115 C625 102, 655 102, 655 115 V160 Z" fill="#F7F2E9" />
        <rect x="605" y="65" width="70" height="10" />

        {/* Red Fort Domes & Battlements (Right) */}
        <rect x="740" y="110" width="110" height="50" />
        <circle cx="760" cy="100" r="12" />
        <circle cx="795" cy="92" r="16" />
        <circle cx="830" cy="100" r="12" />
      </g>
      {/* Ground baseline */}
      <line x1="0" y1="160" x2="900" y2="160" stroke="#E6DDD0" strokeWidth="2" />
    </svg>
  );
}

