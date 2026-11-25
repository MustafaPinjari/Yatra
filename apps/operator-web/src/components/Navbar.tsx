"use client";

import React, { useState, useEffect } from "react";
import { YatraBrandLogo } from "@/components/brand/YatraBrandLogo";
import {
  LayoutDashboard,
  Radio,
  AlertTriangle,
  Bus,
  Building,
  Bell,
  Volume2,
  VolumeX,
  User,
  Activity,
  ShieldCheck,
  Radio as SignalIcon,
} from "lucide-react";

export type WebPortalTab = "COMMAND" | "ASSISTANCE" | "INCIDENTS" | "FLEET" | "GOVERNMENT";

interface NavbarProps {
  activeTab: WebPortalTab;
  onTabChange: (tab: WebPortalTab) => void;
  assistanceCount?: number;
  incidentsCount?: number;
}

export function Navbar({
  activeTab,
  onTabChange,
  assistanceCount = 3,
  incidentsCount = 2,
}: NavbarProps) {
  const [soundEnabled, setSoundEnabled] = useState(true);
  const [timeString, setTimeString] = useState("");

  useEffect(() => {
    const updateTime = () => {
      const now = new Date();
      setTimeString(
        now.toLocaleTimeString("en-IN", {
          hour: "2-digit",
          minute: "2-digit",
          second: "2-digit",
          hour12: false,
          timeZone: "Asia/Kolkata",
        })
      );
    };
    updateTime();
    const interval = setInterval(updateTime, 1000);
    return () => clearInterval(interval);
  }, []);

  const navItems: Array<{
    id: WebPortalTab;
    label: string;
    icon: React.ElementType;
    count?: number;
    countTone?: "orange" | "amber";
  }> = [
    { id: "COMMAND", label: "Command centre", icon: LayoutDashboard },
    { id: "ASSISTANCE", label: "Assistance queue", icon: Radio, count: assistanceCount, countTone: "orange" },
    { id: "INCIDENTS", label: "Incident triage", icon: AlertTriangle, count: incidentsCount, countTone: "amber" },
    { id: "FLEET", label: "Fleet & headway", icon: Bus },
    { id: "GOVERNMENT", label: "Municipal analytics", icon: Building },
  ];

  return (
    <header className="sticky top-0 z-50 w-full border-b border-[#1E2D4A] bg-[#0A0F1D] text-white shadow-md">
      {/* =========================================================================
          TIER 1: HIGH-DENSITY OPERATIONAL TELEMETRY & DISPATCH STRIP
      ========================================================================= */}
      <div className="border-b border-[#141F36] bg-[#070B16] px-4 sm:px-6 py-1.5 text-xs text-slate-300">
        <div className="max-w-7xl mx-auto flex flex-wrap items-center justify-between gap-3">
          {/* Municipal Authority Mandate */}
          <div className="flex items-center gap-2">
            <span className="flex h-2 w-2 rounded-full bg-emerald-400 animate-pulse" />
            <span className="text-[11px] font-semibold tracking-wider text-slate-200">
              GOVERNMENT OF NCT OF DELHI
            </span>
            <span className="text-slate-500">·</span>
            <span className="text-[11px] text-slate-400 font-medium">
              Delhi Transport Corporation Operations Command
            </span>
          </div>

          {/* Telemetry Stream Health Indicators */}
          <div className="hidden md:flex items-center gap-4 text-[11px] font-mono">
            <div className="flex items-center gap-1.5 text-slate-300">
              <Activity className="h-3.5 w-3.5 text-[#E96835]" />
              <span>GTFS-RT: 3,746 vehicles (15s cadence)</span>
            </div>
            <span className="text-slate-600">|</span>
            <div className="flex items-center gap-1.5 text-slate-300">
              <SignalIcon className="h-3.5 w-3.5 text-sky-400" />
              <span>AccessHandshake: Redis active</span>
            </div>
            <span className="text-slate-600">|</span>
            <div className="flex items-center gap-1.5 text-emerald-300">
              <ShieldCheck className="h-3.5 w-3.5 text-emerald-400" />
              <span>Sepolia ledger: Synced</span>
            </div>
          </div>

          {/* Clock & Duty Status */}
          <div className="flex items-center gap-3 text-[11px]">
            <div className="flex items-center gap-1.5 font-mono text-slate-200 font-semibold tabular-nums">
              <span className="text-slate-400 font-sans font-normal text-[10px]">IST:</span>
              <span>{timeString || "12:00:00"}</span>
            </div>
            <span className="hidden sm:inline text-slate-600">·</span>
            <span className="hidden sm:inline rounded bg-[#101B3A] border border-[#1E2D4A] px-2 py-0.5 text-[10px] font-medium text-emerald-400">
              South Control Room · Day Shift
            </span>
          </div>
        </div>
      </div>

      {/* =========================================================================
          TIER 2: PRIMARY BRAND & COMMAND NAVIGATION TABS
      ========================================================================= */}
      <div className="px-4 sm:px-6 py-2.5 bg-[#0F172A]">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-3">
          {/* Brand Identity */}
          <div className="flex items-center gap-3">
            <YatraBrandLogo size="sm" variant="light" />
            <div className="hidden lg:block h-6 w-px bg-[#1E2D4A]" />
            <div className="hidden lg:block">
              <h1 className="text-xs font-semibold text-white tracking-normal leading-tight">
                Delhi Transit Stack Command Portal
              </h1>
              <p className="text-[10px] text-slate-400 leading-tight">
                Centralized Fleet Telemetry and Accessibility Dispatch Desk
              </p>
            </div>
          </div>

          {/* Navigation Tab Strip */}
          <nav
            aria-label="Operations Navigation"
            className="flex items-center overflow-x-auto gap-1 bg-[#090D1A] p-1 rounded-xl border border-[#1E2D4A] scrollbar-none"
          >
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = activeTab === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => onTabChange(item.id)}
                  className={`flex items-center gap-2 px-3 py-1.5 rounded-lg text-xs font-medium transition-all whitespace-nowrap cursor-pointer select-none ${
                    isActive
                      ? "bg-[#1E293B] text-white shadow-xs border border-[#334155] font-semibold"
                      : "text-slate-300 hover:text-white hover:bg-[#151D2E]"
                  }`}
                >
                  <Icon
                    className={`h-3.5 w-3.5 ${
                      isActive ? "text-[#E96835]" : "text-slate-400"
                    }`}
                  />
                  <span>{item.label}</span>
                  {typeof item.count === "number" && item.count > 0 && (
                    <span
                      className={`rounded-full px-1.5 py-0.2 text-[10px] font-bold font-mono tabular-nums ${
                        item.countTone === "orange"
                          ? "bg-[#E96835] text-white"
                          : "bg-amber-500/20 border border-amber-500/40 text-amber-300"
                      }`}
                    >
                      {item.count}
                    </span>
                  )}
                </button>
              );
            })}
          </nav>

          {/* Right Utility Controls */}
          <div className="flex items-center justify-end gap-2.5">
            {/* Chime Audio Toggle */}
            <button
              type="button"
              onClick={() => setSoundEnabled(!soundEnabled)}
              title={soundEnabled ? "Cab arrival chimes enabled" : "Mute arrival audio"}
              className={`flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg border text-xs font-medium transition-colors ${
                soundEnabled
                  ? "bg-[#131D33] border-[#233554] text-slate-200 hover:bg-[#1A2744]"
                  : "bg-red-950/30 border-red-900/50 text-red-300"
              }`}
            >
              {soundEnabled ? (
                <Volume2 className="h-3.5 w-3.5 text-emerald-400" />
              ) : (
                <VolumeX className="h-3.5 w-3.5 text-red-400" />
              )}
              <span className="hidden xl:inline text-[11px]">
                {soundEnabled ? "Chime active" : "Muted"}
              </span>
            </button>

            {/* Notification Drawer Trigger */}
            <button
              type="button"
              aria-label="View system alerts"
              className="relative p-1.5 rounded-lg border border-[#233554] bg-[#131D33] text-slate-300 hover:text-white hover:bg-[#1A2744] transition-colors"
            >
              <Bell className="h-4 w-4" />
              <span className="absolute top-1 right-1 flex h-2 w-2">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-[#E96835] opacity-75" />
                <span className="relative inline-flex rounded-full h-2 w-2 bg-[#E96835]" />
              </span>
            </button>

            {/* Operator Profile */}
            <div className="flex items-center gap-2 pl-2 border-l border-[#1E2D4A]">
              <div className="h-7 w-7 rounded-full bg-[#1E2D4A] border border-[#2B3E63] flex items-center justify-center text-slate-200">
                <User className="h-3.5 w-3.5" />
              </div>
              <div className="hidden xl:block text-left">
                <p className="font-semibold text-slate-200 text-xs leading-none">
                  Officer A. Sharma
                </p>
                <p className="text-[10px] text-slate-400 leading-none mt-1">
                  ID: DTC-7749
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
