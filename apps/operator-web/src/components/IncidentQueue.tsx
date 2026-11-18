import React from "react";
import { Wrench, Sparkles, CheckCircle } from "lucide-react";

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
    category: "Hydraulic Ramp Fault",
    severity: "HIGH",
    stopOrBus: "Vehicle DL 1PD 1092 (Route 502)",
    description: "Driver attempted to deploy wheelchair ramp at Green Park, but hydraulic lift failed to engage. Passenger assisted manually by conductor.",
    aiSummary: "Gemini Triage: Mechanical failure of hydraulic actuator. Recommended Depot Inspection & Trust Ledger recording upon repair.",
    status: "TRIAGED",
  },
  {
    id: "INC-2026-090",
    category: "Curb Ramp Obstruction",
    severity: "MEDIUM",
    stopOrBus: "Stop: AIIMS South Gate",
    description: "Two commercial auto-rickshaws parked across tactile paving curb cut, preventing wheelchair passenger from aligning with bus door.",
    aiSummary: "Gemini Triage: Physical access obstruction on municipal property. Ticket dispatched to Traffic Marshall unit.",
    status: "OPEN",
  },
];

export function IncidentQueue() {
  const getSeverityBadge = (severity: string) => {
    switch (severity) {
      case "HIGH":
        return <span className="rounded bg-rose-100 px-2 py-0.5 text-xs font-bold text-rose-800">HIGH</span>;
      case "MEDIUM":
        return <span className="rounded bg-amber-100 px-2 py-0.5 text-xs font-bold text-amber-800">MEDIUM</span>;
      default:
        return <span className="rounded bg-slate-100 px-2 py-0.5 text-xs font-bold text-slate-800">LOW</span>;
    }
  };

  return (
    <div className="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
      <div className="flex items-center justify-between border-b border-slate-100 pb-4">
        <div>
          <h2 className="text-lg font-bold text-slate-900">
            Accessibility Incidents & AI Triage
          </h2>
          <p className="text-xs text-slate-500">
            Unstructured passenger/driver reports interpreted into structured tickets via Google Gemini 2.5 Flash
          </p>
        </div>
        <span className="rounded-md bg-slate-100 px-2.5 py-1 text-xs font-medium text-slate-600">
          2 Active Incidents
        </span>
      </div>

      <div className="mt-4 space-y-3">
        {sampleIncidents.map((inc) => (
          <div
            key={inc.id}
            className="rounded-lg border border-slate-200 p-4 transition-all hover:border-slate-300 bg-slate-50/50"
          >
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="font-mono text-xs font-bold text-slate-700">{inc.id}</span>
                {getSeverityBadge(inc.severity)}
                <span className="text-sm font-semibold text-slate-800">{inc.category}</span>
              </div>
              <span className="text-xs font-medium text-slate-500">{inc.stopOrBus}</span>
            </div>

            <p className="mt-2 text-xs text-slate-600 leading-relaxed">
              {inc.description}
            </p>

            {/* AI Structured summary banner */}
            <div className="mt-3 flex items-start gap-2 rounded-md bg-indigo-50/80 p-2.5 text-xs text-indigo-900 border border-indigo-100">
              <Sparkles className="h-4 w-4 text-indigo-600 flex-shrink-0 mt-0.5" aria-hidden="true" />
              <div>
                <span className="font-semibold text-indigo-800">AI Interpretation: </span>
                <span>{inc.aiSummary}</span>
              </div>
            </div>

            <div className="mt-3 flex items-center justify-end gap-2">
              <button
                type="button"
                className="inline-flex items-center gap-1.5 rounded-lg border border-slate-300 bg-white px-3 py-1.5 text-xs font-medium text-slate-700 hover:bg-slate-50"
              >
                <Wrench className="h-3.5 w-3.5" /> Assign Depot Work Order
              </button>
              <button
                type="button"
                className="inline-flex items-center gap-1.5 rounded-lg bg-indigo-600 px-3 py-1.5 text-xs font-semibold text-white hover:bg-indigo-700"
              >
                <CheckCircle className="h-3.5 w-3.5" /> Resolve & Anchor to Ledger
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
