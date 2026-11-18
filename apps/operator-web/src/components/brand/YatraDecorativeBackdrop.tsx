"use client";

import React from "react";

interface YatraDecorativeBackdropProps {
  variant?: "arch" | "rings" | "contour";
  className?: string;
  children?: React.ReactNode;
}

export function YatraDecorativeBackdrop({
  variant = "arch",
  className = "",
  children,
}: YatraDecorativeBackdropProps) {
  return (
    <div className={`relative ${className}`}>
      {/* Decorative Geometry */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none z-0" aria-hidden="true">
        {variant === "arch" && (
          <svg viewBox="0 0 400 400" fill="none" className="absolute -top-16 -right-16 w-80 h-80 opacity-40">
            <path
              d="M100 350 V180 C100 124 144 80 200 80 C256 80 300 124 300 180 V350"
              stroke="#E96835"
              strokeWidth="2.5"
              strokeDasharray="8 6"
            />
            <path
              d="M120 350 V190 C120 146 156 110 200 110 C244 110 280 146 280 190 V350"
              stroke="#172653"
              strokeWidth="1.5"
            />
            <circle cx="200" cy="190" r="16" fill="#FCECDD" />
          </svg>
        )}

        {variant === "rings" && (
          <svg viewBox="0 0 500 500" fill="none" className="absolute -bottom-20 -left-20 w-96 h-96 opacity-35">
            <circle cx="250" cy="250" r="220" stroke="#E96835" strokeWidth="1.5" strokeDasharray="6 4" />
            <circle cx="250" cy="250" r="170" stroke="#172653" strokeWidth="1.2" />
            <circle cx="250" cy="250" r="120" stroke="#16764C" strokeWidth="1.0" strokeOpacity="0.4" />
          </svg>
        )}

        {variant === "contour" && (
          <svg viewBox="0 0 600 300" fill="none" className="absolute bottom-0 right-0 w-full h-48 opacity-30">
            <path d="M0 240 Q 150 180 300 220 T 600 200" stroke="#E96835" strokeWidth="1.5" />
            <path d="M0 260 Q 150 200 300 240 T 600 220" stroke="#172653" strokeWidth="1.2" />
          </svg>
        )}
      </div>

      <div className="relative z-10">{children}</div>
    </div>
  );
}
