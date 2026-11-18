"use client";

import React from "react";
import { YatraBrandLogo } from "@/components/brand/YatraBrandLogo";
import {
  Activity,
  Radio,
  AlertTriangle,
  ShieldCheck,
  CheckCircle2,
  Clock,
  Layers,
} from "lucide-react";

export function OperatorCommandView() {
  const kpis = [
    { label: "Active Buses", value: "48", sub: "38 Low-Floor (79%)", status: "normal" },
    { label: "Fleet Occupancy", value: "62%", sub: "4 buses > 85% load", status: "warning" },
    { label: "Live Handshakes", value: "3", sub: "Avg ack: 18 seconds", status: "normal" },
    { label: "On-Time Headway", value: "94.2%", sub: "Target 90% reached", status: "good" },
  ];

  const liveQueue = [
    {
      id: "HSH-502-09",
      route: "502",
      stop: "AIIMS South Gate",
      priority: "CRITICAL",
      type: "Wheelchair Ramp",
      bus: "DL 1PD 4421",
      driver: "Rajesh (ID: 8821)",
      time: "1m ago",
      ack: true,
    },
    {
      id: "HSH-TMS-14",
      route: "TMS(+)",
      stop: "Kashmere Gate ISBT",
      priority: "HIGH",
      type: "Vision Guide Assistance",
      bus: "DL 1PC 8902",
      driver: "M. Khan (ID: 4190)",
      time: "3m ago",
      ack: false,
    },
    {
      id: "HSH-534-02",
      route: "534",
      stop: "Nehru Place Terminal",
      priority: "NORMAL",
      type: "Elderly Extra Time",
      bus: "DL 1PD 3311",
      driver: "S. Pal (ID: 9012)",
      time: "6m ago",
      ack: true,
    },
  ];

  return (
    <div className="min-h-[780px] bg-[#0B132B] text-slate-100 flex flex-col md:flex-row rounded-2xl overflow-hidden border-2 border-slate-800 shadow-2xl">
      {/* 1. Deep Navy Vertical Navigation */}
      <aside className="w-full md:w-64 bg-[#101B3A] border-b md:border-b-0 md:border-r border-slate-800 p-5 flex flex-col justify-between">
        <div className="space-y-6">
          <YatraBrandLogo size="md" variant="light" />

          <div className="pt-2">
            <span className="text-[10px] font-bold tracking-widest uppercase text-slate-400">
              Operations Control
            </span>
            <nav className="mt-3 space-y-1 text-xs">
              <a href="#map" className="flex items-center gap-2.5 rounded-lg bg-indigo-600/30 text-indigo-300 font-semibold px-3 py-2 border border-indigo-500/30">
                <Layers className="h-4 w-4" />
                <span>Live Fleet Map</span>
              </a>
              <a href="#queue" className="flex items-center gap-2.5 rounded-lg text-slate-300 hover:bg-slate-800/60 px-3 py-2 transition-colors">
                <Radio className="h-4 w-4 text-[#E96835]" />
                <span>Assistance Queue</span>
                <span className="ml-auto rounded-full bg-[#E96835] text-white text-[10px] font-bold px-1.5">3</span>
              </a>
              <a href="#incidents" className="flex items-center gap-2.5 rounded-lg text-slate-300 hover:bg-slate-800/60 px-3 py-2 transition-colors">
                <AlertTriangle className="h-4 w-4 text-amber-400" />
                <span>Active Incidents</span>
                <span className="ml-auto rounded-full bg-amber-500/20 text-amber-300 text-[10px] font-bold px-1.5">2</span>
              </a>
              <a href="#trust" className="flex items-center gap-2.5 rounded-lg text-slate-300 hover:bg-slate-800/60 px-3 py-2 transition-colors">
                <ShieldCheck className="h-4 w-4 text-emerald-400" />
                <span>Trust Ledger Audits</span>
              </a>
            </nav>
          </div>
        </div>

        {/* Live Controller Status */}
        <div className="mt-6 md:mt-0 p-3 rounded-xl bg-slate-900/80 border border-slate-800 text-[11px] text-slate-400 space-y-1">
          <div className="flex items-center gap-1.5 text-emerald-400 font-semibold">
            <span className="h-2 w-2 rounded-full bg-emerald-400 animate-ping" />
            <span>Telemetry Online</span>
          </div>
          <p>Sector: Delhi South & Central Ring</p>
          <p className="text-[10px] font-mono text-slate-500">Latency: 142ms (Redis Pub/Sub)</p>
        </div>
      </aside>

      {/* 2. Main Operations Dashboard */}
      <main className="flex-1 p-6 space-y-6 flex flex-col justify-between">
        {/* Top Header & Live KPI Strip */}
        <div className="space-y-4">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
            <div>
              <span className="text-[10px] font-bold tracking-widest uppercase text-indigo-400">
                Central Dispatch
              </span>
              <h1 className="font-editorial-serif text-2xl sm:text-3xl font-bold text-white">
                Network Operations Center
              </h1>
            </div>

            <div className="flex items-center gap-2">
              <span className="rounded-full bg-emerald-500/20 border border-emerald-500/40 text-emerald-300 px-3 py-1 text-xs font-semibold flex items-center gap-1.5">
                <Activity className="h-3.5 w-3.5" /> Normal Fleet Headway
              </span>
            </div>
          </div>

          {/* KPI Strip */}
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
            {kpis.map((kpi) => (
              <div
                key={kpi.label}
                className="rounded-xl border border-slate-800 bg-slate-900/60 p-3.5 space-y-1 shadow-sm"
              >
                <p className="text-[11px] text-slate-400 uppercase tracking-wider">{kpi.label}</p>
                <p className="font-editorial-serif text-2xl font-bold text-white">{kpi.value}</p>
                <p className="text-[10px] text-slate-400">{kpi.sub}</p>
              </div>
            ))}
          </div>
        </div>

        {/* 3. Dark Cartographic Operations Map Simulation (`YATRA-ILL-009`) */}
        <div className="relative h-[280px] sm:h-[320px] rounded-xl border border-slate-800 bg-[#070D1E] overflow-hidden">
          <svg
            viewBox="0 0 800 360"
            className="w-full h-full object-cover"
            xmlns="http://www.w3.org/2000/svg"
          >
            {/* Dark Delhi Transit Grid Lines */}
            <g stroke="#1A2744" strokeWidth="1">
              <line x1="0" y1="60" x2="800" y2="60" />
              <line x1="0" y1="140" x2="800" y2="140" />
              <line x1="0" y1="220" x2="800" y2="220" />
              <line x1="0" y1="300" x2="800" y2="300" />
              <line x1="120" y1="0" x2="120" y2="360" />
              <line x1="280" y1="0" x2="280" y2="360" />
              <line x1="440" y1="0" x2="440" y2="360" />
              <line x1="600" y1="0" x2="600" y2="360" />
              <line x1="720" y1="0" x2="720" y2="360" />
            </g>

            {/* Glowing Ring Road Arterial Loop */}
            <ellipse
              cx="400"
              cy="180"
              rx="280"
              ry="110"
              stroke="#0284C7"
              strokeWidth="4"
              strokeDasharray="8 4"
              fill="none"
              opacity="0.8"
            />
            {/* Route 502 Radial Spur Line */}
            <line x1="220" y1="60" x2="520" y2="290" stroke="#38BDF8" strokeWidth="5" strokeLinecap="round" />

            {/* Live Bus Beacon 1 (Route 502) */}
            <g transform="translate(420, 210)">
              <circle cx="0" cy="0" r="16" fill="#38BDF8" opacity="0.3" className="animate-ping" />
              <circle cx="0" cy="0" r="7" fill="#38BDF8" stroke="#FFFFFF" strokeWidth="2" />
              <text x="12" y="4" fill="#38BDF8" fontSize="11" fontWeight="bold">502 (AIIMS)</text>
            </g>

            {/* Live Bus Beacon 2 (TMS) */}
            <g transform="translate(620, 160)">
              <circle cx="0" cy="0" r="14" fill="#10B981" opacity="0.3" className="animate-ping" />
              <circle cx="0" cy="0" r="6" fill="#10B981" stroke="#FFFFFF" strokeWidth="2" />
              <text x="12" y="4" fill="#10B981" fontSize="11" fontWeight="bold">TMS (Wazirpur)</text>
            </g>

            {/* Critical Assistance Geo-Pin at AIIMS */}
            <g transform="translate(425, 225)">
              <circle cx="0" cy="0" r="9" fill="#E96835" />
              <path d="M-4 -4 L4 4 M4 -4 L-4 4" stroke="#FFFFFF" strokeWidth="1.5" />
            </g>
          </svg>

          {/* Map Overlay Badge */}
          <div className="absolute top-3 left-3 bg-[#101B3A]/90 border border-slate-700 rounded-lg p-2 text-[10px] space-y-0.5 backdrop-blur-xs font-mono">
            <p className="text-indigo-300 font-bold">GIS Projection: WGS 84 (EPSG:4326)</p>
            <p className="text-slate-400">PostGIS Spatial Geofence: 500m Active</p>
          </div>
        </div>

        {/* 4. Priority Assistance Queue Table */}
        <div className="space-y-2">
          <div className="flex items-center justify-between">
            <h2 className="text-xs font-bold uppercase tracking-wider text-slate-300">
              Live Assistance Handshake Queue
            </h2>
            <span className="text-[11px] text-slate-400 font-mono">Real-Time WebSocket Stream</span>
          </div>

          <div className="rounded-xl border border-slate-800 bg-slate-900/70 overflow-x-auto">
            <table className="w-full text-left text-xs text-slate-300">
              <thead className="border-b border-slate-800 bg-slate-900/90 text-[10px] font-bold uppercase text-slate-400">
                <tr>
                  <th className="px-3.5 py-2.5">Priority</th>
                  <th className="px-3.5 py-2.5">Route & Stop</th>
                  <th className="px-3.5 py-2.5">Assistance Type</th>
                  <th className="px-3.5 py-2.5">Bus & Driver</th>
                  <th className="px-3.5 py-2.5">Status</th>
                  <th className="px-3.5 py-2.5 text-right">Elapsed</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-800/60 font-mono">
                {liveQueue.map((item) => (
                  <tr key={item.id} className="hover:bg-slate-800/40 transition-colors">
                    <td className="px-3.5 py-2">
                      <span
                        className={`rounded px-1.5 py-0.5 text-[9px] font-bold ${
                          item.priority === "CRITICAL"
                            ? "bg-rose-500/20 text-rose-300 border border-rose-500/40"
                            : item.priority === "HIGH"
                            ? "bg-amber-500/20 text-amber-300 border border-amber-500/40"
                            : "bg-slate-700 text-slate-300"
                        }`}
                      >
                        {item.priority}
                      </span>
                    </td>
                    <td className="px-3.5 py-2 font-sans font-semibold text-white">
                      {item.route} · {item.stop}
                    </td>
                    <td className="px-3.5 py-2 font-sans text-slate-300">
                      {item.type}
                    </td>
                    <td className="px-3.5 py-2 text-slate-400">
                      {item.bus} ({item.driver})
                    </td>
                    <td className="px-3.5 py-2">
                      {item.ack ? (
                        <span className="text-emerald-400 flex items-center gap-1 font-semibold">
                          <CheckCircle2 className="h-3.5 w-3.5" /> Acked
                        </span>
                      ) : (
                        <span className="text-amber-400 flex items-center gap-1 font-semibold animate-pulse">
                          <Clock className="h-3.5 w-3.5" /> Paging Driver
                        </span>
                      )}
                    </td>
                    <td className="px-3.5 py-2 text-right text-slate-500 font-sans">{item.time}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </main>
    </div>
  );
}
