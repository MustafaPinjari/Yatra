"use client";

import React, { useState } from "react";
import {
  Bus,
  Train,
  Shuffle,
  Accessibility,
  SlidersHorizontal,
  CheckCircle2,
  Users,
} from "lucide-react";

export function JourneyPlannerView() {
  const [transitMode, setTransitMode] = useState<"BUS" | "METRO" | "MULTIMODAL">("BUS");
  const [origin, setOrigin] = useState("Kashmere Gate ISBT");
  const [destination, setDestination] = useState("AIIMS Metro Station (South Gate)");
  const [requireRamp, setRequireRamp] = useState(true);
  const [preferLowCrowd, setPreferLowCrowd] = useState(true);

  const recommendedRoute = {
    duration: "42",
    unit: "mins",
    routeNumber: "502",
    departure: "09:45 AM",
    arrival: "10:27 AM",
    transfers: "Direct (0 transfers)",
    crowdingTier: "Low Crowding (28%)",
    rampStatus: "Hydraulic Ramp Verified",
    fare: "₹15",
  };

  const alternativeRoutes = [
    {
      id: "alt-1",
      mode: "Multimodal",
      summary: "Metro Yellow Line + 534 Feeder Bus",
      duration: "38 mins",
      crowding: "Medium (52%)",
      stepFree: "Step-free with lifts",
      fare: "₹30",
    },
    {
      id: "alt-2",
      mode: "Bus",
      summary: "TMS(+) Ring Road Direct",
      duration: "51 mins",
      crowding: "High (78%)",
      stepFree: "Low-Floor Bus",
      fare: "₹15",
    },
  ];

  return (
    <div className="max-w-2xl mx-auto p-4 sm:p-6 space-y-6">
      {/* Editorial Heading */}
      <div className="space-y-1">
        <span className="text-xs font-semibold tracking-wider uppercase text-[#E96835]">
          Deterministic Travel Intelligence
        </span>
        <h1 className="font-editorial-serif text-3xl sm:text-4xl font-bold text-[#101B3A]">
          Plan Accessible Journey
        </h1>
        <p className="text-xs text-[#64748B]">
          Multi-criteria routing balancing travel time, micro-accessibility, and predicted crowding.
        </p>
      </div>

      {/* Mode Selectors */}
      <div className="flex rounded-xl border border-[#E6DDD0] bg-[#FFFCF7] p-1 shadow-subtle">
        <button
          onClick={() => setTransitMode("BUS")}
          className={`flex-1 flex items-center justify-center gap-2 rounded-lg py-2 text-xs font-bold transition-colors cursor-pointer ${
            transitMode === "BUS"
              ? "bg-[#172653] text-white shadow-xs"
              : "text-[#64748B] hover:text-[#101B3A]"
          }`}
        >
          <Bus className="h-4 w-4" />
          <span>Bus Only</span>
        </button>
        <button
          onClick={() => setTransitMode("METRO")}
          className={`flex-1 flex items-center justify-center gap-2 rounded-lg py-2 text-xs font-bold transition-colors cursor-pointer ${
            transitMode === "METRO"
              ? "bg-[#172653] text-white shadow-xs"
              : "text-[#64748B] hover:text-[#101B3A]"
          }`}
        >
          <Train className="h-4 w-4" />
          <span>Metro</span>
        </button>
        <button
          onClick={() => setTransitMode("MULTIMODAL")}
          className={`flex-1 flex items-center justify-center gap-2 rounded-lg py-2 text-xs font-bold transition-colors cursor-pointer ${
            transitMode === "MULTIMODAL"
              ? "bg-[#172653] text-white shadow-xs"
              : "text-[#64748B] hover:text-[#101B3A]"
          }`}
        >
          <Shuffle className="h-4 w-4" />
          <span>Multimodal</span>
        </button>
      </div>

      {/* Origin / Destination Card */}
      <div className="rounded-xl border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial space-y-4">
        <div className="space-y-3">
          <div>
            <label className="block text-[11px] font-bold uppercase tracking-wider text-[#64748B] mb-1">
              Origin (Starting Point)
            </label>
            <input
              type="text"
              value={origin}
              onChange={(e) => setOrigin(e.target.value)}
              className="w-full rounded-lg border border-[#E6DDD0] bg-[#FAF5EE] px-3.5 py-2.5 text-sm font-medium text-[#101B3A] focus:border-[#E96835] focus:outline-hidden"
            />
          </div>

          <div>
            <label className="block text-[11px] font-bold uppercase tracking-wider text-[#64748B] mb-1">
              Destination
            </label>
            <input
              type="text"
              value={destination}
              onChange={(e) => setDestination(e.target.value)}
              className="w-full rounded-lg border border-[#E6DDD0] bg-[#FAF5EE] px-3.5 py-2.5 text-sm font-medium text-[#101B3A] focus:border-[#E96835] focus:outline-hidden"
            />
          </div>
        </div>

        {/* Accessibility Preferences Controls */}
        <div className="pt-3 border-t border-[#E6DDD0] space-y-2">
          <div className="flex items-center justify-between">
            <span className="flex items-center gap-1.5 text-xs font-semibold text-[#101B3A]">
              <SlidersHorizontal className="h-3.5 w-3.5 text-[#E96835]" />
              Accessibility Preferences
            </span>
            <span className="text-[11px] text-[#64748B]">Filter Active</span>
          </div>

          <div className="flex flex-wrap gap-2 pt-1">
            <button
              onClick={() => setRequireRamp(!requireRamp)}
              className={`rounded-full px-3 py-1 text-xs font-semibold flex items-center gap-1.5 border cursor-pointer transition-colors ${
                requireRamp
                  ? "bg-[#E4F1E5] text-[#16764C] border-[#16764C]/40"
                  : "bg-white text-[#64748B] border-[#E6DDD0]"
              }`}
            >
              <CheckCircle2 className="h-3.5 w-3.5" />
              <span>Wheelchair Ramp Required</span>
            </button>

            <button
              onClick={() => setPreferLowCrowd(!preferLowCrowd)}
              className={`rounded-full px-3 py-1 text-xs font-semibold flex items-center gap-1.5 border cursor-pointer transition-colors ${
                preferLowCrowd
                  ? "bg-[#FCECDD] text-[#E96835] border-[#E96835]/40"
                  : "bg-white text-[#64748B] border-[#E6DDD0]"
              }`}
            >
              <Users className="h-3.5 w-3.5" />
              <span>Low Crowding Priority</span>
            </button>
          </div>
        </div>
      </div>

      {/* Recommended Route Section with Large Editorial Numerals */}
      <div className="rounded-2xl border-2 border-[#16764C]/30 bg-[#FFFCF7] p-6 shadow-editorial relative overflow-hidden">
        <div className="absolute top-0 right-0 bg-[#16764C] text-white text-[10px] font-bold uppercase tracking-widest px-3 py-1 rounded-bl-lg">
          Optimal Accessible Path
        </div>

        <div className="flex flex-col sm:flex-row sm:items-baseline justify-between gap-2">
          <div>
            <div className="flex items-center gap-2">
              <span className="rounded bg-[#172653] px-2.5 py-1 text-sm font-bold text-white">
                ROUTE {recommendedRoute.routeNumber}
              </span>
              <span className="text-xs font-semibold text-[#16764C] flex items-center gap-1">
                <Accessibility className="h-4 w-4" /> {recommendedRoute.rampStatus}
              </span>
            </div>
            <p className="mt-1 text-xs text-[#64748B]">
              Direct DTC Non-Stop Low-Floor • Fare: {recommendedRoute.fare}
            </p>
          </div>

          {/* Large Serif Numerals */}
          <div className="text-left sm:text-right mt-2 sm:mt-0">
            <span className="font-editorial-serif text-5xl font-black text-[#101B3A]">
              {recommendedRoute.duration}
            </span>
            <span className="font-editorial-serif text-xl font-normal text-[#64748B] ml-1">
              {recommendedRoute.unit}
            </span>
          </div>
        </div>

        {/* Route Details Strip */}
        <div className="mt-5 grid grid-cols-3 gap-2 pt-4 border-t border-[#E6DDD0] text-center text-xs">
          <div>
            <p className="text-[#64748B]">Departure</p>
            <p className="font-bold text-[#101B3A]">{recommendedRoute.departure}</p>
          </div>
          <div className="border-x border-[#E6DDD0]">
            <p className="text-[#64748B]">Predicted Crowding</p>
            <p className="font-bold text-[#16764C]">{recommendedRoute.crowdingTier}</p>
          </div>
          <div>
            <p className="text-[#64748B]">Arrival</p>
            <p className="font-bold text-[#101B3A]">{recommendedRoute.arrival}</p>
          </div>
        </div>
      </div>

      {/* Alternative Routes */}
      <div className="space-y-2.5">
        <h2 className="text-xs font-bold uppercase tracking-wider text-[#64748B]">
          Alternative Travel Options
        </h2>
        {alternativeRoutes.map((alt) => (
          <div
            key={alt.id}
            className="flex items-center justify-between p-4 rounded-xl border border-[#E6DDD0] bg-[#FFFCF7] hover:border-[#CBD5E1] transition-all cursor-pointer"
          >
            <div className="space-y-1">
              <div className="flex items-center gap-2">
                <span className="rounded bg-[#FAF5EE] border border-[#E6DDD0] px-2 py-0.5 text-[10px] font-bold text-[#172653]">
                  {alt.mode}
                </span>
                <span className="text-sm font-semibold text-[#101B3A]">
                  {alt.summary}
                </span>
              </div>
              <p className="text-xs text-[#64748B]">
                {alt.stepFree} • Crowding: {alt.crowding}
              </p>
            </div>
            <div className="text-right">
              <span className="font-editorial-serif text-xl font-bold text-[#101B3A]">
                {alt.duration}
              </span>
              <p className="text-[11px] text-[#64748B]">{alt.fare}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
