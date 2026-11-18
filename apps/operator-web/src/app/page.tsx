"use client";

import React, { useState } from "react";
import { YatraBrandLogo } from "@/components/brand/YatraBrandLogo";
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
    <div className="min-h-screen bg-[#0B132B] text-slate-100 flex flex-col font-sans selection:bg-[#E96835] selection:text-white">
      {/* ==============================================================================
          1. TOP DESKTOP MASTHEAD & CONTROL BAR
      ============================================================================== */}
      <header className="sticky top-0 z-50 bg-[#101B3A] border-b border-slate-800 shadow-md px-6 py-3">
        <div className="max-w-7xl mx-auto flex items-center justify-between gap-4">
          {/* Brand Identity & Role Badge */}
          <div className="flex items-center gap-3">
            <YatraBrandLogo size="sm" variant="light" />
            <div className="hidden md:block h-5 w-px bg-slate-700" />
            <div className="hidden md:block">
              <span className="text-xs font-bold text-white tracking-wide">
                OPERATOR COMMAND & MUNICIPAL INTELLIGENCE
              </span>
              <p className="text-[10px] text-slate-400">
                Delhi Transport Corporation · Universal Accessibility Network
              </p>
            </div>
          </div>

          {/* Primary Portal Navigation Tabs */}
          <nav aria-label="Portal Navigation" className="flex items-center gap-1.5 bg-[#0B132B] p-1 rounded-xl border border-slate-800 text-xs font-semibold">
            <button
              onClick={() => setActiveTab("COMMAND")}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activeTab === "COMMAND"
                  ? "bg-[#E96835] text-white shadow-xs font-bold"
                  : "text-slate-300 hover:text-white hover:bg-slate-800"
              }`}
            >
              <LayoutDashboard className="h-3.5 w-3.5" />
              <span>Command Centre</span>
            </button>

            <button
              onClick={() => setActiveTab("ASSISTANCE")}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activeTab === "ASSISTANCE"
                  ? "bg-[#E96835] text-white shadow-xs font-bold"
                  : "text-slate-300 hover:text-white hover:bg-slate-800"
              }`}
            >
              <Radio className="h-3.5 w-3.5 text-[#E96835]" />
              <span>Assistance Queue</span>
              <span className="rounded-full bg-[#E96835] text-white text-[10px] px-1.5 py-0.2 font-bold">3</span>
            </button>

            <button
              onClick={() => setActiveTab("INCIDENTS")}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activeTab === "INCIDENTS"
                  ? "bg-[#E96835] text-white shadow-xs font-bold"
                  : "text-slate-300 hover:text-white hover:bg-slate-800"
              }`}
            >
              <AlertTriangle className="h-3.5 w-3.5 text-amber-400" />
              <span>Maintenance & Incidents</span>
            </button>

            <button
              onClick={() => setActiveTab("FLEET")}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activeTab === "FLEET"
                  ? "bg-[#E96835] text-white shadow-xs font-bold"
                  : "text-slate-300 hover:text-white hover:bg-slate-800"
              }`}
            >
              <Bus className="h-3.5 w-3.5" />
              <span>Fleet Operations</span>
            </button>

            <button
              onClick={() => setActiveTab("GOVERNMENT")}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activeTab === "GOVERNMENT"
                  ? "bg-[#16764C] text-white shadow-xs font-bold"
                  : "text-slate-300 hover:text-white hover:bg-slate-800"
              }`}
            >
              <Building className="h-3.5 w-3.5 text-emerald-300" />
              <span>Govt Intelligence</span>
            </button>
          </nav>

          {/* Right Status Controls */}
          <div className="hidden lg:flex items-center gap-4 text-xs">
            <div className="flex items-center gap-1.5 text-emerald-400 font-semibold bg-emerald-950/60 border border-emerald-800/60 px-2.5 py-1 rounded-full">
              <span className="h-2 w-2 rounded-full bg-emerald-400 animate-pulse" />
              <span>Sepolia Ledger Synced</span>
            </div>

            <div className="flex items-center gap-2 pl-2 border-l border-slate-700">
              <div className="h-7 w-7 rounded-full bg-slate-700 flex items-center justify-center text-slate-200">
                <User className="h-3.5 w-3.5" />
              </div>
              <div className="text-left">
                <p className="font-semibold text-slate-200">Officer A. Sharma</p>
                <p className="text-[10px] text-slate-400">Delhi South Control</p>
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* ==============================================================================
          2. PORTAL BODY CONTENT (DESKTOP WORKFLOWS)
      ============================================================================== */}
      <main className="flex-1 p-4 md:p-6 max-w-7xl mx-auto w-full">
        {activeTab === "COMMAND" && (
          <div className="space-y-6">
            <OperatorCommandView />
          </div>
        )}

        {activeTab === "ASSISTANCE" && (
          <div className="space-y-6">
            <div className="flex items-center justify-between pb-4 border-b border-slate-800">
              <div>
                <h1 className="text-2xl font-bold text-white">Live Boarding Assistance Requests</h1>
                <p className="text-xs text-slate-400 mt-1">
                  AccessHandshake signals transmitted from stops to approaching DTC drivers via Redis event bus.
                </p>
              </div>
              <div className="flex items-center gap-3">
                <span className="text-xs text-slate-400">Auto-refresh: 5s</span>
                <span className="inline-flex items-center gap-1 rounded-full bg-emerald-500/20 text-emerald-400 px-2.5 py-0.5 text-xs font-semibold">
                  <Activity className="h-3.5 w-3.5 animate-pulse" /> Live WebSocket
                </span>
              </div>
            </div>
            <div className="bg-[#101B3A] rounded-2xl border border-slate-800 p-6 text-slate-900 shadow-xl">
              <AssistanceRequestsTable />
            </div>
          </div>
        )}

        {activeTab === "INCIDENTS" && (
          <div className="space-y-6">
            <div className="flex items-center justify-between pb-4 border-b border-slate-800">
              <div>
                <h1 className="text-2xl font-bold text-white">Accessibility & Maintenance Incident Queue</h1>
                <p className="text-xs text-slate-400 mt-1">
                  Automated Gemini AI summarization and SLA dispatch tracking for wheelchair ramps and curb obstructions.
                </p>
              </div>
            </div>
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              <div className="lg:col-span-2">
                <IncidentQueue />
              </div>
              <div className="space-y-6">
                <TrustVerificationBadge />
                <div className="bg-[#101B3A] rounded-xl border border-slate-800 p-5 text-xs text-slate-300 space-y-3">
                  <h3 className="font-bold text-white flex items-center gap-2">
                    <ShieldCheck className="h-4 w-4 text-emerald-400" />
                    Ledger Attestation Protocol
                  </h3>
                  <p>
                    Every verified ramp resolution is anchored to Ethereum Sepolia with cryptographic hashes of the technician&apos;s depot sign-off.
                  </p>
                  <div className="p-3 bg-slate-900 rounded-lg font-mono text-[11px] text-slate-400 break-all">
                    Contract: 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {activeTab === "FLEET" && (
          <div className="space-y-6">
            <div className="flex items-center justify-between pb-4 border-b border-slate-800">
              <div>
                <h1 className="text-2xl font-bold text-white">Delhi Fleet Operations & Headway Monitor</h1>
                <p className="text-xs text-slate-400 mt-1">
                  Crowdedness-aware fleet metrics, low-floor ratio, and real-time headway compliance.
                </p>
              </div>
            </div>
            <div className="bg-[#101B3A] rounded-2xl border border-slate-800 p-6 text-slate-900 shadow-xl">
              <FleetOverview />
            </div>
          </div>
        )}

        {activeTab === "GOVERNMENT" && (
          <div className="space-y-6 rounded-2xl bg-[#F7F2E9] text-[#101B3A] p-2 sm:p-6 shadow-2xl border border-[#E6DDD0]">
            <GovtIntelligenceView />
          </div>
        )}
      </main>

      {/* ==============================================================================
          3. DESKTOP FOOTER
      ============================================================================== */}
      <footer className="border-t border-slate-800 bg-[#0B132B] px-6 py-4 text-xs text-slate-400">
        <div className="max-w-7xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-3">
          <p>© 2026 YATRA Operations Command · Delhi Transport Corporation (DTC) & GNCTD</p>
          <div className="flex items-center gap-4 text-slate-400">
            <span>GTFS-Realtime v2.0</span>
            <span>·</span>
            <span>AccessGraph v1.2</span>
            <span>·</span>
            <span>Trust Ledger: Sepolia Synced</span>
          </div>
        </div>
      </footer>
    </div>
  );
}
