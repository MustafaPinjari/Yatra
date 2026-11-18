import React from "react";
import { LucideIcon } from "lucide-react";

interface MetricCardProps {
  title: string;
  value: string | number;
  subtitle: string;
  icon: LucideIcon;
  trend?: {
    value: string;
    isPositive: boolean;
  };
  accentColor?: "indigo" | "emerald" | "amber" | "rose";
}

export function MetricCard({
  title,
  value,
  subtitle,
  icon: Icon,
  trend,
  accentColor = "indigo",
}: MetricCardProps) {
  const colorStyles = {
    indigo: "bg-indigo-50 text-indigo-700 border-indigo-100",
    emerald: "bg-emerald-50 text-emerald-700 border-emerald-100",
    amber: "bg-amber-50 text-amber-700 border-amber-100",
    rose: "bg-rose-50 text-rose-700 border-rose-100",
  };

  return (
    <div className="rounded-xl border border-slate-200 bg-white p-5 shadow-sm transition-all hover:shadow">
      <div className="flex items-center justify-between">
        <span className="text-sm font-medium text-slate-500">{title}</span>
        <div className={`rounded-lg p-2.5 border ${colorStyles[accentColor]}`}>
          <Icon className="h-5 w-5" aria-hidden="true" />
        </div>
      </div>
      <div className="mt-3 flex items-baseline gap-2">
        <span className="text-2xl font-bold tracking-tight text-slate-900">
          {value}
        </span>
        {trend && (
          <span
            className={`text-xs font-semibold ${
              trend.isPositive ? "text-emerald-600" : "text-rose-600"
            }`}
          >
            {trend.value}
          </span>
        )}
      </div>
      <p className="mt-1 text-xs text-slate-500">{subtitle}</p>
    </div>
  );
}

