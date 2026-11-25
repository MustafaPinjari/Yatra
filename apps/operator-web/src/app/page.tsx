"use client";

import React, { useState } from "react";
import { YatraBrandLogo } from "@/components/brand/YatraBrandLogo";
import { YatraWaveBackground } from "@/components/brand/YatraWaveBackground";
import { OperatorCommandView } from "@/components/screens/OperatorCommandView";
import { GovtIntelligenceView } from "@/components/screens/GovtIntelligenceView";
import { AssistanceRequestsTable } from "@/components/AssistanceRequestsTable";
import { IncidentQueue } from "@/components/IncidentQueue";
import { FleetOverview } from "@/components/FleetOverview";
import { TrustVerificationBadge } from "@/components/TrustVerificationBadge";
import {
  LayoutDashboard,
  Radio,
  AlertTriangle,
  Building,
  Bus,
  ShieldCheck,
  Activity,
  User,
} from "lucide-react";

type WebPortalTab = "COMMAND" | "ASSISTANCE" | "INCIDENTS" | "FLEET" | "GOVERNMENT";

export default function OperatorWebMaster() {
  const [activeTab, setActiveTab] = useState<WebPortalTab>("COMMAND");

  return (
    <div className="min-h-screen bg-[#F7F2E9] text-[#101B3A] flex flex-col font-sans selection:bg-[#E96835] selection:text-white">
      {/* ==============================================================================
          1. TOP DESKTOP MASTHEAD & CONTROL BAR
      ============================================================================== */}
      <header className="sticky top-0 z-50 bg-[#101B3A] border-b border-[#172653] shadow-md px-4 sm:px-6 py-3">
        <div className="max-w-7xl mx-auto flex items-center justify-between gap-4">
          {/* Brand Identity & Role Badge */}
          <div className="flex items-center gap-3">
            <YatraBrandLogo size="sm" variant="light" />
            <div className="hidden md:block h-5 w-px bg-[#233554]" />
            <div className="hidden md:block">
              <span className="text-xs font-semibold text-white tracking-normal">
                Operator Command and Municipal Intelligence
              </span>
              <p className="text-[10px] text-slate-400">
                Delhi Transport Corporation · Accessibility Operations Network
              </p>
            </div>
          </div>

          {/* Primary Portal Navigation Tabs */}
          <nav aria-label="Portal Navigation" className="flex items-center gap-1 sm:gap-1.5 bg-[#0D152D] p-1 rounded-xl border border-[#233554] text-xs font-medium">
            <button
              onClick={() => setActiveTab("COMMAND")}
              className={`flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activeTab === "COMMAND"
                  ? "bg-[#E96835] text-white shadow-xs font-semibold"
                  : "text-slate-300 hover:text-white hover:bg-[#1E2D4A]"
              }`}
            >
              <LayoutDashboard className="h-3.5 w-3.5" />
              <span className="hidden sm:inline">Command centre</span>
              <span className="sm:hidden">Command</span>
            </button>

            <button
              onClick={() => setActiveTab("ASSISTANCE")}
              className={`flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activeTab === "ASSISTANCE"
                  ? "bg-[#E96835] text-white shadow-xs font-semibold"
                  : "text-slate-300 hover:text-white hover:bg-[#1E2D4A]"
              }`}
            >
              <Radio className="h-3.5 w-3.5 text-[#E96835]" />
              <span className="hidden sm:inline">Assistance queue</span>
              <span className="sm:hidden">Assistance</span>
              <span className="rounded-full bg-[#E96835] text-white text-[10px] px-1.5 py-0.2 font-bold font-mono">3</span>
            </button>

            <button
              onClick={() => setActiveTab("INCIDENTS")}
              className={`flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activeTab === "INCIDENTS"
                  ? "bg-[#E96835] text-white shadow-xs font-semibold"
                  : "text-slate-300 hover:text-white hover:bg-[#1E2D4A]"
              }`}
            >
              <AlertTriangle className="h-3.5 w-3.5 text-amber-400" />
              <span>Incidents</span>
            </button>

            <button
              onClick={() => setActiveTab("FLEET")}
              className={`flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activeTab === "FLEET"
                  ? "bg-[#E96835] text-white shadow-xs font-semibold"
                  : "text-slate-300 hover:text-white hover:bg-[#1E2D4A]"
              }`}
            >
              <Bus className="h-3.5 w-3.5" />
              <span className="hidden sm:inline">Fleet operations</span>
              <span className="sm:hidden">Fleet</span>
            </button>

            <button
              onClick={() => setActiveTab("GOVERNMENT")}
              className={`flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activeTab === "GOVERNMENT"
                  ? "bg-[#16764C] text-white shadow-xs font-semibold"
                  : "text-slate-300 hover:text-white hover:bg-[#1E2D4A]"
              }`}
            >
              <Building className="h-3.5 w-3.5 text-emerald-300" />
              <span className="hidden sm:inline">Municipal analytics</span>
              <span className="sm:hidden">Analytics</span>
            </button>
          </nav>

          {/* Right Status Controls */}
          <div className="hidden lg:flex items-center gap-4 text-xs">
            <div className="flex items-center gap-1.5 text-emerald-300 font-medium bg-[#16764C]/20 border border-[#16764C]/40 px-2.5 py-1 rounded-full">
              <span className="h-2 w-2 rounded-full bg-emerald-400 animate-pulse" />
              <span className="font-mono text-[11px]">Sepolia synced</span>
            </div>

            <div className="flex items-center gap-2 pl-2 border-l border-[#233554]">
              <div className="h-7 w-7 rounded-full bg-[#1E2D4A] border border-[#233554] flex items-center justify-center text-slate-200">
                <User className="h-3.5 w-3.5" />
              </div>
              <div className="text-left">
                <p className="font-semibold text-slate-200 text-xs">Officer A. Sharma</p>
                <p className="text-[10px] text-slate-400">Delhi South Control</p>
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* ==============================================================================
          2. PORTAL BODY CONTENT (DESKTOP WORKFLOWS)
      ============================================================================== */}
      <main className="relative flex-1 p-4 md:p-6 max-w-7xl mx-auto w-full">
        <YatraWaveBackground variant="editorial" opacity={0.35} />
        <div className="relative z-10 space-y-6">
          {activeTab === "COMMAND" && (
            <div className="space-y-6">
              <OperatorCommandView />
            </div>
          )}

          {activeTab === "ASSISTANCE" && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-[#E6DDD0] gap-3">
                <div>
                  <h1 className="font-serif text-2xl font-bold text-[#101B3A]">
                    Live boarding assistance requests
                  </h1>
                  <p className="text-xs text-[#64748B] mt-1">
                    AccessHandshake signals transmitted from stops to approaching DTC drivers via Redis event bus
                  </p>
                </div>
                <div className="flex items-center gap-3">
                  <span className="text-xs text-[#64748B] font-mono">Auto-refresh: 5s</span>
                  <span className="inline-flex items-center gap-1 rounded-full bg-[#16764C]/10 border border-[#16764C]/25 text-[#16764C] px-2.5 py-1 text-xs font-semibold">
                    <Activity className="h-3.5 w-3.5 animate-pulse" /> Live telemetry
                  </span>
                </div>
              </div>
              <AssistanceRequestsTable />
            </div>
          )}

          {activeTab === "INCIDENTS" && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-[#E6DDD0] gap-3">
                <div>
                  <h1 className="font-serif text-2xl font-bold text-[#101B3A]">
                    Accessibility and maintenance incident queue
                  </h1>
                  <p className="text-xs text-[#64748B] mt-1">
                    Automated incident categorization and SLA dispatch tracking for wheelchair ramps and curb obstructions
                  </p>
                </div>
              </div>
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <div className="lg:col-span-2">
                  <IncidentQueue />
                </div>
                <div className="space-y-6">
                  <TrustVerificationBadge />
                  <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-5 text-xs text-[#334155] space-y-3 shadow-editorial">
                    <h3 className="font-serif font-bold text-[#101B3A] flex items-center gap-2 text-sm">
                      <ShieldCheck className="h-4 w-4 text-[#16764C]" />
                      Ledger attestation protocol
                    </h3>
                    <p className="text-xs text-[#64748B] leading-relaxed">
                      Every verified ramp resolution is anchored to Ethereum Sepolia with cryptographic hashes of the technician&apos;s depot sign-off.
                    </p>
                    <div className="p-3 bg-[#FAF5EE] border border-[#E6DDD0] rounded-xl font-mono text-[11px] text-[#101B3A] break-all">
                      Contract: 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
                    </div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {activeTab === "FLEET" && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-[#E6DDD0] gap-3">
                <div>
                  <h1 className="font-serif text-2xl font-bold text-[#101B3A]">
                    Delhi fleet operations and headway monitor
                  </h1>
                  <p className="text-xs text-[#64748B] mt-1">
                    Crowdedness-aware fleet metrics, low-floor ratio, and real-time headway compliance
                  </p>
                </div>
              </div>
              <FleetOverview />
            </div>
          )}

          {activeTab === "GOVERNMENT" && (
            <div className="space-y-6">
              <GovtIntelligenceView />
            </div>
          )}
        </div>
      </main>

      {/* ==============================================================================
          3. DESKTOP FOOTER
      ============================================================================== */}
      <footer className="border-t border-[#172653] bg-[#101B3A] px-6 py-5 text-xs text-slate-400">
        <div className="max-w-7xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-3">
          <div className="flex items-center gap-2">
            <span className="font-serif font-bold text-white text-sm">YATRA</span>
            <span>© 2026 Operations Command · Delhi Transport Corporation & GNCTD</span>
          </div>
          <div className="flex items-center gap-4 text-slate-400 font-mono text-[11px]">
            <span>GTFS-Realtime v2.0</span>
            <span>·</span>
            <span>AccessGraph v1.2</span>
            <span>·</span>
            <span className="text-emerald-400 font-medium">Sepolia Synced</span>
          </div>
        </div>
      </footer>
    </div>
  );
}
