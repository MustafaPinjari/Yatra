"use client";

import React, { useState } from "react";
import { YatraBrandLogo } from "@/components/brand/YatraBrandLogo";
import { AssetPlaceholder } from "@/components/AssetPlaceholder";
import { DelhiSkylineSvg } from "@/components/illustrations/DelhiSkylineSvg";
import { DelhiBusHeroSvg } from "@/components/illustrations/DelhiBusHeroSvg";
import {
  Search,
  MapPin,
  Accessibility,
  ArrowRight,
  Route,
  Radio,
  Map,
  Compass,
} from "lucide-react";

interface PassengerHomeScreenProps {
  onNavigateTab: (tab: string) => void;
}

export function PassengerHomeScreen({ onNavigateTab }: PassengerHomeScreenProps) {
  const [searchQuery, setSearchQuery] = useState("");

  const quickActions = [
    {
      id: "planner",
      title: "Plan Trip",
      subtitle: "Step-free accessible routing",
      icon: Route,
      badge: "Crowd-Aware",
      accent: "bg-[#E4F1E5] text-[#16764C] border-[#16764C]/30",
    },
    {
      id: "tracking",
      title: "Live Buses",
      subtitle: "Route 502 & Ring Road telemetry",
      icon: Compass,
      badge: "Live GPS",
      accent: "bg-[#EEF2FF] text-[#4F46E5] border-[#4F46E5]/30",
    },
    {
      id: "assistance",
      title: "Assistance",
      subtitle: "Driver pre-stop handshake",
      icon: Radio,
      badge: "Handshake",
      accent: "bg-[#FCECDD] text-[#E96835] border-[#E96835]/30",
    },
    {
      id: "stops",
      title: "Accessible Stops",
      subtitle: "Ramps & tactile paving graph",
      icon: Accessibility,
      badge: "AccessGraph",
      accent: "bg-[#FEF3C7] text-[#B45309] border-[#B45309]/30",
    },
  ];

  return (
    <div className="min-h-full flex flex-col justify-between max-w-xl mx-auto bg-[#F7F2E9] border-x border-[#E6DDD0] shadow-sm pb-20 sm:pb-8">
      {/* 1. Header Bar: Brand & City Selector */}
      <header className="sticky top-0 z-30 flex items-center justify-between px-5 py-4 bg-[#FFFCF7]/95 backdrop-blur-xs border-b border-[#E6DDD0]">
        <YatraBrandLogo size="sm" />
        <div className="flex items-center gap-1.5 rounded-full border border-[#E6DDD0] bg-[#F7F2E9] px-3 py-1 text-xs font-semibold text-[#101B3A]">
          <MapPin className="h-3.5 w-3.5 text-[#E96835]" />
          <span>New Delhi ▾</span>
        </div>
      </header>

      {/* 2. Welcome & Architectural Skyline Masthead */}
      <section className="px-5 pt-5 pb-3">
        <div className="flex items-baseline justify-between">
          <div>
            <p className="text-xs font-semibold uppercase tracking-wider text-[#E96835]">
              Universal Passenger Interface
            </p>
            <h1 className="font-editorial-serif text-2xl sm:text-3xl font-bold text-[#101B3A]">
              Namaste, Sunita
            </h1>
          </div>
          <span className="rounded-full bg-[#E4F1E5] px-2.5 py-0.5 text-[11px] font-semibold text-[#16764C]">
            Wheelchair Ramp Priority
          </span>
        </div>

        {/* Delhi Skyline Silhouette (`YATRA-ILL-003`) */}
        <div className="mt-3">
          <AssetPlaceholder
            assetId="YATRA-ILL-003"
            filename="delhi-skyline-arch.webp"
            alt="Silhouette banner of Delhi landmarks including Qutub Minar, Lotus Temple and India Gate"
            aspectRatio="21/9"
            className="rounded-xl border border-[#E6DDD0] bg-[#FFFCF7]"
            fallbackSvg={<DelhiSkylineSvg />}
            title="Delhi Architectural Horizon"
          />
        </div>
      </section>

      {/* 3. Search Bar for Destination */}
      <section className="px-5 py-2">
        <div className="relative flex items-center">
          <Search className="absolute left-3.5 h-4 w-4 text-[#64748B]" aria-hidden="true" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Where would you like to travel in Delhi?"
            className="w-full rounded-xl border border-[#E6DDD0] bg-[#FFFCF7] py-3 pl-10 pr-4 text-sm text-[#101B3A] placeholder-[#94A3B8] shadow-xs focus:border-[#E96835] focus:outline-hidden focus:ring-1 focus:ring-[#E96835]"
          />
        </div>
      </section>

      {/* 4. Four Core Action Tiles */}
      <section className="px-5 py-3">
        <h2 className="text-xs font-bold uppercase tracking-wider text-[#64748B] mb-2.5">
          Transit Services
        </h2>
        <div className="grid grid-cols-2 gap-3">
          {quickActions.map((action) => {
            const Icon = action.icon;
            return (
              <button
                key={action.id}
                onClick={() => onNavigateTab(action.id)}
                className="flex flex-col text-left p-3.5 rounded-xl border border-[#E6DDD0] bg-[#FFFCF7] hover:bg-white hover:border-[#CBD5E1] transition-all shadow-subtle group cursor-pointer"
              >
                <div className="flex items-center justify-between w-full">
                  <div className={`p-2 rounded-lg border ${action.accent}`}>
                    <Icon className="h-4 w-4" aria-hidden="true" />
                  </div>
                  <span className="text-[10px] font-semibold text-[#64748B]">
                    {action.badge}
                  </span>
                </div>
                <div className="mt-3">
                  <h3 className="font-editorial-serif text-base font-bold text-[#101B3A] group-hover:text-[#E96835] transition-colors">
                    {action.title}
                  </h3>
                  <p className="text-[11px] text-[#64748B] line-clamp-1 mt-0.5">
                    {action.subtitle}
                  </p>
                </div>
              </button>
            );
          })}
        </div>
      </section>

      {/* 5. Nearest Approaching Bus Section */}
      <section className="px-5 py-3">
        <div className="flex items-center justify-between mb-2">
          <h2 className="text-xs font-bold uppercase tracking-wider text-[#64748B]">
            Approaching Nearest Stop: AIIMS
          </h2>
          <span className="flex items-center gap-1 text-xs font-semibold text-[#16764C]">
            <span className="h-1.5 w-1.5 rounded-full bg-[#16764C] animate-ping" />
            Live Telemetry
          </span>
        </div>

        {/* Card with Route, Arrival, and Bus Illustration (`YATRA-ILL-002`) */}
        <div className="rounded-xl border border-[#E6DDD0] bg-[#FFFCF7] p-4 shadow-editorial space-y-3">
          <div className="flex items-start justify-between">
            <div>
              <div className="flex items-center gap-2">
                <span className="rounded bg-[#172653] px-2 py-0.5 text-xs font-bold text-white">
                  ROUTE 502
                </span>
                <span className="text-xs font-medium text-[#101B3A]">
                  Mehrauli ⟷ Kashmere Gate
                </span>
              </div>
              <p className="mt-1 font-editorial-serif text-2xl font-bold text-[#101B3A]">
                3 mins away
              </p>
              <p className="text-xs text-[#64748B]">Vehicle DL 1PD 4421 · Bay 2</p>
            </div>

            <div className="text-right space-y-1">
              <span className="inline-block rounded-full bg-[#E4F1E5] px-2.5 py-0.5 text-xs font-semibold text-[#16764C]">
                Low Crowding (24%)
              </span>
              <p className="text-[11px] font-medium text-[#E96835]">
                ✓ Hydraulic Ramp Verified
              </p>
            </div>
          </div>

          {/* Isometric Bus Illustration */}
          <AssetPlaceholder
            assetId="YATRA-ILL-002"
            filename="delhi-bus-isometric.webp"
            alt="3/4 Isometric rendering of Delhi green low-floor electric bus with deployed ramp flush to curb"
            aspectRatio="16/10"
            className="rounded-lg border border-[#E6DDD0]"
            fallbackSvg={<DelhiBusHeroSvg />}
            title="Delhi Electric Low-Floor Bus"
          />

          {/* Quick Action to Initiate Handshake */}
          <button
            onClick={() => onNavigateTab("assistance")}
            className="w-full flex items-center justify-between rounded-lg bg-[#E96835] hover:bg-[#D95724] px-4 py-2.5 text-xs font-bold text-white shadow-xs transition-colors cursor-pointer"
          >
            <span>Signal Driver for Boarding Assistance</span>
            <ArrowRight className="h-4 w-4" />
          </button>
        </div>
      </section>

      {/* 6. Sticky Bottom Navigation Bar */}
      <nav
        aria-label="Mobile Navigation"
        className="fixed sm:static bottom-0 left-0 right-0 z-40 flex items-center justify-around border-t border-[#E6DDD0] bg-[#FFFCF7] px-2 py-2.5 max-w-xl mx-auto"
      >
        <button
          onClick={() => onNavigateTab("home")}
          className="flex flex-col items-center gap-1 text-[#E96835] font-semibold text-[11px] p-1"
        >
          <MapPin className="h-5 w-5" />
          <span>Home</span>
        </button>
        <button
          onClick={() => onNavigateTab("planner")}
          className="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#101B3A] text-[11px] p-1"
        >
          <Route className="h-5 w-5" />
          <span>Plan</span>
        </button>
        <button
          onClick={() => onNavigateTab("tracking")}
          className="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#101B3A] text-[11px] p-1"
        >
          <Compass className="h-5 w-5" />
          <span>Live</span>
        </button>
        <button
          onClick={() => onNavigateTab("assistance")}
          className="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#101B3A] text-[11px] p-1"
        >
          <Radio className="h-5 w-5" />
          <span>Assist</span>
        </button>
        <button
          onClick={() => onNavigateTab("stops")}
          className="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#101B3A] text-[11px] p-1"
        >
          <Map className="h-5 w-5" />
          <span>Stops</span>
        </button>
      </nav>
    </div>
  );
}
