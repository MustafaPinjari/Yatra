"use client";

import React from "react";
import { YatraBrandLogo } from "@/components/brand/YatraBrandLogo";
import { AssetPlaceholder } from "@/components/AssetPlaceholder";
import { IndiaGateHeroSvg } from "@/components/illustrations/IndiaGateHeroSvg";
import { ArrowRight, Sparkles, Compass } from "lucide-react";

interface IntroScreenProps {
  onExplore: () => void;
}

export function IntroScreen({ onExplore }: IntroScreenProps) {
  return (
    <div className="min-h-full flex flex-col justify-between p-6 sm:p-10 max-w-4xl mx-auto">
      {/* Top Bar: Brand & City */}
      <header className="flex items-center justify-between pb-6 border-b border-[#E6DDD0]">
        <YatraBrandLogo size="md" />
        <div className="flex items-center gap-2 rounded-full border border-[#E6DDD0] bg-[#FFFCF7] px-3 py-1 text-xs font-semibold text-[#101B3A] shadow-xs">
          <span className="h-2 w-2 rounded-full bg-[#16764C]" />
          <span>NCT Delhi Transit Zone</span>
        </div>
      </header>

      {/* Main Editorial Hero Section */}
      <main className="my-auto py-8 grid grid-cols-1 md:grid-cols-12 gap-8 items-center">
        {/* Left Column: Headlines & Editorial Copy */}
        <div className="md:col-span-6 space-y-6">
          <div className="inline-flex items-center gap-2 rounded-full bg-[#E4F1E5] px-3 py-1 text-xs font-semibold text-[#16764C]">
            <Sparkles className="h-3.5 w-3.5 text-[#16764C]" />
            <span>Accessible Public Bus Network</span>
          </div>

          <div className="space-y-3">
            <h1 className="font-editorial-serif text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tight text-[#101B3A] leading-[1.08]">
              Move Delhi <br />
              <span className="italic font-normal text-[#E96835]">Together.</span>
            </h1>
            <p className="font-ui-sans text-sm sm:text-base text-[#64748B] font-medium tracking-wide">
              Accessible · Inclusive · Reliable
            </p>
          </div>

          <p className="text-sm text-[#475569] leading-relaxed max-w-md">
            Connecting commuters with disabilities, daily passengers, and transit drivers
            on India&apos;s first universal micro-accessibility and real-time boarding platform.
          </p>

          <div className="pt-2 flex flex-col sm:flex-row items-stretch sm:items-center gap-3">
            <button
              onClick={onExplore}
              className="inline-flex items-center justify-center gap-2.5 rounded-xl bg-[#E96835] hover:bg-[#D95724] px-6 py-3.5 text-sm font-bold text-white shadow-sm transition-all hover:shadow-md cursor-pointer"
            >
              <span>Explore Passenger Experience</span>
              <ArrowRight className="h-4 w-4" />
            </button>
            <div className="flex items-center justify-center gap-2 text-xs font-semibold text-[#101B3A] px-3 py-2">
              <Compass className="h-4 w-4 text-[#16764C]" />
              <span>Route 502 & TMS Live</span>
            </div>
          </div>
        </div>

        {/* Right Column: Architectural Hero Illustration */}
        <div className="md:col-span-6 relative">
          {/* Organic Terracotta Arc Element */}
          <div className="absolute -top-6 -right-6 w-48 h-48 rounded-full bg-[#FCECDD] opacity-60 filter blur-xl -z-10" />

          {/* Asset Placeholder mounted for YATRA-ILL-001 with custom SVG fallback */}
          <AssetPlaceholder
            assetId="YATRA-ILL-001"
            filename="india-gate-hero.webp"
            alt="Editorial illustration of India Gate under warm sky with green low-floor Delhi transit bus in foreground"
            aspectRatio="4/5"
            className="shadow-editorial rounded-2xl border-2 border-[#E6DDD0]"
            fallbackSvg={<IndiaGateHeroSvg />}
            title="India Gate & Delhi Transit Fleet"
          />
        </div>
      </main>

      {/* Footer Features Strip */}
      <footer className="pt-6 border-t border-[#E6DDD0] grid grid-cols-3 gap-4 text-center">
        <div className="space-y-1">
          <p className="font-editorial-serif text-lg font-bold text-[#101B3A]">100%</p>
          <p className="text-xs text-[#64748B]">Low-Floor Filter</p>
        </div>
        <div className="space-y-1 border-x border-[#E6DDD0]">
          <p className="font-editorial-serif text-lg font-bold text-[#E96835]">Redis WSS</p>
          <p className="text-xs text-[#64748B]">Driver Handshake</p>
        </div>
        <div className="space-y-1">
          <p className="font-editorial-serif text-lg font-bold text-[#16764C]">WCAG 2.2</p>
          <p className="text-xs text-[#64748B]">AA Universal A11y</p>
        </div>
      </footer>
    </div>
  );
}
