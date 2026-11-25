"use client";

import React from "react";
import { Bus, ShieldCheck, Activity, Bell, User } from "lucide-react";

export function Navbar() {
  return (
    <header className="sticky top-0 z-40 w-full border-b border-[#E6DDD0] bg-[#FFFCF7]/95 backdrop-blur shadow-xs">
      <div className="flex h-16 items-center justify-between px-6">
        {/* Brand identity */}
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-[#101B3A] text-white shadow-xs">
            <Bus className="h-5 w-5 text-[#E96835]" aria-hidden="true" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="font-serif text-xl font-bold tracking-tight text-[#101B3A]">
                YATRA
              </span>
              <span className="rounded-md bg-[#16764C]/10 border border-[#16764C]/25 px-2 py-0.5 text-xs font-semibold text-[#16764C]">
                Command
              </span>
            </div>
            <p className="text-xs text-[#64748B]">
              Delhi Transport Stack operational telemetry and accessibility dispatch
            </p>
          </div>
        </div>

        {/* Center: System status indicators */}
        <div className="hidden md:flex items-center gap-6 text-xs">
          <div className="flex items-center gap-2 rounded-full border border-[#16764C]/30 bg-[#16764C]/10 px-3 py-1 text-[#16764C]">
            <span className="h-2 w-2 rounded-full bg-[#16764C] animate-pulse" />
            <span className="font-medium font-mono text-[11px]">Gateway: operational</span>
          </div>
          <div className="flex items-center gap-2 text-[#334155]">
            <Activity className="h-4 w-4 text-[#E96835]" aria-hidden="true" />
            <span className="font-mono text-[11px]">Redis event bus: active</span>
          </div>
          <div className="flex items-center gap-2 text-[#334155]">
            <ShieldCheck className="h-4 w-4 text-[#16764C]" aria-hidden="true" />
            <span className="font-mono text-[11px]">Sepolia ledger: synced</span>
          </div>
        </div>

        {/* Right side controls */}
        <div className="flex items-center gap-3">
          <button
            type="button"
            aria-label="View alerts"
            className="relative rounded-xl p-2 text-[#64748B] hover:bg-[#FAF5EE] hover:text-[#101B3A] focus:outline-none focus:ring-2 focus:ring-[#E96835] border border-transparent hover:border-[#E6DDD0] transition-colors"
          >
            <Bell className="h-5 w-5" />
            <span className="absolute top-1.5 right-1.5 flex h-2 w-2">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-[#E96835] opacity-75" />
              <span className="relative inline-flex rounded-full h-2 w-2 bg-[#E96835]" />
            </span>
          </button>

          <div className="h-6 w-px bg-[#E6DDD0]" aria-hidden="true" />

          <div className="flex items-center gap-2 pl-2">
            <div className="flex h-8 w-8 items-center justify-center rounded-full bg-[#101B3A] text-white font-medium text-xs">
              <User className="h-4 w-4" />
            </div>
            <div className="hidden lg:block text-left text-xs">
              <p className="font-semibold text-[#101B3A]">Officer A. Sharma</p>
              <p className="text-[10px] text-[#64748B]">Delhi South Control (DTC)</p>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
