"use client";

import React, { useState } from "react";
import { Navbar, WebPortalTab } from "@/components/Navbar";
import { Footer } from "@/components/Footer";
import { YatraWaveBackground } from "@/components/brand/YatraWaveBackground";
import { OperatorCommandView } from "@/components/screens/OperatorCommandView";
import { GovtIntelligenceView } from "@/components/screens/GovtIntelligenceView";
import { AssistanceRequestsTable } from "@/components/AssistanceRequestsTable";
import { IncidentQueue } from "@/components/IncidentQueue";
import { FleetOverview } from "@/components/FleetOverview";
import { TrustVerificationBadge } from "@/components/TrustVerificationBadge";
import { Activity, ShieldCheck } from "lucide-react";

export default function OperatorWebMaster() {
  const [activeTab, setActiveTab] = useState<WebPortalTab>("COMMAND");

  return (
    <div className="min-h-screen bg-[#F7F2E9] text-[#101B3A] flex flex-col font-sans selection:bg-[#E96835] selection:text-white">
      {/* 1. Cohesive Multi-Tier Command Navigation */}
      <Navbar activeTab={activeTab} onTabChange={setActiveTab} assistanceCount={3} incidentsCount={2} />

      {/* 2. Portal Workspace Container */}
      <main className="relative flex-1 p-4 md:p-6 lg:p-8 max-w-7xl mx-auto w-full">
        <YatraWaveBackground variant="editorial" opacity={0.25} />

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

      {/* 3. Comprehensive Municipal Operations Footer */}
      <Footer />
    </div>
  );
}
