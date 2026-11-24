"use client";

import React, { useEffect, useState } from "react";
import { Users, Accessibility, ArrowRight, Radio, CheckCircle2 } from "lucide-react";

interface RouteStatus {
  routeNumber: string;
  routeName: string;
  activeBuses: number;
  lowFloorBuses: number;
  averageCrowding: "LOW" | "MEDIUM" | "HIGH" | "OVERCROWDED";
  occupancyPercent: number;
  headwayMinutes: number;
}

interface LiveVehicleItem {
  vehicleId: string;
  registrationNumber: string;
  routeId: string;
  routeShortName: string;
  coordinates: { latitude: number; longitude: number };
  speedKmh: number;
  bearing: number;
  crowdingTier: string;
  occupancyPercentage: number;
  isLowFloor: boolean;
  hasOperationalRamp: boolean;
  isStale: boolean;
  freshnessSeconds: number;
  lastUpdated: string;
}

const defaultRoutes: RouteStatus[] = [
  {
    routeNumber: "502",
    routeName: "Kashmere Gate ISBT ⟷ Mehrauli Terminal",
    activeBuses: 18,
    lowFloorBuses: 14,
    averageCrowding: "MEDIUM",
    occupancyPercent: 54,
    headwayMinutes: 8,
  },
  {
    routeNumber: "TMS(+)",
    routeName: "Teevra Mudrika Seva (Ring Road Clockwise)",
    activeBuses: 32,
    lowFloorBuses: 28,
    averageCrowding: "HIGH",
    occupancyPercent: 82,
    headwayMinutes: 5,
  },
  {
    routeNumber: "534",
    routeName: "Anand Vihar ISBT ⟷ Mehrauli",
    activeBuses: 12,
    lowFloorBuses: 8,
    averageCrowding: "LOW",
    occupancyPercent: 28,
    headwayMinutes: 12,
  },
];

