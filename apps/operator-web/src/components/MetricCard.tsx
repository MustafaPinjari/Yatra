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
  accentColor?: "terracotta" | "emerald" | "amber" | "navy";
}

export function MetricCard({
  title,
  value,
  subtitle,
  icon: Icon,
  trend,
  accentColor = "terracotta",
}: MetricCardProps) {
  const colorStyles = {
    terracotta: {
      iconBg: "bg-[#E96835]/10 text-[#E96835] border-[#E96835]/25",
      badge: "text-[#E96835]",
    },
    emerald: {
      iconBg: "bg-[#16764C]/10 text-[#16764C] border-[#16764C]/25",
      badge: "text-[#16764C]",
    },
    amber: {
      iconBg: "bg-[#D97706]/10 text-[#D97706] border-[#D97706]/25",
      badge: "text-[#D97706]",
    },
    navy: {
      iconBg: "bg-[#101B3A]/10 text-[#101B3A] border-[#101B3A]/25",
      badge: "text-[#101B3A]",
    },
  };

  const selected = colorStyles[accentColor];

  return (
    <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial transition-all hover:shadow-editorial-lg">
      <div className="flex items-center justify-between">
        <span className="text-xs font-semibold text-[#64748B] tracking-normal">{title}</span>
        <div className={`rounded-xl p-2.5 border ${selected.iconBg}`}>
          <Icon className="h-4 w-4" aria-hidden="true" />
        </div>
      </div>
      <div className="mt-3 flex items-baseline gap-2">
        <span className="font-editorial-serif text-3xl font-extrabold text-[#101B3A] tabular-nums">
          {value}
        </span>
        {trend && (
          <span
            className={`text-xs font-semibold tabular-nums ${
              trend.isPositive ? "text-[#16764C]" : "text-[#DC2626]"
            }`}
          >
            {trend.value}
          </span>
        )}
      </div>
      <p className="mt-1 text-xs text-[#64748B]">{subtitle}</p>
    </div>
  );
}
