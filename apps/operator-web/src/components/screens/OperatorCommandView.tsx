"use client";

import React, { useState } from "react";
import {
  Activity,
  Radio,
  AlertTriangle,
  ShieldCheck,
  CheckCircle2,
  Clock,
  Layers,
  Bus,
  Users,
  Compass,
  ArrowRight,
  ExternalLink,
} from "lucide-react";
import { YatraBrandLogo } from "@/components/brand/YatraBrandLogo";

interface QueueItem {
  id: string;
  route: string;
  stop: string;
  priority: "CRITICAL" | "HIGH" | "NORMAL";
  type: string;
  bus: string;
  driver: string;
  time: string;
  ack: boolean;
}

export function OperatorCommandView() {
  const [activeFilter, setActiveFilter] = useState<"ALL" | "ACKNOWLEDGED" | "PENDING">("ALL");

  const kpis = [
    { label: "Active buses", value: "48", sub: "38 low-floor (79%)", trend: "+4 vs morning peak", positive: true },
    { label: "Fleet occupancy", value: "62%", sub: "4 buses > 85% load", trend: "+3.2% vs baseline", positive: false },
    { label: "Live handshakes", value: "3", sub: "Avg ack: 18 seconds", trend: "Under 30s target", positive: true },
    { label: "On-time headway", value: "94.2%", sub: "Target 90% reached", trend: "+4.2% vs target", positive: true },
  ];

  const [queue, setQueue] = useState<QueueItem[]>([
    {
      id: "HSH-502-09",
      route: "502",
      stop: "AIIMS South Gate (Bay 04)",
      priority: "CRITICAL",
      type: "Wheelchair hydraulic ramp",
      bus: "DL 1PD 4421",
      driver: "Rajesh Kumar (ID: 8821)",
      time: "1m ago",
      ack: true,
    },
    {
      id: "HSH-TMS-14",
      route: "TMS(+)",
      stop: "Kashmere Gate ISBT",
      priority: "HIGH",
      type: "Vision guide assistance",
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
      type: "Elderly step-free extra time",
      bus: "DL 1PD 3311",
      driver: "S. Pal (ID: 9012)",
      time: "6m ago",
      ack: true,
    },
  ]);

  const toggleAck = (id: string) => {
    setQueue((prev) =>
      prev.map((item) => (item.id === id ? { ...item, ack: !item.ack } : item))
    );
  };

  const filteredQueue = queue.filter((item) => {
    if (activeFilter === "ACKNOWLEDGED") return item.ack;
    if (activeFilter === "PENDING") return !item.ack;
    return true;
  });

  return (
    <div className="space-y-6">
      {/* 1. Metric Cards Strip */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {kpis.map((kpi) => (
          <div
            key={kpi.label}
            className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial transition-all hover:shadow-editorial-lg"
          >
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold text-[#64748B]">{kpi.label}</span>
              <span
                className={`text-[11px] font-semibold tabular-nums px-2 py-0.5 rounded-full ${
                  kpi.positive
                    ? "bg-[#E4F1E5] text-[#16764C]"
                    : "bg-[#FEF3C7] text-[#D97706]"
                }`}
              >
                {kpi.trend}
              </span>
            </div>
            <div className="mt-3">
              <span className="font-editorial-serif text-3xl font-extrabold text-[#101B3A] tabular-nums">
                {kpi.value}
              </span>
            </div>
            <p className="mt-1 text-xs text-[#64748B]">{kpi.sub}</p>
          </div>
        ))}
      </div>

      {/* 2. Main Two-Column Command Layout */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left 2 Columns: Live Handshake Queue & Corridor Monitor */}
        <div className="lg:col-span-2 space-y-6">
          {/* Active Handshakes Card */}
          <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-4 border-b border-[#E6DDD0]">
              <div>
                <div className="flex items-center gap-2">
                  <div className="p-1.5 rounded-lg bg-[#E96835]/12 text-[#E96835]">
                    <Radio className="h-4 w-4" />
                  </div>
                  <h2 className="font-editorial-serif text-xl font-bold text-[#101B3A]">
                    Live boarding assistance queue
                  </h2>
                </div>
                <p className="text-xs text-[#64748B] mt-1">
                  AccessHandshake signals dispatched to approaching low-floor bus drivers
                </p>
              </div>

              {/* Filter Pills */}
              <div className="flex items-center gap-1.5 bg-[#F7F2E9] p-1 rounded-xl border border-[#E6DDD0] text-xs">
                <button
                  onClick={() => setActiveFilter("ALL")}
                  className={`px-2.5 py-1 rounded-lg font-medium transition-colors cursor-pointer ${
                    activeFilter === "ALL"
                      ? "bg-[#101B3A] text-white font-semibold"
                      : "text-[#64748B] hover:text-[#101B3A]"
                  }`}
                >
                  All ({queue.length})
                </button>
                <button
                  onClick={() => setActiveFilter("PENDING")}
                  className={`px-2.5 py-1 rounded-lg font-medium transition-colors cursor-pointer ${
                    activeFilter === "PENDING"
                      ? "bg-[#E96835] text-white font-semibold"
                      : "text-[#64748B] hover:text-[#101B3A]"
                  }`}
                >
                  Pending ({queue.filter((q) => !q.ack).length})
                </button>
                <button
                  onClick={() => setActiveFilter("ACKNOWLEDGED")}
                  className={`px-2.5 py-1 rounded-lg font-medium transition-colors cursor-pointer ${
                    activeFilter === "ACKNOWLEDGED"
                      ? "bg-[#16764C] text-white font-semibold"
                      : "text-[#64748B] hover:text-[#101B3A]"
                  }`}
                >
                  Acknowledged ({queue.filter((q) => q.ack).length})
                </button>
              </div>
            </div>

            {/* Queue Items List */}
            <div className="mt-4 space-y-3">
              {filteredQueue.map((item) => (
                <div
                  key={item.id}
                  className="rounded-xl border border-[#E6DDD0] bg-[#FFFFFF] p-4 transition-all hover:border-[#D4A373] shadow-xs"
                >
                  <div className="flex items-start justify-between gap-3">
                    <div className="flex items-center gap-2">
                      <span className="font-mono text-xs font-bold px-2 py-0.5 rounded-md bg-[#F7F2E9] text-[#101B3A] border border-[#E6DDD0]">
                        {item.id}
                      </span>
                      <span className="font-mono text-xs font-extrabold px-2 py-0.5 rounded-md bg-[#E96835]/15 text-[#E96835]">
                        Route {item.route}
                      </span>
                      <span
                        className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                          item.priority === "CRITICAL"
                            ? "bg-[#FEE2E2] text-[#DC2626]"
                            : item.priority === "HIGH"
                            ? "bg-[#FEF3C7] text-[#D97706]"
                            : "bg-[#E4F1E5] text-[#16764C]"
                        }`}
                      >
                        {item.priority}
                      </span>
                    </div>
                    <span className="text-xs text-[#64748B] flex items-center gap-1 tabular-nums">
                      <Clock className="h-3 w-3" /> {item.time}
                    </span>
                  </div>

                  <div className="mt-2.5 flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                    <div>
                      <p className="text-sm font-semibold text-[#101B3A]">{item.stop}</p>
                      <p className="text-xs text-[#64748B] mt-0.5">
                        Assistance: <span className="font-medium text-[#334155]">{item.type}</span> · Bus {item.bus} ({item.driver})
                      </p>
                    </div>

                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => toggleAck(item.id)}
                        className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-semibold transition-colors cursor-pointer ${
                          item.ack
                            ? "bg-[#E4F1E5] text-[#16764C] border border-[#16764C]/30 hover:bg-[#16764C]/15"
                            : "bg-[#E96835] text-white hover:bg-[#d05726]"
                        }`}
                      >
                        <CheckCircle2 className="h-3.5 w-3.5" />
                        <span>{item.ack ? "Driver confirmed" : "Acknowledge"}</span>
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Active Corridor Telemetry Monitor */}
          <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial">
            <div className="flex items-center justify-between pb-4 border-b border-[#E6DDD0]">
              <div className="flex items-center gap-2">
                <div className="p-1.5 rounded-lg bg-[#16764C]/12 text-[#16764C]">
                  <Compass className="h-4 w-4" />
                </div>
                <div>
                  <h3 className="font-editorial-serif text-lg font-bold text-[#101B3A]">
                    Key corridor operations and headway
                  </h3>
                  <p className="text-xs text-[#64748B]">
                    Real-time headway stability along high-density accessibility trunk lines
                  </p>
                </div>
              </div>
              <span className="text-xs font-semibold text-[#16764C] bg-[#E4F1E5] px-2.5 py-1 rounded-full border border-[#16764C]/20">
                GTFS-RT operational
              </span>
            </div>

            <div className="mt-4 grid grid-cols-1 md:grid-cols-3 gap-3">
              <div className="p-3.5 rounded-xl bg-[#FFFFFF] border border-[#E6DDD0]">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-[#101B3A]">Route 502</span>
                  <span className="text-[10px] font-semibold text-[#16764C] bg-[#E4F1E5] px-2 py-0.5 rounded-full">
                    On schedule
                  </span>
                </div>
                <p className="text-[11px] text-[#64748B] mt-1">Kashmere Gate ⟷ Mehrauli</p>
                <div className="mt-3 flex items-baseline justify-between text-xs">
                  <span className="text-[#64748B]">Headway gap</span>
                  <span className="font-bold text-[#101B3A] tabular-nums">7.8 min (Target 8.0)</span>
                </div>
                <div className="mt-1 flex items-baseline justify-between text-xs">
                  <span className="text-[#64748B]">Low-floor ratio</span>
                  <span className="font-bold text-[#16764C] tabular-nums">14 / 18 buses (78%)</span>
                </div>
              </div>

              <div className="p-3.5 rounded-xl bg-[#FFFFFF] border border-[#E6DDD0]">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-[#101B3A]">TMS(+) Mudrika</span>
                  <span className="text-[10px] font-semibold text-[#D97706] bg-[#FEF3C7] px-2 py-0.5 rounded-full">
                    Minor bunching
                  </span>
                </div>
                <p className="text-[11px] text-[#64748B] mt-1">Ring Road Clockwise Loop</p>
                <div className="mt-3 flex items-baseline justify-between text-xs">
                  <span className="text-[#64748B]">Headway gap</span>
                  <span className="font-bold text-[#101B3A] tabular-nums">5.2 min (Target 5.0)</span>
                </div>
                <div className="mt-1 flex items-baseline justify-between text-xs">
                  <span className="text-[#64748B]">Low-floor ratio</span>
                  <span className="font-bold text-[#16764C] tabular-nums">28 / 32 buses (88%)</span>
                </div>
              </div>

              <div className="p-3.5 rounded-xl bg-[#FFFFFF] border border-[#E6DDD0]">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-[#101B3A]">Route 534</span>
                  <span className="text-[10px] font-semibold text-[#16764C] bg-[#E4F1E5] px-2 py-0.5 rounded-full">
                    On schedule
                  </span>
                </div>
                <p className="text-[11px] text-[#64748B] mt-1">Anand Vihar ⟷ Mehrauli</p>
                <div className="mt-3 flex items-baseline justify-between text-xs">
                  <span className="text-[#64748B]">Headway gap</span>
                  <span className="font-bold text-[#101B3A] tabular-nums">11.4 min (Target 12.0)</span>
                </div>
                <div className="mt-1 flex items-baseline justify-between text-xs">
                  <span className="text-[#64748B]">Low-floor ratio</span>
                  <span className="font-bold text-[#16764C] tabular-nums">8 / 12 buses (67%)</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Right 1 Column: Depot Quick Actions & Cryptographic Proof */}
        <div className="space-y-6">
          {/* Quick Dispatch Controls */}
          <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial">
            <h3 className="font-editorial-serif text-base font-bold text-[#101B3A]">
              Depot operational actions
            </h3>
            <p className="text-xs text-[#64748B] mt-1">
              Direct dispatch protocols for Delhi Transport Corporation sector controllers
            </p>

            <div className="mt-4 space-y-2.5">
              <button
                type="button"
                className="w-full flex items-center justify-between p-3 rounded-xl bg-[#FFFFFF] border border-[#E6DDD0] text-xs font-semibold text-[#101B3A] hover:border-[#D4A373] hover:bg-[#F7F2E9] transition-colors cursor-pointer"
              >
                <div className="flex items-center gap-2.5">
                  <Bus className="h-4 w-4 text-[#E96835]" />
                  <span>Dispatch relief low-floor bus</span>
                </div>
                <ArrowRight className="h-3.5 w-3.5 text-[#64748B]" />
              </button>

              <button
                type="button"
                className="w-full flex items-center justify-between p-3 rounded-xl bg-[#FFFFFF] border border-[#E6DDD0] text-xs font-semibold text-[#101B3A] hover:border-[#D4A373] hover:bg-[#F7F2E9] transition-colors cursor-pointer"
              >
                <div className="flex items-center gap-2.5">
                  <AlertTriangle className="h-4 w-4 text-[#D97706]" />
                  <span>Issue ramp obstruction ticket</span>
                </div>
                <ArrowRight className="h-3.5 w-3.5 text-[#64748B]" />
              </button>

              <button
                type="button"
                className="w-full flex items-center justify-between p-3 rounded-xl bg-[#FFFFFF] border border-[#E6DDD0] text-xs font-semibold text-[#101B3A] hover:border-[#D4A373] hover:bg-[#F7F2E9] transition-colors cursor-pointer"
              >
                <div className="flex items-center gap-2.5">
                  <Activity className="h-4 w-4 text-[#16764C]" />
                  <span>Broadcast headway balancing</span>
                </div>
                <ArrowRight className="h-3.5 w-3.5 text-[#64748B]" />
              </button>
            </div>
          </div>

          {/* Cryptographic Trust Ledger Summary */}
          <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial">
            <div className="flex items-center justify-between pb-3 border-b border-[#E6DDD0]">
              <div className="flex items-center gap-2">
                <ShieldCheck className="h-4 w-4 text-[#16764C]" />
                <h4 className="font-editorial-serif text-sm font-bold text-[#101B3A]">
                  Trust ledger attestation
                </h4>
              </div>
              <span className="text-[10px] font-semibold text-[#16764C] bg-[#E4F1E5] px-2 py-0.5 rounded-full">
                Sepolia verified
              </span>
            </div>

            <p className="text-xs text-[#64748B] mt-2.5 leading-relaxed">
              Every resolved ramp assistance request and depot maintenance inspection is hashed and anchored with zero passenger PII on-chain.
            </p>

            <div className="mt-3 p-2.5 rounded-lg bg-[#F7F2E9] border border-[#E6DDD0] font-mono text-[10px] text-[#334155] break-all">
              Contract: 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
            </div>

            <div className="mt-3 pt-3 border-t border-[#E6DDD0] flex items-center justify-between text-xs text-[#64748B]">
              <span>Last anchor receipt</span>
              <span className="font-semibold text-[#101B3A] tabular-nums">2m ago · Block #7192811</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
