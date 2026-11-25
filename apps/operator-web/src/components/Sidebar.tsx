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
    { id: "overview", label: "Fleet overview", icon: LayoutDashboard },
    { id: "handshake", label: "Assistance requests", icon: Radio, badge: "3 live" },
    { id: "incidents", label: "Accessibility incidents", icon: AlertTriangle, badge: "2 new" },
    { id: "accessgraph", label: "AccessGraph stops", icon: Accessibility },
    { id: "routes", label: "Routes and crowding", icon: Bus },
    { id: "trustledger", label: "Trust ledger audits", icon: FileCheck2 },
    { id: "settings", label: "System settings", icon: Settings },
  ];

  return (
    <aside
      aria-label="Navigation Sidebar"
      className="w-64 border-r border-[#E6DDD0] bg-[#FFFCF7] min-h-[calc(100vh-4rem)] flex flex-col justify-between p-4"
    >
      <nav className="space-y-1.5" aria-label="Main Navigation">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = activeTab === item.id;
          return (
            <button
              key={item.id}
              onClick={() => onTabChange(item.id)}
              className={`w-full flex items-center justify-between rounded-xl px-3 py-2.5 text-xs font-medium transition-colors cursor-pointer ${
                isActive
                  ? "bg-[#101B3A] text-white font-semibold shadow-xs"
                  : "text-[#334155] hover:bg-[#FAF5EE] hover:text-[#101B3A]"
              }`}
            >
              <div className="flex items-center gap-2.5">
                <Icon
                  className={`h-4 w-4 ${
                    isActive ? "text-[#E96835]" : "text-[#64748B]"
                  }`}
                  aria-hidden="true"
                />
                <span>{item.label}</span>
              </div>
              {item.badge && (
                <span
                  className={`rounded-full px-2 py-0.5 text-[10px] font-semibold font-mono ${
                    item.badge.includes("live")
                      ? isActive ? "bg-[#16764C] text-white" : "bg-[#16764C]/15 text-[#16764C]"
                      : isActive ? "bg-[#E96835] text-white" : "bg-[#E96835]/15 text-[#E96835]"
                  }`}
                >
                  {item.badge}
                </span>
              )}
            </button>
          );
        })}
      </nav>

      {/* Footer / Operational Mode Notice */}
      <div className="rounded-xl border border-[#E6DDD0] bg-[#FAF5EE] p-3 text-xs text-[#64748B]">
        <p className="font-semibold text-[#101B3A]">Operational baseline</p>
        <p className="mt-1 text-[11px] leading-relaxed">
          Telemetry stream for Delhi Route 502 and Ring Road TMS
        </p>
      </div>
    </aside>
  );
}

