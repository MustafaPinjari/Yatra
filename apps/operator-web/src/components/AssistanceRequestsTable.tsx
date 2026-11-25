"use client";

import React, { useState } from "react";
import { CheckCircle2, Clock, Accessibility, Eye, HelpCircle, Check, ArrowRight } from "lucide-react";

interface RequestItem {
  id: string;
  routeNumber: string;
  stopName: string;
  passengerType: string;
  assistanceType: "WHEELCHAIR_RAMP" | "VISION_ASSIST" | "MOBILITY_TIME";
  status: "ACKNOWLEDGED" | "PENDING" | "BOARDING" | "COMPLETED";
  driverAck: boolean;
  busNumber: string;
  timeRequested: string;
}

const initialRequests: RequestItem[] = [
  {
    id: "REQ-DEL-101",
    routeNumber: "502",
    stopName: "AIIMS Metro Station (Bay 04)",
    passengerType: "Commuter (Wheelchair)",
    assistanceType: "WHEELCHAIR_RAMP",
    status: "ACKNOWLEDGED",
    driverAck: true,
    busNumber: "DL 1PD 4421",
    timeRequested: "2 min ago",
  },
  {
    id: "REQ-DEL-102",
    routeNumber: "TMS(+)",
    stopName: "Kashmere Gate ISBT",
    passengerType: "Senior citizen (Vision impaired)",
    assistanceType: "VISION_ASSIST",
    status: "PENDING",
    driverAck: false,
    busNumber: "DL 1PC 8902",
    timeRequested: "4 min ago",
  },
  {
    id: "REQ-DEL-103",
    routeNumber: "534",
    stopName: "Nehru Place Terminal",
    passengerType: "Commuter with crutches",
    assistanceType: "MOBILITY_TIME",
    status: "BOARDING",
    driverAck: true,
    busNumber: "DL 1PD 3311",
    timeRequested: "6 min ago",
  },
  {
    id: "REQ-DEL-104",
    routeNumber: "502",
    stopName: "Hauz Khas IIT Gate",
    passengerType: "Wheelchair passenger",
    assistanceType: "WHEELCHAIR_RAMP",
    status: "PENDING",
    driverAck: false,
    busNumber: "DL 1PD 9012",
    timeRequested: "8 min ago",
  },
];

