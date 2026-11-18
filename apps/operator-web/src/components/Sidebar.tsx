"use client";
import React from "react";
import {
  LayoutDashboard,
  Bus,
  Accessibility,
  AlertTriangle,
  Radio,
  FileCheck2,
  Settings,
} from "lucide-react";

interface SidebarProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
}

export function Sidebar({ activeTab, onTabChange }: SidebarProps) {
  const navItems = [
    { id: "overview", label: "Fleet Overview", icon: LayoutDashboard },
    { id: "handshake", label: "Assistance Requests", icon: Radio, badge: "3 Live" },
    { id: "incidents", label: "Accessibility Incidents", icon: AlertTriangle, badge: "2 New" },
    { id: "accessgraph", label: "AccessGraph Stops", icon: Accessibility },
    { id: "routes", label: "Routes & Crowding", icon: Bus },
    { id: "trustledger", label: "Trust Ledger Audits", icon: FileCheck2 },
    { id: "settings", label: "System Settings", icon: Settings },
  ];

  return (
    <aside
      aria-label="Navigation Sidebar"
      className="w-64 border-r border-slate-200 bg-white min-h-[calc(100vh-4rem)] flex flex-col justify-between p-4"
    >
      <nav className="space-y-1" aria-label="Main Navigation">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = activeTab === item.id;
          return (
            <button
              key={item.id}
              onClick={() => onTabChange(item.id)}
              className={`w-full flex items-center justify-between rounded-lg px-3 py-2.5 text-sm font-medium transition-colors ${
                isActive
                  ? "bg-indigo-50 text-indigo-700 font-semibold"
                  : "text-slate-600 hover:bg-slate-100 hover:text-slate-900"
              }`}
            >
              <div className="flex items-center gap-3">
                <Icon
                  className={`h-5 w-5 ${
                    isActive ? "text-indigo-600" : "text-slate-400"
                  }`}
                  aria-hidden="true"
                />
                <span>{item.label}</span>
              </div>
              {item.badge && (
                <span
                  className={`rounded-full px-2 py-0.5 text-xs font-semibold ${
                    item.badge.includes("Live")
                      ? "bg-emerald-100 text-emerald-800"
                      : "bg-amber-100 text-amber-800"
                  }`}
                >
                  {item.badge}
                </span>
              )}
            </button>
          );
        })}
      </nav>

      {/* Footer / Sample Mode Notice */}
      <div className="rounded-lg border border-slate-200 bg-slate-50 p-3 text-xs text-slate-500">
        <p className="font-semibold text-slate-700">Demonstration Mode</p>
        <p className="mt-1">
          Showing verified synthetic sample telemetry for Delhi Route 502 & TMS.
        </p>
      </div>
    </aside>
  );
}

