"use client";

import React, { useState } from "react";
import { AssetPlaceholder } from "@/components/AssetPlaceholder";
import { AssistanceEmpathySvg } from "@/components/illustrations/AssistanceEmpathySvg";
import {
  Accessibility,
  Eye,
  HeartHandshake,
  HelpCircle,
  CheckCircle2,
  Send,
  Radio,
} from "lucide-react";

export function AssistanceScreen() {
  const [selectedCategory, setSelectedCategory] = useState("wheelchair");
  const [requestStatus, setRequestStatus] = useState<"IDLE" | "SENDING" | "ACKNOWLEDGED">("IDLE");
  const [selectedRoute, setSelectedRoute] = useState("502");

  const categories = [
    {
      id: "wheelchair",
      assetId: "YATRA-ILL-005",
      title: "Wheelchair Ramp",
      desc: "Hydraulic kneeling & ramp extension",
      icon: Accessibility,
    },
    {
      id: "vision",
      assetId: "YATRA-ILL-006",
      title: "Vision & Audio",
      desc: "Audio beacon & verbal conductor guide",
      icon: Eye,
    },
    {
      id: "elderly",
      assetId: "YATRA-ILL-007",
      title: "Elderly & Mobility",
      desc: "Low curb alignment & boarding time",
      icon: HeartHandshake,
    },
    {
      id: "other",
      assetId: "YATRA-ILL-005",
      title: "Special Support",
      desc: "Luggage, stroller or cognitive assist",
      icon: HelpCircle,
    },
  ];

  const handleSendRequest = () => {
    setRequestStatus("SENDING");
    setTimeout(() => {
      setRequestStatus("ACKNOWLEDGED");
    }, 1200);
  };

  return (
    <div className="max-w-2xl mx-auto p-4 sm:p-6 space-y-6">
      {/* Editorial Header */}
      <div className="space-y-1">
        <span className="text-xs font-semibold tracking-wider uppercase text-[#E96835]">
          AccessHandshake Protocol
        </span>
        <h1 className="font-editorial-serif text-3xl sm:text-4xl font-bold text-[#101B3A]">
          Passenger Boarding Assistance
        </h1>
        <p className="text-xs text-[#64748B]">
          Direct passenger-to-driver communication alerting oncoming buses before arrival at the stop.
        </p>
      </div>

      {/* Large Empathetic Hero Illustration (`YATRA-ILL-004`) */}
      <div className="rounded-2xl border-2 border-[#E6DDD0] overflow-hidden shadow-editorial bg-[#FFFCF7]">
        <AssetPlaceholder
          assetId="YATRA-ILL-004"
          filename="boarding-assistance-empathy.webp"
          alt="Empathetic editorial illustration of passenger boarding low-floor Delhi bus assisted by conductor"
          aspectRatio="16/9"
          fallbackSvg={<AssistanceEmpathySvg />}
          title="Empathetic Boarding Cooperation"
        />
      </div>

      {/* Assistance Category Tiles */}
      <div className="space-y-3">
        <h2 className="text-xs font-bold uppercase tracking-wider text-[#64748B]">
          Select Assistance Required
        </h2>

        <div className="grid grid-cols-2 gap-3">
          {categories.map((cat) => {
            const isSelected = selectedCategory === cat.id;
            const Icon = cat.icon;

            return (
              <button
                key={cat.id}
                onClick={() => setSelectedCategory(cat.id)}
                className={`flex flex-col text-left p-4 rounded-xl border transition-all cursor-pointer shadow-subtle ${
                  isSelected
                    ? "border-[#E96835] bg-[#FFF9F5] ring-2 ring-[#E96835]/20"
                    : "border-[#E6DDD0] bg-[#FFFCF7] hover:border-[#CBD5E1]"
                }`}
              >
                <div className="flex items-center justify-between w-full">
                  <div
                    className={`p-2 rounded-lg ${
                      isSelected
                        ? "bg-[#E96835] text-white"
                        : "bg-[#FAF5EE] text-[#172653]"
                    }`}
                  >
                    <Icon className="h-5 w-5" />
                  </div>
                  {isSelected && (
                    <CheckCircle2 className="h-4 w-4 text-[#E96835]" />
                  )}
                </div>

                <div className="mt-3">
                  <h3 className="font-editorial-serif text-base font-bold text-[#101B3A]">
                    {cat.title}
                  </h3>
                  <p className="text-[11px] text-[#64748B] mt-0.5 leading-snug">
                    {cat.desc}
                  </p>
                </div>
              </button>
            );
          })}
        </div>
      </div>

      {/* Target Route & Location Selector Card */}
      <div className="rounded-xl border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial space-y-4">
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-[11px] font-bold uppercase tracking-wider text-[#64748B] mb-1">
              Approaching Bus Route
            </label>
            <select
              value={selectedRoute}
              onChange={(e) => setSelectedRoute(e.target.value)}
              className="w-full rounded-lg border border-[#E6DDD0] bg-[#FAF5EE] px-3.5 py-2.5 text-sm font-semibold text-[#101B3A] focus:border-[#E96835] focus:outline-hidden"
            >
              <option value="502">Route 502 (DL 1PD 4421 · 3 mins away)</option>
              <option value="TMS">Route TMS(+) (DL 1PC 8902 · 8 mins away)</option>
              <option value="534">Route 534 (DL 1PD 3311 · 12 mins away)</option>
            </select>
          </div>

          <div>
            <label className="block text-[11px] font-bold uppercase tracking-wider text-[#64748B] mb-1">
              Current Boarding Stop
            </label>
            <input
              type="text"
              readOnly
              value="AIIMS Metro Station (Bay 2)"
              className="w-full rounded-lg border border-[#E6DDD0] bg-[#FAF5EE] px-3.5 py-2.5 text-sm font-semibold text-[#101B3A] cursor-not-allowed"
            />
          </div>
        </div>

        {/* Handshake Result State */}
        {requestStatus === "ACKNOWLEDGED" ? (
          <div className="rounded-xl border border-[#16764C] bg-[#E4F1E5] p-4 text-center space-y-2 animate-fade-in">
            <div className="flex items-center justify-center gap-2 text-[#16764C] font-bold text-sm">
              <CheckCircle2 className="h-5 w-5" />
              <span>DRIVER ACKNOWLEDGED REQUEST</span>
            </div>
            <p className="text-xs text-[#065F46] max-w-md mx-auto">
              Driver Rajesh (Bus DL 1PD 4421) received your alert. The bus will align flush with the curb at Bay 2 and lower the hydraulic ramp upon stopping.
            </p>
            <button
              onClick={() => setRequestStatus("IDLE")}
              className="mt-2 text-xs font-semibold text-[#16764C] underline hover:text-[#065F46] cursor-pointer"
            >
              Reset / Submit Another Request
            </button>
          </div>
        ) : (
          <button
            onClick={handleSendRequest}
            disabled={requestStatus === "SENDING"}
            className="w-full flex items-center justify-center gap-2.5 rounded-xl bg-[#E96835] hover:bg-[#D95724] px-6 py-4 text-base font-bold text-white shadow-md transition-all hover:shadow-lg cursor-pointer disabled:opacity-50"
          >
            {requestStatus === "SENDING" ? (
              <>
                <Radio className="h-5 w-5 animate-spin" />
                <span>Transmitting Handshake over Redis WebSocket...</span>
              </>
            ) : (
              <>
                <Send className="h-5 w-5" />
                <span>Send Boarding Assistance Request</span>
              </>
            )}
          </button>
        )}
      </div>
    </div>
  );
}
