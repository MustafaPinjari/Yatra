"use client";
import React from "react";
import { Bus, ShieldCheck, Activity, Bell, User } from "lucide-react";

export function Navbar() {
  return (
    <header className="sticky top-0 z-40 w-full border-b border-slate-200 bg-white/95 backdrop-blur">
      <div className="flex h-16 items-center justify-between px-6">
        {/* Brand identity */}
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-600 text-white shadow-sm">
            <Bus className="h-6 w-6" aria-hidden="true" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="text-xl font-bold tracking-tight text-slate-900">
                YATRA
              </span>
              <span className="rounded bg-indigo-100 px-2 py-0.5 text-xs font-semibold text-indigo-700">
                COMMAND
              </span>
            </div>
            <p className="text-xs text-slate-500">
              Your Accessible Transport & Reliable Assistance Platform
            </p>
          </div>
        </div>

        {/* Center: System status indicators */}
        <div className="hidden md:flex items-center gap-6 text-sm">
          <div className="flex items-center gap-2 rounded-full border border-emerald-200 bg-emerald-50 px-3 py-1 text-emerald-800">
            <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse" />
            <span className="font-medium">Gateway: Operational</span>
          </div>
          <div className="flex items-center gap-2 text-slate-600">
            <Activity className="h-4 w-4 text-indigo-600" aria-hidden="true" />
            <span>Redis Handshake: Active</span>
          </div>
          <div className="flex items-center gap-2 text-slate-600">
            <ShieldCheck className="h-4 w-4 text-emerald-600" aria-hidden="true" />
            <span>Sepolia Ledger: Synced</span>
          </div>
        </div>

        {/* Right side controls */}
        <div className="flex items-center gap-3">
          <button
            type="button"
            aria-label="View alerts"
            className="relative rounded-lg p-2 text-slate-500 hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-indigo-500"
          >
            <Bell className="h-5 w-5" />
            <span className="absolute top-1 right-1 flex h-2 w-2">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75" />
              <span className="relative inline-flex rounded-full h-2 w-2 bg-red-500" />
            </span>
          </button>

          <div className="h-6 w-px bg-slate-200" aria-hidden="true" />

          <div className="flex items-center gap-2 pl-2">
            <div className="flex h-8 w-8 items-center justify-center rounded-full bg-slate-200 text-slate-700 font-medium text-sm">
              <User className="h-4 w-4" />
            </div>
            <div className="hidden lg:block text-left text-xs">
              <p className="font-semibold text-slate-800">Officer A. Sharma</p>
              <p className="text-slate-500">Delhi South Control (DTC)</p>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