export function FleetOverview() {
  const [liveVehicles, setLiveVehicles] = useState<LiveVehicleItem[]>([]);
  const [feedStatus, setFeedStatus] = useState<string>("Connecting...");
  const [lastRefreshed, setLastRefreshed] = useState<string>("");

  useEffect(() => {
    async function fetchFleet() {
      try {
        const res = await fetch("http://localhost:8000/api/v1/operator/fleet/live");
        if (res.ok) {
          const json = await res.json();
          if (json.success && Array.isArray(json.data)) {
            setLiveVehicles(json.data);
            setFeedStatus("GTFS-RT Active");
            setLastRefreshed(new Date().toLocaleTimeString());
          }
        }
      } catch {
        setFeedStatus("Schedule Baseline");
      }
    }

    fetchFleet();
    const interval = setInterval(fetchFleet, 15000);
    return () => clearInterval(interval);
  }, []);

  const getCrowdingStyle = (tier: string) => {
    switch (tier) {
      case "LOW":
        return "bg-emerald-100 text-emerald-800 border-emerald-200";
      case "MEDIUM":
        return "bg-amber-100 text-amber-800 border-amber-200";
      case "HIGH":
        return "bg-orange-100 text-orange-800 border-orange-200";
      default:
        return "bg-rose-100 text-rose-800 border-rose-200";
    }
  };

  return (
    <div className="rounded-yatra-card border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between border-b border-[#E6DDD0] pb-4 gap-4">
        <div className="flex items-center gap-4">
          <div className="h-14 w-20 flex-shrink-0 rounded-yatra-card overflow-hidden border border-[#E6DDD0] bg-[#FAF5EE]">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src="/assets/illustrations/delhi-bus-isometric.png"
              alt="Low-Floor DTC Bus"
              className="h-full w-full object-cover"
            />
          </div>
          <div>
            <h2 className="text-lg font-bold font-editorial-serif text-[#101B3A]">
              Delhi transit corridor and crowding overview
            </h2>
            <p className="text-xs text-[#64748B]">
              Headway-based occupancy estimates from Delhi Transit Stack telemetry
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <span className="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 border border-emerald-200 px-2.5 py-1 text-[11px] font-semibold text-emerald-800">
            <Radio className="h-3 w-3 text-emerald-600 animate-pulse" />
            <span>{feedStatus}</span>
          </span>
          {lastRefreshed && (
            <span className="text-[11px] text-slate-500 font-mono">
              {lastRefreshed}
            </span>
          )}
        </div>
      </div>

      {/* Live Fleet Telemetry Strip if vehicles present */}
      {liveVehicles.length > 0 && (
        <div className="mt-4 p-3 rounded-lg bg-slate-50 border border-slate-200">
          <div className="flex items-center justify-between pb-2">
            <span className="text-xs font-bold text-slate-700 flex items-center gap-1.5">
              <CheckCircle2 className="h-3.5 w-3.5 text-emerald-600" />
              Live bus positions ({liveVehicles.length} reporting)
            </span>
            <span className="text-[11px] text-slate-500">
              Source: Delhi Transport Stack GTFS-RT
            </span>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-2.5 pt-1">
            {liveVehicles.map((v) => (
              <div
                key={v.vehicleId}
                className="flex items-center justify-between p-2 rounded bg-white border border-slate-200 text-xs shadow-2xs"
              >
                <div>
                  <div className="flex items-center gap-1.5">
                    <span className="font-mono font-bold text-slate-900">{v.vehicleId}</span>
                    <span className="rounded bg-indigo-50 border border-indigo-200 px-1 py-0.2 text-[10px] font-bold text-indigo-700">
                      Route {v.routeShortName}
                    </span>
                  </div>
                  <div className="text-[11px] text-slate-500 mt-0.5">
                    Speed: {v.speedKmh} km/h · {v.freshnessSeconds}s ago
                  </div>
                </div>
                <div className="text-right">
                  <span className={`px-1.5 py-0.5 rounded text-[10px] font-semibold ${
                    v.isLowFloor ? "bg-emerald-50 text-emerald-700 border border-emerald-200" : "bg-slate-100 text-slate-600"
                  }`}>
                    {v.isLowFloor ? "Low Floor" : "Standard"}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="mt-4 space-y-3">
        {defaultRoutes.map((route) => (
          <div
            key={route.routeNumber}
            className="flex flex-col sm:flex-row items-start sm:items-center justify-between rounded-lg border border-slate-200 p-4 hover:border-slate-300 transition-colors gap-3 bg-white"
          >
            <div className="space-y-1">
              <div className="flex items-center gap-2">
                <span className="rounded bg-indigo-600 px-2 py-0.5 text-xs font-bold text-white">
                  {route.routeNumber}
                </span>
                <span className="text-sm font-semibold text-slate-800">
                  {route.routeName}
                </span>
              </div>
              <div className="flex items-center gap-4 text-xs text-slate-500">
                <span className="flex items-center gap-1">
                  <Users className="h-3.5 w-3.5" /> {route.activeBuses} active buses ({route.headwayMinutes}m headway)
                </span>
                <span className="flex items-center gap-1 text-indigo-600 font-medium">
                  <Accessibility className="h-3.5 w-3.5" /> {route.lowFloorBuses} low-floor buses
                </span>
              </div>
            </div>

            <div className="flex items-center gap-3 w-full sm:w-auto justify-between sm:justify-end">
              <div className="text-right">
                <div className="flex items-center gap-1.5 justify-end">
                  <span
                    className={`rounded border px-2 py-0.5 text-xs font-semibold ${getCrowdingStyle(
                      route.averageCrowding
                    )}`}
                  >
                    {route.averageCrowding} ({route.occupancyPercent}%)
                  </span>
                </div>
                <div className="mt-1 w-28 bg-slate-100 rounded-full h-1.5 overflow-hidden">
                  <div
                    className={`h-full ${
                      route.occupancyPercent > 70
                        ? "bg-rose-500"
                        : route.occupancyPercent > 40
                        ? "bg-amber-500"
                        : "bg-emerald-500"
                    }`}
                    style={{ width: `${route.occupancyPercent}%` }}
                  />
                </div>
              </div>

              <button
                type="button"
                aria-label={`View detailed telemetry for Route ${route.routeNumber}`}
                className="rounded-lg p-2 text-slate-400 hover:bg-slate-100 hover:text-slate-700"
              >
                <ArrowRight className="h-4 w-4" />
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

