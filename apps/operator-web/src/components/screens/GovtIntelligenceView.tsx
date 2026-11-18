"use client";

import React from "react";
import { AssetPlaceholder } from "@/components/AssetPlaceholder";
import {
  TrendingUp,
  ShieldCheck,
  CheckCircle2,
  Sparkles,
} from "lucide-react";

export function GovtIntelligenceView() {
  const coverageBreakdown = [
    { label: "Wheelchair Ramps & Flush Curbs", percentage: 78, color: "bg-[#16764C]" },
    { label: "Tactile Directional Paving", percentage: 64, color: "bg-[#E96835]" },
    { label: "Audio Beacon Announcements", percentage: 52, color: "bg-[#172653]" },
    { label: "Covered Shelters & Braille", percentage: 89, color: "bg-[#059669]" },
  ];

  const weeklyTrend = [
    { day: "Mon", requests: 184, resolved: 180 },
    { day: "Tue", requests: 210, resolved: 206 },
    { day: "Wed", requests: 242, resolved: 238 },
    { day: "Thu", requests: 228, resolved: 225 },
    { day: "Fri", requests: 275, resolved: 271 },
    { day: "Sat", requests: 160, resolved: 158 },
    { day: "Sun", requests: 121, resolved: 120 },
  ];

  return (
    <div className="max-w-5xl mx-auto p-4 sm:p-8 space-y-8 bg-[#F7F2E9]">
      {/* 1. Classical Government Header with Brand and India Gate Engraving */}
      <header className="flex flex-col sm:flex-row items-start sm:items-center justify-between pb-6 border-b border-[#E6DDD0] gap-4">
        <div>
          <div className="flex items-center gap-2 mb-2">
            <span className="rounded bg-[#172653] px-2 py-0.5 text-[10px] font-bold text-white uppercase tracking-widest">
              Department of Transport
            </span>
            <span className="text-xs text-[#64748B]">Government of NCT of Delhi</span>
          </div>
          <h1 className="font-editorial-serif text-3xl sm:text-4xl font-black text-[#101B3A]">
            Delhi Mobility & Accessibility Intelligence
          </h1>
          <p className="font-ui-sans text-xs text-[#64748B] mt-1">
            Aggregated municipal audit metrics and accessibility compliance under Delhi Transit Stack
          </p>
        </div>

        {/* Engraving Icon Placeholder (`YATRA-ILL-010`) */}
        <div className="w-24 h-24 sm:w-28 sm:h-28 flex-shrink-0">
          <AssetPlaceholder
            assetId="YATRA-ILL-010"
            filename="govt-india-gate-engraving.webp"
            alt="Classical architectural engraving of India Gate on cream parchment"
            aspectRatio="1/1"
            className="rounded-xl border border-[#E6DDD0] bg-[#FFFCF7]"
            title="India Gate Engraving"
          />
        </div>
      </header>

      {/* 2. Four Headline Analytical Metrics (Large Serif Numerals) */}
      <section aria-label="Core Municipal Metrics" className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial space-y-2">
          <span className="text-xs font-semibold text-[#64748B] uppercase tracking-wider">
            Network Reliability
          </span>
          <div className="flex items-baseline gap-1">
            <span className="font-editorial-serif text-4xl font-bold text-[#101B3A]">94.2</span>
            <span className="font-editorial-serif text-xl font-normal text-[#16764C]">%</span>
          </div>
          <p className="text-[11px] text-[#16764C] font-semibold flex items-center gap-1">
            <TrendingUp className="h-3.5 w-3.5" /> +1.8% over last quarter
          </p>
        </div>

        <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial space-y-2">
          <span className="text-xs font-semibold text-[#64748B] uppercase tracking-wider">
            AccessGraph Rating
          </span>
          <div className="flex items-baseline gap-1">
            <span className="font-editorial-serif text-4xl font-bold text-[#101B3A]">87.4</span>
            <span className="text-xs font-semibold text-[#64748B]">/100</span>
          </div>
          <p className="text-[11px] text-[#64748B]">
            420 Stops Audited & Scored
          </p>
        </div>

        <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial space-y-2">
          <span className="text-xs font-semibold text-[#64748B] uppercase tracking-wider">
            Daily Ridership
          </span>
          <div className="flex items-baseline gap-1">
            <span className="font-editorial-serif text-4xl font-bold text-[#101B3A]">4.28</span>
            <span className="font-editorial-serif text-xl font-normal text-[#101B3A]">M</span>
          </div>
          <p className="text-[11px] text-[#64748B]">
            ETM Electronic Ticket Validation
          </p>
        </div>

        <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial space-y-2">
          <span className="text-xs font-semibold text-[#64748B] uppercase tracking-wider">
            Assistance Fulfilled
          </span>
          <div className="flex items-baseline gap-1">
            <span className="font-editorial-serif text-4xl font-bold text-[#E96835]">1,420</span>
          </div>
          <p className="text-[11px] text-[#16764C] font-semibold flex items-center gap-1">
            <CheckCircle2 className="h-3.5 w-3.5" /> 98.6% Completion Rate
          </p>
        </div>
      </section>

      {/* 3. Analytical Charts Grid: Coverage Breakdown + Weekly Assistance Trend */}
      <section className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left: Infrastructure Coverage Bars */}
        <div className="lg:col-span-6 rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial space-y-5">
          <div className="flex items-center justify-between border-b border-[#E6DDD0] pb-3">
            <div>
              <h2 className="font-editorial-serif text-xl font-bold text-[#101B3A]">
                Bus Stop Accessibility Coverage
              </h2>
              <p className="text-xs text-[#64748B]">Physical infrastructure audit across 15 transit corridors</p>
            </div>
            <span className="rounded bg-[#E4F1E5] px-2 py-0.5 text-xs font-bold text-[#16764C]">
              WCAG 2.2 AA Target
            </span>
          </div>

          <div className="space-y-4 pt-1">
            {coverageBreakdown.map((item) => (
              <div key={item.label} className="space-y-1.5">
                <div className="flex items-center justify-between text-xs">
                  <span className="font-semibold text-[#101B3A]">{item.label}</span>
                  <span className="font-mono font-bold text-[#101B3A]">{item.percentage}%</span>
                </div>
                <div className="w-full bg-[#FAF5EE] rounded-full h-2.5 overflow-hidden border border-[#E6DDD0]">
                  <div
                    className={`h-full ${item.color} rounded-full transition-all duration-500`}
                    style={{ width: `${item.percentage}%` }}
                  />
                </div>
              </div>
            ))}
          </div>

          <div className="p-3 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0] text-xs text-[#64748B] flex items-start gap-2">
            <Sparkles className="h-4 w-4 text-[#E96835] flex-shrink-0 mt-0.5" />
            <p>
              <strong>Transport Authority Insight:</strong> Corridors along outer Ring Road require 22 additional tactile blister paving curb cuts to achieve complete level boarding parity.
            </p>
          </div>
        </div>

        {/* Right: Weekly Assistance Request Volume Bar Chart */}
        <div className="lg:col-span-6 rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial space-y-5 flex flex-col justify-between">
          <div className="flex items-center justify-between border-b border-[#E6DDD0] pb-3">
            <div>
              <h2 className="font-editorial-serif text-xl font-bold text-[#101B3A]">
                Weekly Assistance Handshakes
              </h2>
              <p className="text-xs text-[#64748B]">Requests initiated vs successfully completed</p>
            </div>
            <span className="text-xs font-mono font-bold text-[#E96835]">
              Total: 1,420
            </span>
          </div>

          {/* Pure CSS Bar Chart with Delicate Architectural Proportions */}
          <div className="h-44 flex items-end justify-between gap-3 pt-6 px-2">
            {weeklyTrend.map((t) => {
              const heightPct = Math.round((t.requests / 300) * 100);

              return (
                <div key={t.day} className="flex-1 flex flex-col items-center gap-2 h-full justify-end group">
                  <div className="w-full flex items-end justify-center gap-1 h-full">
                    {/* Initiated Bar */}
                    <div
                      className="w-full max-w-[18px] bg-[#E96835] rounded-t-sm transition-all hover:bg-[#D95724] relative cursor-pointer"
                      style={{ height: `${heightPct}%` }}
                    >
                      <div className="opacity-0 group-hover:opacity-100 transition-opacity absolute -top-7 left-1/2 -translate-x-1/2 bg-[#101B3A] text-white text-[10px] py-0.5 px-1.5 rounded font-mono pointer-events-none whitespace-nowrap z-20">
                        {t.requests} reqs
                      </div>
                    </div>
                  </div>
                  <span className="text-[11px] font-semibold text-[#64748B] font-mono">{t.day}</span>
                </div>
              );
            })}
          </div>

          {/* Chart Legend */}
          <div className="flex items-center justify-between pt-3 border-t border-[#E6DDD0] text-xs">
            <span className="flex items-center gap-2 text-[#101B3A] font-medium">
              <span className="h-3 w-3 rounded-xs bg-[#E96835]" /> Handshakes Completed
            </span>
            <span className="text-xs text-[#16764C] font-semibold">
              98.6% Driver Compliance
            </span>
          </div>
        </div>
      </section>

      {/* 4. Trust Ledger Cryptographic Verification Strip */}
      <section className="rounded-2xl border-2 border-[#16764C]/30 bg-[#FFFCF7] p-5 shadow-editorial flex flex-col sm:flex-row items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <div className="h-10 w-10 flex items-center justify-center rounded-xl bg-[#E4F1E5] text-[#16764C]">
            <ShieldCheck className="h-6 w-6" />
          </div>
          <div>
            <h3 className="font-editorial-serif text-lg font-bold text-[#101B3A]">
              Cryptographic Audit Attestation
            </h3>
            <p className="text-xs text-[#64748B]">
              Every depot ramp maintenance certificate is anchored with SHA-256 to Ethereum Sepolia testnet. Zero PII on-chain.
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <span className="font-mono text-xs font-bold text-[#16764C] bg-[#E4F1E5] px-3 py-1.5 rounded-lg border border-[#16764C]/20">
            Sepolia Block #6,419,203
          </span>
        </div>
      </section>
    </div>
  );
}
