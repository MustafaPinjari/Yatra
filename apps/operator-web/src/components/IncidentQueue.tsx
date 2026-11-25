"use client";

import React, { useState } from "react";
import { Wrench, ShieldCheck, CheckCircle, FileText, ArrowRight } from "lucide-react";

interface IncidentItem {
  id: string;
  category: string;
  severity: "HIGH" | "MEDIUM" | "LOW";
  stopOrBus: string;
  description: string;
  aiSummary: string;
  status: "OPEN" | "TRIAGED" | "RESOLVED";
}

const sampleIncidents: IncidentItem[] = [
  {
    id: "INC-2026-089",
    category: "Hydraulic ramp mechanism fault",
    severity: "HIGH",
    stopOrBus: "Vehicle DL 1PD 1092 (Route 502)",
    description: "Driver attempted to deploy wheelchair ramp at Green Park, but hydraulic lift failed to engage. Passenger assisted manually by conductor.",
    aiSummary: "Automated triage: Mechanical failure of hydraulic actuator. Recommended depot inspection and Trust Ledger recording upon repair.",
    status: "TRIAGED",
  },
  {
    id: "INC-2026-090",
    category: "Tactile paving curb cut obstruction",
    severity: "MEDIUM",
    stopOrBus: "Stop: AIIMS South Gate (Bay 04)",
    description: "Two commercial auto-rickshaws parked across tactile paving curb cut, preventing wheelchair passenger from aligning with bus door.",
    aiSummary: "Automated triage: Physical access obstruction on municipal property. Ticket dispatched to Delhi Traffic Police transit marshall unit.",
    status: "OPEN",
  },
  {
    id: "INC-2026-091",
    category: "Bus audio visual display failure",
    severity: "LOW",
    stopOrBus: "Vehicle DL 1PC 8820 (Route 534)",
    description: "Internal bilingual LED next-stop display frozen. Audio stop announcement operating intermittently.",
    aiSummary: "Automated triage: Onboard ETM telematics firmware fault. Scheduled for depot reset during overnight layover.",
    status: "TRIAGED",
  },
];

export function IncidentQueue() {
  const [incidents, setIncidents] = useState<IncidentItem[]>(sampleIncidents);

  const resolveIncident = (id: string) => {
    setIncidents((prev) =>
      prev.map((inc) => (inc.id === id ? { ...inc, status: "RESOLVED" } : inc))
    );
  };

  const getSeverityBadge = (severity: string) => {
    switch (severity) {
      case "HIGH":
        return <span className="rounded-full bg-[#FEE2E2] px-2.5 py-0.5 text-[10px] font-bold text-[#DC2626]">High priority</span>;
      case "MEDIUM":
        return <span className="rounded-full bg-[#FEF3C7] px-2.5 py-0.5 text-[10px] font-bold text-[#D97706]">Medium priority</span>;
      default:
        return <span className="rounded-full bg-[#F1F5F9] px-2.5 py-0.5 text-[10px] font-bold text-[#64748B]">Low priority</span>;
    }
  };

  return (
    <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-[#E6DDD0] pb-4">
        <div>
          <h2 className="font-editorial-serif text-xl font-bold text-[#101B3A]">
            Accessibility incidents and maintenance triage
          </h2>
          <p className="text-xs text-[#64748B] mt-1">
            Passenger and driver reports triaged into operational maintenance tickets
          </p>
        </div>
        <span className="rounded-full bg-[#F7F2E9] border border-[#E6DDD0] px-3 py-1 text-xs font-semibold text-[#101B3A] tabular-nums">
          {incidents.filter((i) => i.status !== "RESOLVED").length} active incidents
        </span>
      </div>

      <div className="mt-4 space-y-4">
        {incidents.map((inc) => (
          <div
            key={inc.id}
            className="rounded-xl border border-[#E6DDD0] p-4 bg-[#FFFFFF] shadow-xs transition-all hover:border-[#D4A373]"
          >
            <div className="flex items-center justify-between gap-2">
              <div className="flex items-center gap-2">
                <span className="font-mono text-xs font-bold text-[#101B3A]">{inc.id}</span>
                {getSeverityBadge(inc.severity)}
                <span className="text-sm font-semibold text-[#101B3A]">{inc.category}</span>
              </div>
              <span className="text-xs text-[#64748B] font-medium">{inc.stopOrBus}</span>
            </div>

            <p className="mt-2 text-xs text-[#334155] leading-relaxed">
              {inc.description}
            </p>

            {/* Structured analysis banner */}
            <div className="mt-3 flex items-start gap-2 rounded-xl bg-[#F7F2E9] p-3 text-xs text-[#334155] border border-[#E6DDD0]">
              <FileText className="h-4 w-4 text-[#E96835] flex-shrink-0 mt-0.5" aria-hidden="true" />
              <div>
                <span className="font-semibold text-[#101B3A]">Automated dispatch analysis: </span>
                <span className="text-[#64748B]">{inc.aiSummary}</span>
              </div>
            </div>

            <div className="mt-3.5 flex items-center justify-between pt-3 border-t border-[#E6DDD0]">
              <span
                className={`text-[11px] font-semibold ${
                  inc.status === "RESOLVED"
                    ? "text-[#16764C]"
                    : inc.status === "TRIAGED"
                    ? "text-[#D97706]"
                    : "text-[#DC2626]"
                }`}
              >
                Status: {inc.status}
              </span>

              <div className="flex items-center gap-2">
                {inc.status !== "RESOLVED" && (
                  <button
                    type="button"
                    onClick={() => resolveIncident(inc.id)}
                    className="inline-flex items-center gap-1.5 rounded-xl border border-[#E6DDD0] bg-[#FFFFFF] px-3 py-1.5 text-xs font-medium text-[#101B3A] hover:bg-[#F7F2E9] transition-colors cursor-pointer"
                  >
                    <CheckCircle className="h-3.5 w-3.5 text-[#16764C]" />
                    <span>Mark resolved</span>
                  </button>
                )}
                <button
                  type="button"
                  className="inline-flex items-center gap-1.5 rounded-xl bg-[#101B3A] px-3 py-1.5 text-xs font-semibold text-white hover:bg-[#172653] transition-colors cursor-pointer"
                >
                  <Wrench className="h-3.5 w-3.5" />
                  <span>Assign depot work order</span>
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
