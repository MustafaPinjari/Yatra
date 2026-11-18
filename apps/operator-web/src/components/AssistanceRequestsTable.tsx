import React from "react";
import { CheckCircle2, Clock, AlertCircle, Accessibility, Eye, HelpCircle } from "lucide-react";

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

const sampleRequests: RequestItem[] = [
  {
    id: "REQ-DEL-101",
    routeNumber: "502",
    stopName: "AIIMS Metro Station (Stop 04)",
    passengerType: "Commuter (Wheelchair)",
    assistanceType: "WHEELCHAIR_RAMP",
    status: "ACKNOWLEDGED",
    driverAck: true,
    busNumber: "DL 1PD 4421",
    timeRequested: "2 mins ago",
  },
  {
    id: "REQ-DEL-102",
    routeNumber: "TMS(+)",
    stopName: "Kashmere Gate ISBT",
    passengerType: "Senior Citizen (Vision Impaired)",
    assistanceType: "VISION_ASSIST",
    status: "PENDING",
    driverAck: false,
    busNumber: "DL 1PC 8902",
    timeRequested: "4 mins ago",
  },
  {
    id: "REQ-DEL-103",
    routeNumber: "534",
    stopName: "Nehru Place Terminal",
    passengerType: "Commuter with Crutches",
    assistanceType: "MOBILITY_TIME",
    status: "BOARDING",
    driverAck: true,
    busNumber: "DL 1PD 3311",
    timeRequested: "6 mins ago",
  },
];

export function AssistanceRequestsTable() {
  const getIcon = (type: string) => {
    switch (type) {
      case "WHEELCHAIR_RAMP":
        return <Accessibility className="h-4 w-4 text-indigo-600" aria-hidden="true" />;
      case "VISION_ASSIST":
        return <Eye className="h-4 w-4 text-amber-600" aria-hidden="true" />;
      default:
        return <HelpCircle className="h-4 w-4 text-emerald-600" aria-hidden="true" />;
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "ACKNOWLEDGED":
        return (
          <span className="inline-flex items-center gap-1.5 rounded-full bg-emerald-100 px-2.5 py-0.5 text-xs font-semibold text-emerald-800">
            <CheckCircle2 className="h-3 w-3" /> Driver Acknowledged
          </span>
        );
      case "PENDING":
        return (
          <span className="inline-flex items-center gap-1.5 rounded-full bg-amber-100 px-2.5 py-0.5 text-xs font-semibold text-amber-800">
            <Clock className="h-3 w-3 animate-spin" /> Awaiting Acknowledgment
          </span>
        );
      case "BOARDING":
        return (
          <span className="inline-flex items-center gap-1.5 rounded-full bg-blue-100 px-2.5 py-0.5 text-xs font-semibold text-blue-800">
            <AlertCircle className="h-3 w-3" /> Boarding in Progress
          </span>
        );
      default:
        return <span className="text-xs text-slate-500">{status}</span>;
    }
  };

  return (
    <div className="rounded-yatra-card border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between border-b border-[#E6DDD0] pb-4 gap-4">
        <div className="flex items-center gap-4">
          <div className="h-14 w-20 flex-shrink-0 rounded-yatra-card overflow-hidden border border-[#E6DDD0] bg-[#FAF5EE]">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src="/assets/illustrations/boarding-assistance-empathy.png"
              alt="Passenger-Driver Assistance Empathy"
              className="h-full w-full object-cover"
            />
          </div>
          <div>
            <h2 className="text-lg font-bold font-editorial-serif text-[#101B3A]">
              Live AccessHandshake Assistance Queue
            </h2>
            <p className="text-xs text-[#64748B]">
              Real-time boarding assistance alerts synchronized via Redis between passenger mobile and driver consoles
            </p>
          </div>
        </div>
        <span className="rounded-md bg-[#FAF5EE] border border-[#E6DDD0] px-2.5 py-1 text-xs font-semibold text-[#172653]">
          Showing 3 Live Requests
        </span>
      </div>

      <div className="mt-4 overflow-x-auto">
        <table className="w-full text-left text-sm text-slate-600">
          <thead className="bg-slate-50 text-xs font-semibold uppercase text-slate-500">
            <tr>
              <th scope="col" className="px-4 py-3">Request ID & Route</th>
              <th scope="col" className="px-4 py-3">Bus Stop</th>
              <th scope="col" className="px-4 py-3">Assistance Required</th>
              <th scope="col" className="px-4 py-3">Assigned Vehicle</th>
              <th scope="col" className="px-4 py-3">Handshake Status</th>
              <th scope="col" className="px-4 py-3">Time</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {sampleRequests.map((req) => (
              <tr key={req.id} className="hover:bg-slate-50/80 transition-colors">
                <td className="px-4 py-3.5 font-medium text-slate-900">
                  <div className="flex items-center gap-2">
                    <span className="rounded bg-indigo-600 px-1.5 py-0.5 text-xs font-bold text-white">
                      {req.routeNumber}
                    </span>
                    <span className="text-xs text-slate-500">{req.id}</span>
                  </div>
                </td>
                <td className="px-4 py-3.5 font-medium text-slate-800">
                  {req.stopName}
                </td>
                <td className="px-4 py-3.5">
                  <div className="flex items-center gap-2">
                    {getIcon(req.assistanceType)}
                    <span className="text-xs font-medium text-slate-700">
                      {req.assistanceType.replace("_", " ")}
                    </span>
                  </div>
                  <p className="text-[11px] text-slate-400">{req.passengerType}</p>
                </td>
                <td className="px-4 py-3.5 text-xs font-mono font-medium text-slate-800">
                  {req.busNumber}
                </td>
                <td className="px-4 py-3.5">{getStatusBadge(req.status)}</td>
                <td className="px-4 py-3.5 text-xs text-slate-400">
                  {req.timeRequested}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
