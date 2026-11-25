"use client";

import React from "react";
import {
  ShieldCheck,
  Activity,
  Phone,
  FileCheck2,
  ExternalLink,
  Layers,
  Building,
  Bus,
} from "lucide-react";

export function Footer() {
  return (
    <footer className="border-t border-[#1E2D4A] bg-[#0A0F1D] text-slate-300 font-sans mt-auto">
      {/* =========================================================================
          MAIN 4-COLUMN MUNICIPAL OPERATIONS ARCHITECTURE
      ========================================================================= */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-10">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {/* Column 1: Authority and Legal Mandate */}
          <div className="space-y-3">
            <div className="flex items-center gap-2">
              <div className="h-6 w-6 rounded-lg bg-[#E96835] flex items-center justify-center text-white">
                <Bus className="h-3.5 w-3.5" />
              </div>
              <span className="font-serif font-bold text-white text-sm tracking-tight">
                YATRA Operations Command
              </span>
            </div>
            <p className="text-xs text-slate-400 leading-relaxed">
              Official accessible transit telemetry and dispatch console for the Delhi Transport Corporation (DTC) and the Transport Department, Government of NCT of Delhi.
            </p>
            <div className="pt-2 border-t border-[#1E2D4A]/80 text-[11px] text-slate-400 space-y-1">
              <p className="font-semibold text-slate-300">Regulatory compliance</p>
              <p>Rights of Persons with Disabilities Act 2016</p>
              <p>Harmonized Guidelines 2021 (MoHUA)</p>
            </div>
          </div>

          {/* Column 2: Data Telemetry Feeds */}
          <div className="space-y-3">
            <h3 className="text-xs font-semibold uppercase tracking-wider text-slate-200 flex items-center gap-1.5">
              <Activity className="h-3.5 w-3.5 text-[#E96835]" />
              Telemetry feeds
            </h3>
            <ul className="text-xs text-slate-400 space-y-2">
              <li className="flex items-start justify-between">
                <span>GTFS-Static schedule</span>
                <span className="font-mono text-slate-300 tabular-nums">6,867 stops</span>
              </li>
              <li className="flex items-start justify-between">
                <span>GTFS-Realtime vehicles</span>
                <span className="font-mono text-emerald-400 tabular-nums">3,746 active</span>
              </li>
              <li className="flex items-start justify-between">
                <span>AccessGraph stop audits</span>
                <span className="font-mono text-slate-300 tabular-nums">100% indexed</span>
              </li>
              <li className="flex items-start justify-between">
                <span>AccessHandshake bus</span>
                <span className="font-mono text-sky-400 tabular-nums">Redis pub/sub</span>
              </li>
              <li className="flex items-start justify-between">
                <span>DMRC metro corridor</span>
                <span className="font-mono text-slate-300 tabular-nums">Yellow line</span>
              </li>
            </ul>
          </div>

          {/* Column 3: Verification & Governance */}
          <div className="space-y-3">
            <h3 className="text-xs font-semibold uppercase tracking-wider text-slate-200 flex items-center gap-1.5">
              <ShieldCheck className="h-3.5 w-3.5 text-emerald-400" />
              Governance & models
            </h3>
            <ul className="text-xs text-slate-400 space-y-2">
              <li className="flex items-start justify-between">
                <span>Sepolia audit ledger</span>
                <span className="font-mono text-emerald-400 text-[10px]">0x9fE4...a6e0</span>
              </li>
              <li className="flex items-start justify-between">
                <span>Furness IPF OD matrix</span>
                <span className="font-mono text-slate-300 tabular-nums">0.01% error</span>
              </li>
              <li className="flex items-start justify-between">
                <span>Feeder road width cap</span>
                <span className="font-mono text-slate-300 tabular-nums">&ge; 6.0m</span>
              </li>
              <li className="flex items-start justify-between">
                <span>Flow conservation</span>
                <span className="font-mono text-emerald-400 text-[10px]">Verified L_i</span>
              </li>
              <li className="flex items-start justify-between">
                <span>Provenance standards</span>
                <span className="font-mono text-slate-300 text-[10px]">Strict 5-tier</span>
              </li>
            </ul>
          </div>

          {/* Column 4: Control Room Dispatch & Helplines */}
          <div className="space-y-3">
            <h3 className="text-xs font-semibold uppercase tracking-wider text-slate-200 flex items-center gap-1.5">
              <Phone className="h-3.5 w-3.5 text-sky-400" />
              Operations contact
            </h3>
            <div className="text-xs text-slate-400 space-y-2">
              <div>
                <p className="text-slate-300 font-medium">DTC Central Control Room</p>
                <p className="font-mono text-[11px] text-slate-300">1800-11-8181 · 011-23370278</p>
              </div>
              <div>
                <p className="text-slate-300 font-medium">Accessible Transit Helpdesk</p>
                <p className="font-mono text-[11px] text-slate-300">011-23378201 (24x7 desk)</p>
              </div>
              <div>
                <p className="text-slate-300 font-medium">Emergency Response Support System</p>
                <p className="font-mono text-[11px] text-amber-400">Dial 112 (Police & Medical)</p>
              </div>
              <div className="pt-1 text-[11px] text-slate-400">
                <span>Shift Supervisor: </span>
                <span className="text-slate-200">Sh. Ramesh Chandra (Joint GM, Operations)</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* =========================================================================
          BOTTOM SYSTEM INTEGRITY BAR
      ========================================================================= */}
      <div className="border-t border-[#141F36] bg-[#070B16] px-4 sm:px-6 py-3 text-xs text-slate-400">
        <div className="max-w-7xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-3">
          <div className="flex flex-wrap items-center gap-x-3 gap-y-1 text-[11px]">
            <span className="text-slate-300 font-medium">
              © 2026 Delhi Transport Corporation & GNCTD
            </span>
            <span className="text-slate-600">·</span>
            <span>All telemetry governed by DTC open data standards</span>
            <span className="text-slate-600">·</span>
            <span>Zero synthetic values without explicit epistemic provenance</span>
          </div>

          <div className="flex items-center gap-3 text-[10px] font-mono text-slate-400">
            <span className="flex items-center gap-1">
              <span className="h-1.5 w-1.5 rounded-full bg-emerald-400" />
              <span>Gateway: Healthy</span>
            </span>
            <span className="text-slate-600">·</span>
            <span className="tabular-nums">Latency: 42ms</span>
            <span className="text-slate-600">·</span>
            <span>Release: 2.4.0-verified</span>
          </div>
        </div>
      </div>
    </footer>
  );
}
