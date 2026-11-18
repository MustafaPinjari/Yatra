"use client";

import React from "react";

interface YatraWaveBackgroundProps {
  variant?: "hero" | "subtle" | "top-left" | "bottom" | "editorial";
  className?: string;
  opacity?: number;
  children?: React.ReactNode;
}

export function YatraWaveBackground({
  variant = "subtle",
  className = "",
  opacity,
  children,
}: YatraWaveBackgroundProps) {
  const isWrapper = children !== undefined;

  return (
    <div
      className={`${isWrapper ? "relative overflow-hidden" : "absolute inset-0 pointer-events-none"} ${className}`}
      style={opacity !== undefined ? { opacity } : undefined}
    >
      {/* Background SVG Wave Layer */}
      <div className="absolute inset-0 pointer-events-none z-0" aria-hidden="true">
        {variant === "hero" && <HeroWaves />}
        {variant === "top-left" && <TopLeftWaves />}
        {variant === "bottom" && <BottomWaves />}
        {variant === "subtle" && <SubtleWaves />}
        {variant === "editorial" && <EditorialWaves />}
      </div>

      {/* Foreground Content */}
      {children && <div className="relative z-10">{children}</div>}
    </div>
  );
}

function HeroWaves() {
  return (
    <svg
      viewBox="0 0 1440 600"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className="w-full h-full object-cover"
      preserveAspectRatio="none"
    >
      <defs>
        <linearGradient id="heroTerracottaGrad" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stopColor="#E96835" stopOpacity="0.22" />
          <stop offset="60%" stopColor="#F07835" stopOpacity="0.10" />
          <stop offset="100%" stopColor="#F7F2E9" stopOpacity="0.0" />
        </linearGradient>
        <linearGradient id="heroPeachGrad" x1="100%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" stopColor="#FCECDD" stopOpacity="0.65" />
          <stop offset="100%" stopColor="#F7F2E9" stopOpacity="0.1" />
        </linearGradient>
      </defs>

      {/* Flowing Layer 1: Peach Soft Transition */}
      <path
        d="M-40 280 C 260 180, 520 420, 880 310 C 1180 220, 1380 340, 1500 290 L 1500 0 L -40 0 Z"
        fill="url(#heroPeachGrad)"
      />

      {/* Flowing Layer 2: Terracotta Warm Swell */}
      <path
        d="M-20 400 C 340 320, 600 520, 960 410 C 1220 330, 1390 440, 1480 390 L 1480 600 L -20 600 Z"
        fill="url(#heroTerracottaGrad)"
      />

      {/* Delicate Accent Stroke 1 */}
      <path
        d="M0 310 C 320 220, 580 430, 940 340 C 1200 270, 1360 360, 1440 330"
        stroke="#E96835"
        strokeWidth="1.5"
        strokeOpacity="0.4"
        strokeDasharray="6 4"
      />

      {/* Delicate Accent Stroke 2 */}
      <path
        d="M0 340 C 360 260, 620 460, 980 380 C 1240 310, 1380 390, 1440 365"
        stroke="#172653"
        strokeWidth="1.2"
        strokeOpacity="0.2"
      />
    </svg>
  );
}

function TopLeftWaves() {
  return (
    <svg
      viewBox="0 0 1000 600"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className="w-full h-full"
      preserveAspectRatio="none"
    >
      <defs>
        <radialGradient id="topLeftGrad" cx="0%" cy="0%" r="80%">
          <stop offset="0%" stopColor="#E96835" stopOpacity="0.16" />
          <stop offset="50%" stopColor="#FCECDD" stopOpacity="0.35" />
          <stop offset="100%" stopColor="#F7F2E9" stopOpacity="0.0" />
        </radialGradient>
      </defs>

      <path
        d="M0 0 L 580 0 C 480 220, 240 360, 0 460 Z"
        fill="url(#topLeftGrad)"
      />

      <path
        d="M0 120 C 260 120, 420 240, 480 440"
        stroke="#E96835"
        strokeWidth="1.5"
        strokeOpacity="0.3"
      />
    </svg>
  );
}

function BottomWaves() {
  return (
    <svg
      viewBox="0 0 1440 240"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className="w-full h-full"
      preserveAspectRatio="none"
    >
      <defs>
        <linearGradient id="bottomWaveGrad" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" stopColor="#F7F2E9" stopOpacity="0" />
          <stop offset="40%" stopColor="#FCECDD" stopOpacity="0.4" />
          <stop offset="100%" stopColor="#E96835" stopOpacity="0.12" />
        </linearGradient>
      </defs>

      <path
        d="M0 90 C 280 40, 560 140, 840 70 C 1120 10, 1320 80, 1440 60 L 1440 240 L 0 240 Z"
        fill="url(#bottomWaveGrad)"
      />

      <path
        d="M0 70 C 280 20, 560 120, 840 50 C 1120 -10, 1320 60, 1440 40"
        stroke="#E96835"
        strokeWidth="1.2"
        strokeOpacity="0.25"
      />
    </svg>
  );
}

function SubtleWaves() {
  return (
    <svg
      viewBox="0 0 1200 400"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className="w-full h-full"
      preserveAspectRatio="none"
    >
      <path
        d="M0 160 C 240 100, 480 220, 720 150 C 960 80, 1100 170, 1200 140 L 1200 0 L 0 0 Z"
        fill="#FCECDD"
        fillOpacity="0.25"
      />
      <path
        d="M0 180 C 260 130, 500 240, 740 175 C 980 110, 1120 190, 1200 160"
        stroke="#E96835"
        strokeWidth="1.0"
        strokeOpacity="0.18"
      />
    </svg>
  );
}

function EditorialWaves() {
  return (
    <svg
      viewBox="0 0 1440 500"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className="w-full h-full"
      preserveAspectRatio="none"
    >
      {/* Background Arch Overlay */}
      <circle
        cx="720"
        cy="250"
        r="440"
        stroke="#E96835"
        strokeWidth="1.2"
        strokeDasharray="8 6"
        strokeOpacity="0.15"
      />
      <circle
        cx="720"
        cy="250"
        r="520"
        stroke="#172653"
        strokeWidth="1.0"
        strokeOpacity="0.1"
      />

      {/* Undulating Horizon Band */}
      <path
        d="M0 380 C 380 300, 720 440, 1080 350 C 1260 300, 1380 360, 1440 340 L 1440 500 L 0 500 Z"
        fill="#172653"
        fillOpacity="0.04"
      />
    </svg>
  );
}
