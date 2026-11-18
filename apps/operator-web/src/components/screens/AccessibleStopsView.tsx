"use client";

import React, { useState } from "react";
import { AssetPlaceholder } from "@/components/AssetPlaceholder";
import {
  Accessibility,
  Eye,
  Volume2,
  ShieldCheck,
  CheckCircle2,
  Filter,
  ArrowRight,
} from "lucide-react";

export function AccessibleStopsView() {
  const [filterRamp, setFilterRamp] = useState(true);
  const [filterTactile, setFilterTactile] = useState(false);
  const [filterAudio, setFilterAudio] = useState(false);

  const stops = [
    {
      id: "DEL_STP_502_04",
      name: "AIIMS Metro Station (Bay 2)",
      score: 96,
      ramp: true,
      tactile: true,
      audio: true,
      curbHeight: "14.5 cm (Flush)",
      shelter: true,
      lat: 28.5684,
      lng: 77.2078,
    },
    {
      id: "DEL_STP_502_01",
      name: "Kashmere Gate ISBT",
      score: 92,
      ramp: true,
      tactile: true,
      audio: true,
      curbHeight: "15.0 cm (Level)",
      shelter: true,
      lat: 28.6675,
      lng: 77.2285,
    },
    {
      id: "DEL_STP_502_02",
      name: "Red Fort (Lal Qila)",
      score: 78,
      ramp: true,
      tactile: false,
      audio: false,
      curbHeight: "18.0 cm (Low Step)",
      shelter: true,
      lat: 28.6562,
      lng: 77.2410,
    },
    {
      id: "DEL_STP_502_03",
      name: "Delhi Gate",
      score: 65,
      ramp: false,
      tactile: false,
      audio: false,
      curbHeight: "25.0 cm (High Curb)",
      shelter: true,
      lat: 28.6415,
      lng: 77.2405,
    },
  ];

  const selectedStop = stops[0];

  return (
    <div className="max-w-5xl mx-auto p-4 sm:p-6 space-y-6">
      {/* Editorial Heading */}
      <div className="space-y-1">
        <span className="text-xs font-semibold tracking-wider uppercase text-[#E96835]">
          AccessGraph Pedestrian Infrastructure
        </span>
        <h1 className="font-editorial-serif text-3xl sm:text-4xl font-bold text-[#101B3A]">
          Accessible Bus Stops
        </h1>
        <p className="text-xs text-[#64748B]">
          Audited stop-level micro-accessibility graph mapping curb heights, wheelchair ramps, tactile paths, and audio beacons.
        </p>
      </div>

      {/* Filter Chips Bar */}
      <div className="flex flex-wrap items-center gap-2 pt-1">
        <span className="text-xs font-bold text-[#101B3A] flex items-center gap-1.5 mr-2">
          <Filter className="h-3.5 w-3.5 text-[#E96835]" /> Filter Infrastructure:
        </span>
        <button
          onClick={() => setFilterRamp(!filterRamp)}
          className={`rounded-full px-3 py-1 text-xs font-semibold flex items-center gap-1.5 border cursor-pointer transition-colors ${
            filterRamp
              ? "bg-[#E4F1E5] text-[#16764C] border-[#16764C]/40"
              : "bg-[#FFFCF7] text-[#64748B] border-[#E6DDD0]"
          }`}
        >
          <Accessibility className="h-3.5 w-3.5" />
          <span>Wheelchair Ramp</span>
        </button>
        <button
          onClick={() => setFilterTactile(!filterTactile)}
          className={`rounded-full px-3 py-1 text-xs font-semibold flex items-center gap-1.5 border cursor-pointer transition-colors ${
            filterTactile
              ? "bg-[#E4F1E5] text-[#16764C] border-[#16764C]/40"
              : "bg-[#FFFCF7] text-[#64748B] border-[#E6DDD0]"
          }`}
        >
          <Eye className="h-3.5 w-3.5" />
          <span>Tactile Paving</span>
        </button>
        <button
          onClick={() => setFilterAudio(!filterAudio)}
          className={`rounded-full px-3 py-1 text-xs font-semibold flex items-center gap-1.5 border cursor-pointer transition-colors ${
            filterAudio
              ? "bg-[#E4F1E5] text-[#16764C] border-[#16764C]/40"
              : "bg-[#FFFCF7] text-[#64748B] border-[#E6DDD0]"
          }`}
        >
          <Volume2 className="h-3.5 w-3.5" />
          <span>Audio Beacon</span>
        </button>
      </div>

      {/* Main Split View: Map Overview + Stop Detail Card */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left: Stop Map with Markers */}
        <div className="lg:col-span-7 h-[420px] rounded-2xl border-2 border-[#E6DDD0] bg-[#FAF5EE] overflow-hidden relative shadow-editorial">
          <svg
            viewBox="0 0 600 420"
            className="w-full h-full object-cover"
            xmlns="http://www.w3.org/2000/svg"
          >
            {/* Cartographic Background Grid */}
            <g stroke="#EAE0D2" strokeWidth="1.5">
              <line x1="100" y1="0" x2="100" y2="420" />
              <line x1="250" y1="0" x2="250" y2="420" />
              <line x1="400" y1="0" x2="400" y2="420" />
              <line x1="550" y1="0" x2="550" y2="420" />
              <line x1="0" y1="100" x2="600" y2="100" />
              <line x1="0" y1="220" x2="600" y2="220" />
              <line x1="0" y1="340" x2="600" y2="340" />
            </g>

            {/* Connecting Road Line */}
            <path
              d="M100 80 Q 250 200, 360 250 T 520 360"
              stroke="#D4C5B0"
              strokeWidth="8"
              fill="none"
              strokeLinecap="round"
            />

            {/* Custom Accessibility Markers */}
            {stops.map((stop, i) => {
              const cx = 100 + i * 130;
              const cy = 80 + i * 90;
              const isSelected = stop.id === selectedStop.id;

              return (
                <g key={stop.id} transform={`translate(${cx}, ${cy})`}>
                  {isSelected && (
                    <circle cx="0" cy="0" r="28" fill="#16764C" opacity="0.15" className="animate-pulse" />
                  )}
                  <circle
                    cx="0"
                    cy="0"
                    r="16"
                    fill={stop.score >= 90 ? "#16764C" : stop.score >= 75 ? "#D97706" : "#DC2626"}
                    stroke="#FFFFFF"
                    strokeWidth="3"
                  />
                  <text
                    x="0"
                    y="4"
                    fill="#FFFFFF"
                    fontSize="10"
                    fontWeight="bold"
                    textAnchor="middle"
                  >
                    {stop.score}
                  </text>
                  <text
                    x="0"
                    y="32"
                    fill="#101B3A"
                    fontSize="11"
                    fontWeight="bold"
                    textAnchor="middle"
                  >
                    {stop.name.split(" ")[0]}
                  </text>
                </g>
              );
            })}
          </svg>

          {/* Map Legend Floating Box */}
          <div className="absolute bottom-3 left-3 bg-[#FFFCF7]/95 border border-[#E6DDD0] rounded-lg p-2.5 text-[11px] space-y-1 backdrop-blur-xs">
            <span className="font-bold text-[#101B3A]">AccessGraph Rating:</span>
            <div className="flex items-center gap-3">
              <span className="flex items-center gap-1"><span className="h-2.5 w-2.5 rounded-full bg-[#16764C]" /> 90-100 (Full Access)</span>
              <span className="flex items-center gap-1"><span className="h-2.5 w-2.5 rounded-full bg-[#D97706]" /> 70-89 (Partial)</span>
              <span className="flex items-center gap-1"><span className="h-2.5 w-2.5 rounded-full bg-[#DC2626]" /> &lt;70 (Low)</span>
            </div>
          </div>
        </div>

        {/* Right: Selected Stop Detail Panel */}
        <div className="lg:col-span-5 rounded-2xl border-2 border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial space-y-4">
          <div className="flex items-start justify-between">
            <div>
              <span className="font-mono text-xs text-[#64748B]">{selectedStop.id}</span>
              <h2 className="font-editorial-serif text-xl font-bold text-[#101B3A]">
                {selectedStop.name}
              </h2>
            </div>
            <div className="text-right">
              <div className="inline-flex items-center gap-1 rounded-full bg-[#E4F1E5] px-2.5 py-1 text-xs font-bold text-[#16764C]">
                <ShieldCheck className="h-4 w-4" /> Score: {selectedStop.score}/100
              </div>
            </div>
          </div>

          {/* Stop Photo / Illustration (`YATRA-ILL-008`) */}
          <AssetPlaceholder
            assetId="YATRA-ILL-008"
            filename="accessible-stop-photo.webp"
            alt="Audited photo of modern accessible Delhi bus shelter at AIIMS Metro with tactile paving and stainless steel ramp"
            aspectRatio="16/9"
            className="rounded-xl border border-[#E6DDD0]"
            title="AIIMS Accessible Shelter & Ramp"
          />

          {/* Feature Breakdown Table */}
          <div className="space-y-2 pt-2 border-t border-[#E6DDD0] text-xs">
            <div className="flex items-center justify-between py-1.5 border-b border-[#FAF5EE]">
              <span className="text-[#64748B] flex items-center gap-1.5">
                <Accessibility className="h-3.5 w-3.5 text-[#16764C]" /> Curb Height & Incline
              </span>
              <span className="font-bold text-[#101B3A]">{selectedStop.curbHeight}</span>
            </div>

            <div className="flex items-center justify-between py-1.5 border-b border-[#FAF5EE]">
              <span className="text-[#64748B] flex items-center gap-1.5">
                <Eye className="h-3.5 w-3.5 text-[#16764C]" /> Tactile Directional Path
              </span>
              <span className="font-bold text-[#16764C] flex items-center gap-1">
                <CheckCircle2 className="h-3 w-3" /> Fully Installed
              </span>
            </div>

            <div className="flex items-center justify-between py-1.5 border-b border-[#FAF5EE]">
              <span className="text-[#64748B] flex items-center gap-1.5">
                <Volume2 className="h-3.5 w-3.5 text-[#16764C]" /> Audible Stop Beacon
              </span>
              <span className="font-bold text-[#16764C] flex items-center gap-1">
                <CheckCircle2 className="h-3 w-3" /> Operational
              </span>
            </div>

            <div className="flex items-center justify-between py-1.5">
              <span className="text-[#64748B]">Covered Shelter & Lighting</span>
              <span className="font-bold text-[#101B3A]">Installed (Solar LED)</span>
            </div>
          </div>

          {/* Plan Route to Stop CTA */}
          <button className="w-full flex items-center justify-center gap-2 rounded-xl bg-[#172653] hover:bg-[#101B3A] py-3 text-xs font-bold text-white shadow-xs transition-colors cursor-pointer">
            <span>Route Accessible Trip to this Stop</span>
            <ArrowRight className="h-3.5 w-3.5" />
          </button>
        </div>
      </div>
    </div>
  );
}