export function AssistanceRequestsTable() {
  const [requests, setRequests] = useState<RequestItem[]>(initialRequests);
  const [filterType, setFilterType] = useState<string>("ALL");

  const toggleAcknowledge = (id: string) => {
    setRequests((prev) =>
      prev.map((req) =>
        req.id === id
          ? {
              ...req,
              driverAck: !req.driverAck,
              status: !req.driverAck ? "ACKNOWLEDGED" : "PENDING",
            }
          : req
      )
    );
  };

  const filtered = requests.filter((r) => {
    if (filterType === "ALL") return true;
    return r.assistanceType === filterType;
  });

  const getAssistanceLabel = (type: string) => {
    switch (type) {
      case "WHEELCHAIR_RAMP":
        return "Wheelchair hydraulic ramp";
      case "VISION_ASSIST":
        return "Visual guidance assistance";
      default:
        return "Step-free extra boarding time";
    }
  };

  const getIcon = (type: string) => {
    switch (type) {
      case "WHEELCHAIR_RAMP":
        return <Accessibility className="h-4 w-4 text-[#E96835]" aria-hidden="true" />;
      case "VISION_ASSIST":
        return <Eye className="h-4 w-4 text-[#D97706]" aria-hidden="true" />;
      default:
        return <HelpCircle className="h-4 w-4 text-[#16764C]" aria-hidden="true" />;
    }
  };

  const getStatusBadge = (status: string, ack: boolean) => {
    if (ack || status === "ACKNOWLEDGED") {
      return (
        <span className="inline-flex items-center gap-1.5 rounded-full bg-[#E4F1E5] px-2.5 py-0.5 text-xs font-semibold text-[#16764C]">
          <CheckCircle2 className="h-3.5 w-3.5" /> Driver acknowledged
        </span>
      );
    }
    if (status === "BOARDING") {
      return (
        <span className="inline-flex items-center gap-1.5 rounded-full bg-[#EFF6FF] px-2.5 py-0.5 text-xs font-semibold text-[#2563EB]">
          <Clock className="h-3.5 w-3.5" /> Boarding in progress
        </span>
      );
    }
    return (
      <span className="inline-flex items-center gap-1.5 rounded-full bg-[#FEF3C7] px-2.5 py-0.5 text-xs font-semibold text-[#D97706]">
        <Clock className="h-3.5 w-3.5" /> Awaiting driver ack
      </span>
    );
  };

  return (
    <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial">
      {/* Header with Filters */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-[#E6DDD0]">
        <div>
          <h2 className="font-editorial-serif text-xl font-bold text-[#101B3A]">
            Boarding assistance requests
          </h2>
          <p className="text-xs text-[#64748B] mt-1">
            Real-time AccessHandshake requests from passengers at bus stop bays
          </p>
        </div>

        {/* Filter Pills */}
        <div className="flex items-center gap-1 bg-[#F7F2E9] p-1 rounded-xl border border-[#E6DDD0] text-xs">
          <button
            onClick={() => setFilterType("ALL")}
            className={`px-3 py-1 rounded-lg font-medium transition-colors cursor-pointer ${
              filterType === "ALL"
                ? "bg-[#101B3A] text-white font-semibold"
                : "text-[#64748B] hover:text-[#101B3A]"
            }`}
          >
            All
          </button>
          <button
            onClick={() => setFilterType("WHEELCHAIR_RAMP")}
            className={`px-3 py-1 rounded-lg font-medium transition-colors cursor-pointer ${
              filterType === "WHEELCHAIR_RAMP"
                ? "bg-[#E96835] text-white font-semibold"
                : "text-[#64748B] hover:text-[#101B3A]"
            }`}
          >
            Wheelchair ramp
          </button>
          <button
            onClick={() => setFilterType("VISION_ASSIST")}
            className={`px-3 py-1 rounded-lg font-medium transition-colors cursor-pointer ${
              filterType === "VISION_ASSIST"
                ? "bg-[#D97706] text-white font-semibold"
                : "text-[#64748B] hover:text-[#101B3A]"
            }`}
          >
            Visual guide
          </button>
          <button
            onClick={() => setFilterType("MOBILITY_TIME")}
            className={`px-3 py-1 rounded-lg font-medium transition-colors cursor-pointer ${
              filterType === "MOBILITY_TIME"
                ? "bg-[#16764C] text-white font-semibold"
                : "text-[#64748B] hover:text-[#101B3A]"
            }`}
          >
            Extra time
          </button>
        </div>
      </div>

      {/* Table */}
      <div className="mt-4 overflow-x-auto">
        <table className="w-full text-left text-xs border-collapse">
          <thead>
            <tr className="border-b border-[#E6DDD0] bg-[#F7F2E9] text-[#64748B] font-semibold">
              <th className="py-3 px-3">Request ID</th>
              <th className="py-3 px-3">Route & stop</th>
              <th className="py-3 px-3">Assistance required</th>
              <th className="py-3 px-3">Assigned bus & driver</th>
              <th className="py-3 px-3">Status</th>
              <th className="py-3 px-3 text-right">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-[#E6DDD0]">
            {filtered.map((req) => (
              <tr key={req.id} className="hover:bg-[#F7F2E9]/60 transition-colors">
                <td className="py-3.5 px-3">
                  <div className="flex flex-col">
                    <span className="font-mono font-bold text-[#101B3A]">{req.id}</span>
                    <span className="text-[10px] text-[#64748B] tabular-nums">{req.timeRequested}</span>
                  </div>
                </td>

                <td className="py-3.5 px-3">
                  <div className="flex items-center gap-2">
                    <span className="font-mono text-xs font-bold px-2 py-0.5 rounded-md bg-[#E96835]/12 text-[#E96835]">
                      {req.routeNumber}
                    </span>
                    <span className="font-medium text-[#101B3A]">{req.stopName}</span>
                  </div>
                  <p className="text-[11px] text-[#64748B] mt-0.5">{req.passengerType}</p>
                </td>

                <td className="py-3.5 px-3">
                  <div className="flex items-center gap-1.5 text-[#334155] font-medium">
                    {getIcon(req.assistanceType)}
                    <span>{getAssistanceLabel(req.assistanceType)}</span>
                  </div>
                </td>

                <td className="py-3.5 px-3">
                  <span className="font-mono font-semibold text-[#101B3A]">{req.busNumber}</span>
                  <p className="text-[11px] text-[#64748B]">Assigned low-floor bus</p>
                </td>

                <td className="py-3.5 px-3">
                  {getStatusBadge(req.status, req.driverAck)}
                </td>

                <td className="py-3.5 px-3 text-right">
                  <button
                    onClick={() => toggleAcknowledge(req.id)}
                    className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs font-semibold transition-colors cursor-pointer ${
                      req.driverAck
                        ? "bg-[#E4F1E5] text-[#16764C] hover:bg-[#16764C]/15 border border-[#16764C]/25"
                        : "bg-[#E96835] text-white hover:bg-[#d05726]"
                    }`}
                  >
                    <Check className="h-3 w-3" />
                    <span>{req.driverAck ? "Confirmed" : "Confirm"}</span>
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
