"use client";

import React from "react";

interface YatraWaveSectionProps {
  children: React.ReactNode;
  dividerPosition?: "top" | "bottom" | "both" | "none";
  className?: string;
  backgroundColor?: string;
}

export function YatraWaveSection({
  children,
  dividerPosition = "bottom",
  className = "",
  backgroundColor = "bg-[#FFFCF7]",
}: YatraWaveSectionProps) {
  return (
    <section className={`relative ${backgroundColor} ${className}`}>
      {/* Top Wave Divider */}
      {(dividerPosition === "top" || dividerPosition === "both") && (
        <div className="absolute top-0 left-0 w-full overflow-hidden leading-none z-10 -translate-y-full pointer-events-none" aria-hidden="true">
          <svg
            viewBox="0 0 1200 60"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
            className="relative block w-full h-8 sm:h-12 text-[#FFFCF7]"
            preserveAspectRatio="none"
          >
            <path
              d="M0 60 C 300 10, 600 50, 900 20 C 1050 5, 1150 40, 1200 30 L 1200 60 Z"
              fill="currentColor"
            />
          </svg>
        </div>
      )}

      {/* Content Container */}
      <div className="relative z-10">{children}</div>

      {/* Bottom Wave Divider */}
      {(dividerPosition === "bottom" || dividerPosition === "both") && (
        <div className="absolute bottom-0 left-0 w-full overflow-hidden leading-none z-10 translate-y-full pointer-events-none" aria-hidden="true">
          <svg
            viewBox="0 0 1200 60"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
            className="relative block w-full h-8 sm:h-12 text-[#FFFCF7]"
            preserveAspectRatio="none"
          >
            <path
              d="M0 0 C 300 50, 600 10, 900 40 C 1050 55, 1150 20, 1200 30 L 1200 0 Z"
              fill="currentColor"
            />
          </svg>
        </div>
      )}
    </section>
  );
}

