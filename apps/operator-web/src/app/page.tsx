"use client";

import React, { useState } from "react";
import { Navbar } from "@/components/Navbar";
import { Sidebar } from "@/components/Sidebar";
import { MetricCard } from "@/components/MetricCard";
import { AssistanceRequestsTable } from "@/components/AssistanceRequestsTable";
import { IncidentQueue } from "@/components/IncidentQueue";
import { FleetOverview } from "@/components/FleetOverview";
import { TrustVerificationBadge } from "@/components/TrustVerificationBadge";
import {
  Bus,
  Accessibility,
  Radio,
  AlertTriangle,
  Info,
} from "lucide-react";

export default function OperatorDashboardPage() {
  const [activeTab, setActiveTab] = useState("overview");

  return (
    <div className="flex min-h-screen flex-col bg-slate-50">
      <Navbar />

      <div className="flex flex-1">
        <Sidebar activeTab={activeTab} onTabChange={setActiveTab} />

        <main id="main-content" className="flex-1 p-6 lg:p-8 space-y-8 max-w-7xl">
          {/* Header & Status Notice */}
          <div className="space-y-2">
            <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
              <div>
                <h1 className="text-2xl lg:text-3xl font-extrabold tracking-tight text-slate-900">
                  Fleet & Accessibility Command Console
                </h1>
                <p className="text-sm text-slate-500 mt-1">
                  Delhi Transport Corporation (DTC) & DIMTS Operational Sector
                </p>
              </div>

              {/* Verified Synthetic Mode Pill */}
              <div className="inline-flex items-center gap-2 rounded-lg border border-amber-200 bg-amber-50 px-3.5 py-1.5 text-xs text-amber-900">
                <Info className="h-4 w-4 text-amber-600 flex-shrink-0" aria-hidden="true" />
                <span>
                  <strong>Sample Mode:</strong> Telemetry simulated from Delhi GTFS Route 502 & Oct 2026 stack.
                </span>
              </div>
            </div>
          </div>

          {/* KPI Metrics Grid */}
          <section aria-label="Key Performance Indicators" className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <MetricCard
              title="Active Fleet Vehicles"
              value="62"
              subtitle="48 Low-Floor with accessible ramps"
              icon={Bus}
              accentColor="indigo"
              trend={{ value: "+4 peak buses", isPositive: true }}
            />
            <MetricCard
              title="Active Handshakes"
              value="3"
              subtitle="Average driver ack in 18 seconds"
              icon={Radio}
              accentColor="emerald"
              trend={{ value: "100% ack rate", isPositive: true }}
            />
            <MetricCard
              title="Accessibility Score"
              value="87.4"
              subtitle="AccessGraph corridor rating (out of 100)"
              icon={Accessibility}
              accentColor="indigo"
              trend={{ value: "+2.1% this week", isPositive: true }}
            />
            <MetricCard
              title="Open Grievances"
              value="2"
              subtitle="AI triaged; 1 work order assigned"
              icon={AlertTriangle}
              accentColor="amber"
            />
          </section>

          {/* Assistance Requests Section */}
          <section aria-label="Live Assistance Queue">
            <AssistanceRequestsTable />
          </section>

          {/* Split View: Incidents & Blockchain Audits */}
          <section aria-label="Incidents and Trust Ledger" className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <IncidentQueue />
            <TrustVerificationBadge />
          </section>

          {/* Fleet & Crowding Overview */}
          <section aria-label="Corridor Fleet Status">
            <FleetOverview />
          </section>

          {/* Footer info */}
          <footer className="border-t border-slate-200 pt-6 text-center text-xs text-slate-500 space-y-1">
            <p>
              YATRA — Your Accessible Transport & Reliable Assistance Platform • Open Source (Apache 2.0)
            </p>
            <p>
              Designed for WCAG 2.2 AA accessibility standards • Deterministic Routing & Free-first MapLibre stack
            </p>
          </footer>
        </main>
      </div>
    </div>
  );
}
