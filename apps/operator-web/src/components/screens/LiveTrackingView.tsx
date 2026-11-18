"use client";

import React, { useState } from "react";
import {
  Bus,
  Accessibility,
  CheckCircle2,
} from "lucide-react";

export function LiveTrackingView() {
  const [selectedVehicle] = useState("DL 1PD 4421");

  const timelineStops = [
    { name: "Kashmere Gate ISBT", time: "09:45 AM", status: "completed", accessible: true },
    { name: "Red Fort (Lal Qila)", time: "09:56 AM", status: "completed", accessible: true },
    { name: "Delhi Gate", time: "10:08 AM", status: "completed", accessible: false },
    { name: "AIIMS Metro Station (Bay 2)", time: "10:27 AM (In 3 mins)", status: "current", accessible: true },
    { name: "Mehrauli Terminal", time: "10:45 AM", status: "upcoming", accessible: true },
  ];

  return (
    <div className="max-w-4xl mx-auto p-4 sm:p-6 space-y-6">
      {/* Editorial Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
        <div>
          <span className="text-xs font-semibold tracking-wider uppercase text-[#E96835]">
            Telemetry & Geofencing
          </span>
          <h1 className="font-editorial-serif text-3xl font-bold text-[#101B3A]">
            Live Bus Tracking · Route 502
          </h1>
          <p className="text-xs text-[#64748B]">
            Vehicle coordinates updating at 10-second intervals from Delhi Transit Stack.
          </p>
        </div>
        <div className="flex items-center gap-2 rounded-full border border-[#E6DDD0] bg-[#FFFCF7] px-3.5 py-1.5 text-xs font-semibold text-[#16764C]">
          <span className="h-2 w-2 rounded-full bg-[#16764C] animate-ping" />
          <span>Vehicle In Service: 42 km/h</span>
        </div>
      </div>

      {/* Cartographic Interactive Map Simulation Area */}
      <div className="relative h-[380px] w-full rounded-2xl border-2 border-[#E6DDD0] bg-[#EFE7DA] overflow-hidden shadow-editorial">
        {/* Cartographic Vector Background Texture / Map Lines */}
        <svg
          viewBox="0 0 800 400"
          className="w-full h-full object-cover"
          xmlns="http://www.w3.org/2000/svg"
        >
          {/* Subtle Delhi arterial grid */}
          <g stroke="#E0D6C5" strokeWidth="2">
            <line x1="50" y1="0" x2="50" y2="400" />
            <line x1="200" y1="0" x2="200" y2="400" />
            <line x1="380" y1="0" x2="380" y2="400" />
            <line x1="560" y1="0" x2="560" y2="400" />
            <line x1="720" y1="0" x2="720" y2="400" />

            <line x1="0" y1="80" x2="800" y2="80" />
            <line x1="0" y1="180" x2="800" y2="180" />
            <line x1="0" y1="280" x2="800" y2="280" />
          </g>

          {/* Yamuna River Curve in Muted Blue */}
          <path
            d="M620 0 C650 120, 580 260, 680 400"
            stroke="#C5D7E8"
            strokeWidth="32"
            fill="none"
          />

          {/* Route 502 Blue Polyline */}
          <path
            d="M120 70 L260 140 L380 180 L520 280 L620 340"
            stroke="#2563EB"
            strokeWidth="6"
            strokeLinecap="round"
            strokeLinejoin="round"
            fill="none"
          />
          <path
            d="M120 70 L260 140 L380 180 L520 280 L620 340"
            stroke="#93C5FD"
            strokeWidth="2"
            strokeDasharray="6 6"
            strokeLinecap="round"
            strokeLinejoin="round"
            fill="none"
          />

          {/* Stop Markers along route */}
          <g>
            {/* Stop 1 */}
            <circle cx="120" cy="70" r="8" fill="#FFFFFF" stroke="#172653" strokeWidth="3" />
            <text x="135" y="74" fill="#172653" fontSize="12" fontWeight="bold">Kashmere Gate</text>

            {/* Stop 2 */}
            <circle cx="260" cy="140" r="8" fill="#FFFFFF" stroke="#172653" strokeWidth="3" />
            <text x="275" y="144" fill="#172653" fontSize="12" fontWeight="bold">Red Fort</text>

            {/* Stop 3 */}
            <circle cx="380" cy="180" r="8" fill="#FFFFFF" stroke="#172653" strokeWidth="3" />
            <text x="395" y="184" fill="#172653" fontSize="12" fontWeight="bold">Delhi Gate</text>

            {/* Stop 4 (Target Stop: AIIMS) */}
            <circle cx="520" cy="280" r="14" fill="#E4F1E5" stroke="#16764C" strokeWidth="3" />
            <circle cx="520" cy="280" r="6" fill="#16764C" />
            <text x="540" y="285" fill="#16764C" fontSize="13" fontWeight="bold">AIIMS (Ramp Ready)</text>

            {/* Stop 5 */}
            <circle cx="620" cy="340" r="8" fill="#FFFFFF" stroke="#172653" strokeWidth="3" />
            <text x="635" y="344" fill="#172653" fontSize="12" fontWeight="bold">Mehrauli</text>
          </g>

          {/* Active Bus Marker (Approaching Stop 4) */}
          <g transform="translate(470, 235)">
            <circle cx="20" cy="20" r="24" fill="#E96835" opacity="0.2" className="animate-ping" />
            <circle cx="20" cy="20" r="18" fill="#E96835" stroke="#FFFFFF" strokeWidth="3" />
            <path d="M14 20 L26 20 M20 14 L26 20 L20 26" stroke="#FFFFFF" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
          </g>
        </svg>

        {/* Floating Vehicle Information Card */}
        <div className="absolute top-4 left-4 z-20 rounded-xl border border-[#E6DDD0] bg-[#FFFCF7]/95 p-4 shadow-editorial backdrop-blur-xs max-w-xs">
          <div className="flex items-center gap-2">
            <span className="rounded bg-[#172653] px-2 py-0.5 text-xs font-bold text-white">
              ROUTE 502
            </span>
            <span className="font-mono text-xs font-bold text-[#101B3A]">{selectedVehicle}</span>
          </div>
          <p className="mt-1 font-editorial-serif text-lg font-bold text-[#101B3A]">
            Arriving in 3 mins
          </p>
          <div className="mt-1 flex items-center gap-3 text-xs text-[#64748B]">
            <span className="flex items-center gap-1 text-[#16764C] font-semibold">
              <Accessibility className="h-3.5 w-3.5" /> Ramp Ready
            </span>
            <span>•</span>
            <span>Low Crowding</span>
          </div>
        </div>

        {/* Floating Map Controls */}
        <div className="absolute bottom-4 right-4 z-20 flex flex-col gap-1.5 rounded-lg border border-[#E6DDD0] bg-[#FFFCF7] p-1 shadow-sm">
          <button className="h-8 w-8 flex items-center justify-center font-bold text-[#101B3A] hover:bg-[#FAF5EE] rounded text-sm">+</button>
          <div className="h-px bg-[#E6DDD0]" />
          <button className="h-8 w-8 flex items-center justify-center font-bold text-[#101B3A] hover:bg-[#FAF5EE] rounded text-sm">−</button>
        </div>
      </div>

      {/* Stop-by-Stop Progress Timeline */}
      <div className="rounded-xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial">
        <h2 className="text-sm font-bold uppercase tracking-wider text-[#64748B] mb-4">
          Route Progression & Stop Sequence
        </h2>

        <div className="space-y-4">
          {timelineStops.map((stop, idx) => {
            const isCompleted = stop.status === "completed";
            const isCurrent = stop.status === "current";

            return (
              <div key={stop.name} className="flex items-start gap-4 relative">
                {/* Connecting Line */}
                {idx < timelineStops.length - 1 && (
                  <div
                    className={`absolute left-4 top-8 -bottom-4 w-0.5 ${
                      isCompleted ? "bg-[#16764C]" : "bg-[#E6DDD0]"
                    }`}
                  />
                )}

                {/* Node Indicator */}
                <div
                  className={`relative z-10 flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full border-2 ${
                    isCurrent
                      ? "border-[#E96835] bg-[#E96835] text-white shadow-xs"
                      : isCompleted
                      ? "border-[#16764C] bg-[#E4F1E5] text-[#16764C]"
                      : "border-[#CBD5E1] bg-white text-[#94A3B8]"
                  }`}
                >
                  {isCompleted ? (
                    <CheckCircle2 className="h-4 w-4" />
                  ) : isCurrent ? (
                    <Bus className="h-4 w-4 animate-bounce" />
                  ) : (
                    <span className="text-xs font-bold">{idx + 1}</span>
                  )}
                </div>

                {/* Stop Metadata */}
                <div className="flex-1 flex flex-col sm:flex-row sm:items-center justify-between pb-3">
                  <div>
                    <div className="flex items-center gap-2">
                      <span
                        className={`text-sm font-bold ${
                          isCurrent ? "text-[#E96835]" : "text-[#101B3A]"
                        }`}
                      >
                        {stop.name}
                      </span>
                      {stop.accessible && (
                        <span className="rounded bg-[#E4F1E5] px-1.5 py-0.5 text-[10px] font-semibold text-[#16764C]">
                          AccessGraph ✓
                        </span>
                      )}
                    </div>
                    <p className="text-xs text-[#64748B]">Scheduled: {stop.time}</p>
                  </div>

                  {isCurrent && (
                    <div className="mt-2 sm:mt-0">
                      <span className="rounded-full bg-[#FCECDD] border border-[#E96835]/30 px-3 py-1 text-xs font-bold text-[#E96835]">
                        Target Boarding Bay
                      </span>
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
