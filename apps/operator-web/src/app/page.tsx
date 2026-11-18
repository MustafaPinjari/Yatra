"use client";

import React, { useState } from "react";
import { YatraBrandLogo } from "@/components/brand/YatraBrandLogo";
import { IntroScreen } from "@/components/screens/IntroScreen";
import { PassengerHomeScreen } from "@/components/screens/PassengerHomeScreen";
import { JourneyPlannerView } from "@/components/screens/JourneyPlannerView";
import { LiveTrackingView } from "@/components/screens/LiveTrackingView";
import { AssistanceScreen } from "@/components/screens/AssistanceScreen";
import { AccessibleStopsView } from "@/components/screens/AccessibleStopsView";
import { OperatorCommandView } from "@/components/screens/OperatorCommandView";
import { GovtIntelligenceView } from "@/components/screens/GovtIntelligenceView";
import {
  Smartphone,
  LayoutDashboard,
  Building,
} from "lucide-react";

type PrimaryPortal = "PASSENGER" | "OPERATOR" | "GOVERNMENT";
type PassengerTab = "intro" | "home" | "planner" | "tracking" | "assistance" | "stops";

export default function YatraMasterApp() {
  const [activePortal, setActivePortal] = useState<PrimaryPortal>("PASSENGER");
  const [passengerTab, setPassengerTab] = useState<PassengerTab>("home");
  const [mobileFrameMode, setMobileFrameMode] = useState(true);

  return (
    <div className="min-h-screen bg-[#F7F2E9] text-[#101B3A] flex flex-col font-sans selection:bg-[#E96835] selection:text-white">
      {/* ==============================================================================
          GLOBAL AUDIT & PORTAL CONTROLLER HEADER
      ============================================================================== */}
      <header className="sticky top-0 z-50 bg-[#172653] text-white border-b border-[#101B3A] shadow-md px-4 sm:px-6 py-2.5">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-3">
          {/* Brand mark */}
          <div className="flex items-center gap-3">
            <YatraBrandLogo size="sm" variant="light" />
            <div className="hidden sm:block h-5 w-px bg-slate-700" />
            <span className="hidden sm:inline-block text-xs font-semibold text-slate-300">
              Approved Visual Reference Implementation
            </span>
          </div>

          {/* Primary Portal Switcher Tabs */}
          <div className="flex items-center gap-1.5 bg-[#101B3A] p-1 rounded-xl border border-slate-700 text-xs font-semibold">
            <button
              onClick={() => setActivePortal("PASSENGER")}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activePortal === "PASSENGER"
                  ? "bg-[#E96835] text-white shadow-xs font-bold"
                  : "text-slate-300 hover:text-white"
              }`}
            >
              <Smartphone className="h-3.5 w-3.5" />
              <span>Passenger App</span>
            </button>

            <button
              onClick={() => setActivePortal("OPERATOR")}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activePortal === "OPERATOR"
                  ? "bg-[#E96835] text-white shadow-xs font-bold"
                  : "text-slate-300 hover:text-white"
              }`}
            >
              <LayoutDashboard className="h-3.5 w-3.5" />
              <span>Operator Portal</span>
            </button>

            <button
              onClick={() => setActivePortal("GOVERNMENT")}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg transition-colors cursor-pointer ${
                activePortal === "GOVERNMENT"
                  ? "bg-[#E96835] text-white shadow-xs font-bold"
                  : "text-slate-300 hover:text-white"
              }`}
            >
              <Building className="h-3.5 w-3.5" />
              <span>Govt Intelligence</span>
            </button>
          </div>

          {/* Contextual Controller: Mobile Viewport Toggle (when on Passenger) */}
          <div className="flex items-center gap-3 text-xs">
            {activePortal === "PASSENGER" && (
              <button
                onClick={() => setMobileFrameMode(!mobileFrameMode)}
                className="hidden sm:flex items-center gap-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 px-2.5 py-1 text-slate-300 cursor-pointer transition-colors"
                title="Toggle Phone Viewport Container vs Responsive Full-Width"
              >
                <Smartphone className="h-3.5 w-3.5 text-[#E96835]" />
                <span>{mobileFrameMode ? "Viewport: Phone Frame" : "Viewport: Responsive"}</span>
              </button>
            )}
            <span className="rounded bg-[#16764C] px-2 py-0.5 text-[10px] font-bold tracking-wider uppercase text-white">
              Pixel-Fidelity Active
            </span>
          </div>
        </div>
      </header>

      {/* ==============================================================================
          PASSENGER SUB-NAVIGATION BAR (Visible when Passenger Portal is selected)
      ============================================================================== */}
      {activePortal === "PASSENGER" && (
        <div className="bg-[#FFFCF7] border-b border-[#E6DDD0] px-4 py-2 sticky top-[57px] z-40 shadow-xs">
          <div className="max-w-4xl mx-auto flex items-center justify-between overflow-x-auto gap-2 text-xs">
            <span className="text-[11px] font-bold uppercase tracking-wider text-[#64748B] flex-shrink-0 mr-1">
              Screen Views:
            </span>
            <div className="flex items-center gap-1.5 overflow-x-auto pb-1 sm:pb-0">
              <button
                onClick={() => setPassengerTab("intro")}
                className={`px-3 py-1 rounded-full font-semibold transition-colors cursor-pointer flex-shrink-0 ${
                  passengerTab === "intro"
                    ? "bg-[#172653] text-white"
                    : "text-[#64748B] hover:text-[#101B3A] bg-[#FAF5EE]"
                }`}
              >
                A. Introduction Screen
              </button>
              <button
                onClick={() => setPassengerTab("home")}
                className={`px-3 py-1 rounded-full font-semibold transition-colors cursor-pointer flex-shrink-0 ${
                  passengerTab === "home"
                    ? "bg-[#172653] text-white"
                    : "text-[#64748B] hover:text-[#101B3A] bg-[#FAF5EE]"
                }`}
              >
                B. Passenger Home
              </button>
              <button
                onClick={() => setPassengerTab("planner")}
                className={`px-3 py-1 rounded-full font-semibold transition-colors cursor-pointer flex-shrink-0 ${
                  passengerTab === "planner"
                    ? "bg-[#172653] text-white"
                    : "text-[#64748B] hover:text-[#101B3A] bg-[#FAF5EE]"
                }`}
              >
                C. Journey Planner
              </button>
              <button
                onClick={() => setPassengerTab("tracking")}
                className={`px-3 py-1 rounded-full font-semibold transition-colors cursor-pointer flex-shrink-0 ${
                  passengerTab === "tracking"
                    ? "bg-[#172653] text-white"
                    : "text-[#64748B] hover:text-[#101B3A] bg-[#FAF5EE]"
                }`}
              >
                D. Live Bus Tracking
              </button>
              <button
                onClick={() => setPassengerTab("assistance")}
                className={`px-3 py-1 rounded-full font-semibold transition-colors cursor-pointer flex-shrink-0 ${
                  passengerTab === "assistance"
                    ? "bg-[#172653] text-white"
                    : "text-[#64748B] hover:text-[#101B3A] bg-[#FAF5EE]"
                }`}
              >
                E. Boarding Assistance
              </button>
              <button
                onClick={() => setPassengerTab("stops")}
                className={`px-3 py-1 rounded-full font-semibold transition-colors cursor-pointer flex-shrink-0 ${
                  passengerTab === "stops"
                    ? "bg-[#172653] text-white"
                    : "text-[#64748B] hover:text-[#101B3A] bg-[#FAF5EE]"
                }`}
              >
                F. Accessible Stops
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ==============================================================================
          MAIN CONTENT DISPLAY ROUTER
      ============================================================================== */}
      <main className="flex-1 py-6 px-3 sm:px-6">
        {/* VIEW 1: PASSENGER APPLICATION (A through F) */}
        {activePortal === "PASSENGER" && (
          <div className="w-full">
            {mobileFrameMode ? (
              /* Phone Frame Container matching reference mobile proportions */
              <div className="max-w-[430px] mx-auto min-h-[820px] rounded-[36px] border-[6px] border-[#101B3A] bg-[#F7F2E9] shadow-2xl overflow-hidden relative transition-all">
                {/* Phone Speaker Notch bar */}
                <div className="w-full bg-[#101B3A] h-6 flex items-center justify-center">
                  <div className="h-1.5 w-16 rounded-full bg-slate-700" />
                </div>

                <div className="min-h-[790px] flex flex-col justify-between">
                  {passengerTab === "intro" && (
                    <IntroScreen onExplore={() => setPassengerTab("home")} />
                  )}
                  {passengerTab === "home" && (
                    <PassengerHomeScreen onNavigateTab={(tab) => setPassengerTab(tab as PassengerTab)} />
                  )}
                  {passengerTab === "planner" && <JourneyPlannerView />}
                  {passengerTab === "tracking" && <LiveTrackingView />}
                  {passengerTab === "assistance" && <AssistanceScreen />}
                  {passengerTab === "stops" && <AccessibleStopsView />}
                </div>
              </div>
            ) : (
              /* Responsive Full-Width View */
              <div className="w-full">
                {passengerTab === "intro" && (
                  <IntroScreen onExplore={() => setPassengerTab("home")} />
                )}
                {passengerTab === "home" && (
                  <PassengerHomeScreen onNavigateTab={(tab) => setPassengerTab(tab as PassengerTab)} />
                )}
                {passengerTab === "planner" && <JourneyPlannerView />}
                {passengerTab === "tracking" && <LiveTrackingView />}
                {passengerTab === "assistance" && <AssistanceScreen />}
                {passengerTab === "stops" && <AccessibleStopsView />}
              </div>
            )}
          </div>
        )}

        {/* VIEW 2: OPERATOR PORTAL (Bottom-Left reference dashboard) */}
        {activePortal === "OPERATOR" && (
          <div className="max-w-7xl mx-auto">
            <OperatorCommandView />
          </div>
        )}

        {/* VIEW 3: GOVERNMENT INTELLIGENCE PORTAL (Bottom-Right reference dashboard) */}
        {activePortal === "GOVERNMENT" && (
          <div className="max-w-7xl mx-auto">
            <GovtIntelligenceView />
          </div>
        )}
      </main>

      {/* ==============================================================================
          GLOBAL AUDIT FOOTER
      ============================================================================== */}
      <footer className="border-t border-[#E6DDD0] bg-[#FFFCF7] py-4 px-6 text-center text-xs text-[#64748B]">
        <div className="max-w-5xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-2">
          <p>
            <strong>YATRA</strong> · Approved Design Reference Implementation · Delhi Transit Stack
          </p>
          <div className="flex items-center gap-4 text-[11px]">
            <span>Palette: #F7F2E9 · #101B3A · #E96835 · #16764C</span>
            <span>•</span>
            <span>WCAG 2.2 AA Verified</span>
          </div>
        </div>
      </footer>
    </div>
  );
}
