import React from "react";

interface YatraBrandLogoProps {
  size?: "sm" | "md" | "lg" | "xl";
  showTagline?: boolean;
  variant?: "navy" | "light";
  className?: string;
}

export function YatraBrandLogo({
  size = "md",
  showTagline = false,
  variant = "navy",
  className = "",
}: YatraBrandLogoProps) {
  const isLight = variant === "light";

  const sizeStyles = {
    sm: { symbol: "h-7 w-7", text: "text-lg", tag: "text-[10px]" },
    md: { symbol: "h-9 w-9", text: "text-2xl", tag: "text-xs" },
    lg: { symbol: "h-12 w-12", text: "text-3xl", tag: "text-xs" },
    xl: { symbol: "h-16 w-16", text: "text-4xl", tag: "text-sm" },
  };

  const currentSize = sizeStyles[size];

  return (
    <div className={`flex items-center gap-3 select-none ${className}`}>
      {/* YATRA-BRAND-001: Symbol Mark */}
      <div
        className={`relative flex ${currentSize.symbol} items-center justify-center rounded-xl transition-transform hover:scale-105 shadow-xs ${
          isLight ? "bg-[#FFFCF7] text-[#101B3A]" : "bg-[#172653] text-[#FFFCF7]"
        }`}
        aria-hidden="true"
      >
        <svg
          viewBox="0 0 48 48"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          className="h-3/4 w-3/4"
        >
          {/* Monumental archway loop */}
          <path
            d="M12 40V24C12 17.3726 17.3726 12 24 12C30.6274 12 36 17.3726 36 24V40"
            stroke="currentColor"
            strokeWidth="3.5"
            strokeLinecap="round"
          />
          {/* Central sun / mobility hub in terracotta */}
          <circle cx="24" cy="24" r="5" fill="#E96835" />
          {/* Accessible horizontal pathway */}
          <path
            d="M6 40H42"
            stroke={isLight ? "#101B3A" : "#F7F2E9"}
            strokeWidth="3"
            strokeLinecap="round"
          />
          {/* Wheel transit spokes */}
          <circle
            cx="24"
            cy="24"
            r="8.5"
            stroke="#F07835"
            strokeWidth="1.5"
            strokeDasharray="2 3"
          />
        </svg>
      </div>

      {/* YATRA-BRAND-002: Wordmark */}
      <div className="flex flex-col">
        <div className="flex items-baseline gap-2">
          <span
            className={`font-editorial-serif font-black tracking-tight leading-none ${currentSize.text} ${
              isLight ? "text-white" : "text-[#101B3A]"
            }`}
          >
            YATRA
          </span>
          <span
            className={`font-ui-sans uppercase tracking-widest text-[9px] font-bold px-1.5 py-0.5 rounded ${
              isLight
                ? "bg-[#E96835] text-white"
                : "bg-[#E4F1E5] text-[#16764C] border border-[#16764C]/20"
            }`}
          >
            Delhi Transit
          </span>
        </div>
        {showTagline && (
          <p
            className={`mt-1 font-ui-sans tracking-wide text-[#64748B] ${currentSize.tag}`}
          >
            Your Accessible Transport & Reliable Assistance Platform
          </p>
        )}
      </div>
    </div>
  );
}

