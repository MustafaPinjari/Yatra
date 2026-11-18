"use client";

import React, { useState } from "react";
import Image from "next/image";

interface AssetPlaceholderProps {
  assetId: string;
  filename?: string;
  alt: string;
  aspectRatio?: "4/5" | "16/9" | "16/10" | "21/9" | "1/1" | "4/3";
  className?: string;
  showDevBadge?: boolean;
  fallbackSvg?: React.ReactNode;
  title?: string;
}

const ASSET_REGISTRY: Record<
  string,
  { filename: string; defaultRatio: string; title: string; priority: string }
> = {
  "YATRA-ILL-001": {
    filename: "india-gate-hero.webp",
    defaultRatio: "aspect-[4/5]",
    title: "India Gate Civic Hero",
    priority: "CRITICAL",
  },
  "YATRA-ILL-002": {
    filename: "delhi-bus-isometric.webp",
    defaultRatio: "aspect-[16/10]",
    title: "Delhi Low-Floor Transit Bus",
    priority: "CRITICAL",
  },
  "YATRA-ILL-003": {
    filename: "delhi-skyline-arch.webp",
    defaultRatio: "aspect-[21/9]",
    title: "Delhi Architectural Skyline",
    priority: "HIGH",
  },
  "YATRA-ILL-004": {
    filename: "boarding-assistance-empathy.webp",
    defaultRatio: "aspect-[16/9]",
    title: "Boarding Assistance Interaction",
    priority: "CRITICAL",
  },
  "YATRA-ILL-005": {
    filename: "wheelchair-ramp-card.webp",
    defaultRatio: "aspect-square",
    title: "Wheelchair Ramp Deployment",
    priority: "HIGH",
  },
  "YATRA-ILL-006": {
    filename: "vision-support-card.webp",
    defaultRatio: "aspect-square",
    title: "Vision & Audio Support",
    priority: "HIGH",
  },
  "YATRA-ILL-007": {
    filename: "elderly-mobility-card.webp",
    defaultRatio: "aspect-square",
    title: "Elderly & Mobility Support",
    priority: "HIGH",
  },
  "YATRA-ILL-008": {
    filename: "accessible-stop-photo.webp",
    defaultRatio: "aspect-[16/9]",
    title: "AIIMS Accessible Bus Shelter",
    priority: "HIGH",
  },
  "YATRA-ILL-009": {
    filename: "delhi-dark-map-texture.webp",
    defaultRatio: "aspect-[16/10]",
    title: "Delhi Dark Fleet Map Texture",
    priority: "HIGH",
  },
  "YATRA-ILL-010": {
    filename: "govt-india-gate-engraving.webp",
    defaultRatio: "aspect-[4/3]",
    title: "India Gate Architectural Engraving",
    priority: "HIGH",
  },
  "YATRA-BRAND-001": {
    filename: "yatra-brand-symbol.svg",
    defaultRatio: "aspect-square",
    title: "YATRA Brand Symbol Mark",
    priority: "CRITICAL",
  },
  "YATRA-BRAND-002": {
    filename: "yatra-wordmark.svg",
    defaultRatio: "aspect-[4/1]",
    title: "YATRA Serif Wordmark",
    priority: "CRITICAL",
  },
};

export function AssetPlaceholder({
  assetId,
  filename,
  alt,
  aspectRatio,
  className = "",
  showDevBadge = true,
  fallbackSvg,
  title,
}: AssetPlaceholderProps) {
  const [imageError, setImageError] = useState(false);
  const info = ASSET_REGISTRY[assetId] || {
    filename: filename || `${assetId.toLowerCase()}.webp`,
    defaultRatio: "aspect-[16/9]",
    title: title || assetId,
    priority: "NORMAL",
  };

  const resolvedFilename = filename || info.filename;
  const imageSrc = `/assets/illustrations/${resolvedFilename}`;

  const ratioClass = aspectRatio
    ? aspectRatio === "4/5"
      ? "aspect-[4/5]"
      : aspectRatio === "16/9"
      ? "aspect-[16/9]"
      : aspectRatio === "16/10"
      ? "aspect-[16/10]"
      : aspectRatio === "21/9"
      ? "aspect-[21/9]"
      : aspectRatio === "1/1"
      ? "aspect-square"
      : "aspect-[4/3]"
    : info.defaultRatio;

  return (
    <div
      className={`relative overflow-hidden rounded-xl border border-[#E6DDD0] bg-[#FAF5EE] transition-all ${ratioClass} ${className}`}
      role="img"
      aria-label={alt}
    >
      {/* If an image exists and has not errored, render it */}
      {!imageError && (
        <Image
          src={imageSrc}
          alt={alt}
          fill
          sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
          className="object-cover transition-opacity duration-300"
          onError={() => setImageError(true)}
        />
      )}

      {/* Styled Editorial Fallback Illustration when physical raster asset is in production */}
      {imageError && (
        <div className="absolute inset-0 flex flex-col items-center justify-center p-6 text-center select-none bg-gradient-to-b from-[#FDF9F2] to-[#F5ECE0]">
          {fallbackSvg ? (
            <div className="w-full h-full flex items-center justify-center">
              {fallbackSvg}
            </div>
          ) : (
            <div className="flex flex-col items-center justify-center gap-2 max-w-xs">
              {/* Delicate architectural emblem graphic */}
              <div className="flex h-12 w-12 items-center justify-center rounded-full border border-[#E6DDD0] bg-[#FFFCF7] text-[#E96835] shadow-xs">
                <svg
                  className="h-6 w-6"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.5"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M3 21h18M6 21V7l6-4 6 4v14M10 21v-6h4v6" />
                </svg>
              </div>
              <h3 className="font-editorial-serif text-sm font-semibold text-[#101B3A]">
                {title || info.title}
              </h3>
              <p className="text-[11px] text-[#64748B] line-clamp-2">
                {alt}
              </p>
            </div>
          )}
        </div>
      )}

      {/* Non-intrusive Dev ID Overlay Badge */}
      {showDevBadge && (
        <div className="absolute top-2 left-2 z-10 flex items-center gap-1.5 rounded bg-[#101B3A]/85 px-2 py-0.5 text-[10px] font-mono font-medium tracking-wide text-white shadow-xs backdrop-blur-xs">
          <span>{assetId}</span>
          <span className="opacity-60">·</span>
          <span
            className={
              info.priority === "CRITICAL"
                ? "text-amber-300 font-bold"
                : "text-slate-300"
            }
          >
            {info.priority}
          </span>
        </div>
      )}
    </div>
  );
}
