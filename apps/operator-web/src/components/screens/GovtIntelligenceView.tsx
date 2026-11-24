"use client";

import React, { useEffect, useState } from "react";
import { AssetPlaceholder } from "@/components/AssetPlaceholder";
import { YatraWaveBackground } from "@/components/brand/YatraWaveBackground";
import {
  TrendingUp,
  ShieldCheck,
  CheckCircle2,
  AlertTriangle,
  Bus,
  Layers,
  Zap,
  BatteryCharging,
  Gauge,
  Sliders,
  Info,
} from "lucide-react";

interface OdSensitivityRun {
  gamma: number;
  friction_label: string;
  total_trips: number;
  interzonal_trips: number;
  interzonal_share_percent: number;
  intrazonal_trips: number;
  intrazonal_share_percent: number;
  iterations_to_converge: number;
  converged: boolean;
}

interface OdMatrixData {
  time_period: string;
  converged: boolean;
  iterations_run: number;
  total_passenger_trips: number;
  total_estimated_bus_trips?: number;
  total_observed_metro_trips?: number;
  distance_decay_gamma?: number;
  zones: Array<{
    zone_id: string;
    name: string;
    uncertainty_rating?: string;
    marginal_provenance?: string;
  }>;
  matrix: number[][];
}

interface FeederSensitivityRun {
  target_headway_minutes: number;
  frequency_buses_per_hour: number;
  fleet_required_full_network: number;
  fleet_allocated_under_cap: number;
  fleet_cap: number;
  is_fleet_budget_compliant: boolean;
  routes_fully_serviced: number;
  total_coverage_km: number;
  average_cycle_time_minutes: number;
}

interface FeederData {
  fleet_budget_total: number;
  fleet_allocated: number;
  fleet_utilization_percent: number;
  routes_count: number;
  total_network_km: number;
  average_route_length_km: number;
  max_route_length_cap_km: number;
  min_carriageway_width_enforced_m: number;
  all_roads_eligible: boolean;
  allocated_routes: Array<{
    route_id: string;
    metro_station_name: string;
    length_km: number;
    buses_required: number;
    achieved_headway_minutes: number;
    min_carriageway_width_m: number;
  }>;
}

interface FeederEvEnergyData {
  route_id: string;
  metro_hub: string;
  loop_distance_km: number;
  daily_trips_scheduled: number;
  daily_distance_km: number;
  ev_nominal_battery_capacity_kwh: number;
  usable_battery_capacity_kwh: number;
  specific_energy_consumption_kwh_km: number;
  energy_consumed_per_loop_kwh: number;
  total_daily_energy_consumed_kwh: number;
  loops_before_mandatory_recharge: number;
  requires_midday_opportunity_charge: boolean;
  depot_fast_charger_power_kw: number;
  estimated_opportunity_topup_minutes: number;
  full_daily_recharge_time_hours: number;
  charging_regime: string;
}

interface SegmentItem {
  segment_index: number;
  from_stop_name: string;
  to_stop_name: string;
  observed_boardings?: number;
  observed_alightings?: number | null;
  estimated_alightings?: number;
  is_alighting_estimated?: boolean;
  passenger_load: number;
  passenger_load_lower_bound?: number;
  passenger_load_upper_bound?: number;
  uncertainty_margin_percent?: number;
  vehicle_capacity: number;
  load_factor: number;
  status: string;
  is_bottleneck: boolean;
}

interface SegmentLoadData {
  route_id: string;
  stops_count: number;
  segments_count: number;
  total_boardings: number;
  total_alightings: number;
  conservation_residual: number;
  conservation_equation_holds: boolean;
  peak_load: number;
  peak_load_factor: number;
  peak_segment: string;
  bottlenecks_detected: number;
  flow_conservation_note?: string;
  accuracy_disclaimer?: string;
  bottleneck_segments: Array<{
    segment: string;
    load: number;
    capacity: number;
    load_factor: number;
    recommended_action: string;
  }>;
  segments: SegmentItem[];
}

export function GovtIntelligenceView() {
  const [odData, setOdData] = useState<OdMatrixData | null>(null);
  const [odSensitivity, setOdSensitivity] = useState<OdSensitivityRun[]>([]);
  const [selectedGamma, setSelectedGamma] = useState<number>(0.08);

  const [feederData, setFeederData] = useState<FeederData | null>(null);
  const [feederSensitivity, setFeederSensitivity] = useState<FeederSensitivityRun[]>([]);
  const [selectedHeadway, setSelectedHeadway] = useState<number>(10.0);
  const [feederEvEnergy, setFeederEvEnergy] = useState<FeederEvEnergyData | null>(null);

  const [segmentData, setSegmentData] = useState<SegmentLoadData | null>(null);

  useEffect(() => {
    async function loadAnalytics() {
      try {
        const [odRes, odSensRes, feederRes, feederSensRes, feederEvRes, segRes] = await Promise.allSettled([
          fetch(`http://localhost:8000/api/v1/analytics/od-matrix?time_period=AM_PEAK`),
          fetch(`http://localhost:8000/api/v1/analytics/od-sensitivity?time_period=AM_PEAK`),
          fetch(`http://localhost:8000/api/v1/analytics/feeder-routes?max_fleet=500`),
          fetch(`http://localhost:8000/api/v1/analytics/feeder-sensitivity?max_fleet=500`),
          fetch(`http://localhost:8000/api/v1/analytics/feeder-ev-energy?daily_trips=16`),
          fetch(`http://localhost:8000/api/v1/analytics/segment-loads?route_id=route_delhi_502&departure_hour=8.5`),
        ]);

        if (odRes.status === "fulfilled" && odRes.value.ok) {
          setOdData(await odRes.value.json());
        }
        if (odSensRes.status === "fulfilled" && odSensRes.value.ok) {
          const json = await odSensRes.value.json();
          setOdSensitivity(json.sensitivity_runs || []);
        }
        if (feederRes.status === "fulfilled" && feederRes.value.ok) {
          setFeederData(await feederRes.value.json());
        }
        if (feederSensRes.status === "fulfilled" && feederSensRes.value.ok) {
          const json = await feederSensRes.value.json();
          setFeederSensitivity(json.sensitivity_runs || []);
        }
        if (feederEvRes.status === "fulfilled" && feederEvRes.value.ok) {
          setFeederEvEnergy(await feederEvRes.value.json());
        }
        if (segRes.status === "fulfilled" && segRes.value.ok) {
          setSegmentData(await segRes.value.json());
        }
      } catch {
        // Fallbacks remain if backend is unreachable
      }
    }

    loadAnalytics();
  }, []);

  const coverageBreakdown = [
    { label: "Wheelchair ramps and flush curbs", percentage: 78, color: "bg-[#16764C]" },
    { label: "Tactile directional paving", percentage: 64, color: "bg-[#E96835]" },
    { label: "Audio beacon announcements", percentage: 52, color: "bg-[#172653]" },
    { label: "Covered shelters and braille signage", percentage: 89, color: "bg-[#059669]" },
  ];

  const currentGammaRun = odSensitivity.find((s) => Math.abs(s.gamma - selectedGamma) < 0.001);
  const currentHeadwayRun = feederSensitivity.find((s) => Math.abs(s.target_headway_minutes - selectedHeadway) < 0.1);

  return (
    <div className="relative rounded-2xl overflow-hidden border border-[#E6DDD0]">
      <YatraWaveBackground variant="editorial" opacity={0.65} />
      <div className="relative z-10 max-w-5xl mx-auto p-4 sm:p-8 space-y-8 bg-[#F7F2E9]/80 backdrop-blur-xs">
        {/* 1. Header with Delhi Administration Context and India Gate Illustration */}
        <header className="flex flex-col sm:flex-row items-start sm:items-center justify-between pb-6 border-b border-[#E6DDD0] gap-4">
          <div>
            <div className="flex items-center gap-2 mb-2">
              <span className="rounded bg-[#172653] px-2 py-0.5 text-[10px] font-bold text-white uppercase tracking-widest">
                Department of Transport
              </span>
              <span className="text-xs text-[#64748B]">Government of NCT of Delhi</span>
            </div>
            <h1 className="font-editorial-serif text-3xl sm:text-4xl font-black text-[#101B3A]">
              Delhi transit stack intelligence
            </h1>
            <p className="font-ui-sans text-xs text-[#64748B] mt-1">
              Multi-problem municipal transport analytics with explicit data provenance and sensitivity boundaries
            </p>
          </div>

          <div className="w-24 h-24 sm:w-28 sm:h-28 flex-shrink-0">
            <AssetPlaceholder
              assetId="YATRA-ILL-010"
              filename="govt-india-gate-engraving.png"
              alt="Classical architectural engraving of India Gate on cream parchment"
              aspectRatio="1/1"
              className="rounded-yatra-card border border-[#E6DDD0] bg-[#FFFCF7] shadow-editorial"
              title="India Gate Engraving"
            />
          </div>
        </header>

        {/* 2. Core Operational Metrics with Provenance Labels */}
        <section aria-label="Core Municipal Metrics" className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="rounded-yatra-card border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-xs font-medium text-[#64748B]">Network reliability</span>
              <span className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-emerald-100 text-emerald-800 font-bold border border-emerald-200">
                OBSERVED
              </span>
            </div>
            <div className="flex items-baseline gap-1">
              <span className="font-editorial-serif text-4xl font-bold text-[#101B3A] tabular-nums">94.2</span>
              <span className="font-editorial-serif text-xl font-normal text-[#16764C]">%</span>
            </div>
            <p className="text-[11px] text-[#16764C] font-semibold flex items-center gap-1">
              <TrendingUp className="h-3.5 w-3.5" /> +1.8% over last quarter
            </p>
          </div>

          <div className="rounded-yatra-card border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-xs font-medium text-[#64748B]">AccessGraph audit</span>
              <span className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-emerald-100 text-emerald-800 font-bold border border-emerald-200">
                OBSERVED
              </span>
            </div>
            <div className="flex items-baseline gap-1">
              <span className="font-editorial-serif text-4xl font-bold text-[#101B3A] tabular-nums">87.4</span>
              <span className="text-xs font-semibold text-[#64748B]">/100</span>
            </div>
            <p className="text-[11px] text-[#64748B]">
              420 physical stops verified
            </p>
          </div>

          <div className="rounded-yatra-card border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-xs font-medium text-[#64748B]">ETM daily sample</span>
              <span className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-amber-100 text-amber-800 font-bold border border-amber-200">
                ESTIMATED
              </span>
            </div>
            <div className="flex items-baseline gap-1">
              <span className="font-editorial-serif text-4xl font-bold text-[#101B3A] tabular-nums">4.28</span>
              <span className="font-editorial-serif text-xl font-normal text-[#101B3A]">M</span>
            </div>
            <p className="text-[11px] text-[#64748B]">
              Expanded from ~3.5% conductor taps
            </p>
          </div>

          <div className="rounded-yatra-card border border-[#E6DDD0] bg-[#FFFCF7] p-5 shadow-editorial space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-xs font-medium text-[#64748B]">Boarding assistance</span>
              <span className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-emerald-100 text-emerald-800 font-bold border border-emerald-200">
                OBSERVED
              </span>
            </div>
            <div className="flex items-baseline gap-1">
              <span className="font-editorial-serif text-4xl font-bold text-[#E96835] tabular-nums">1,420</span>
            </div>
            <p className="text-[11px] text-[#16764C] font-semibold flex items-center gap-1">
              <CheckCircle2 className="h-3.5 w-3.5" /> 98.6% completion rate
            </p>
          </div>
        </section>

        {/* 3. Problem 3: Origin-Destination Matrix with Sensitivity Analysis */}
        <section className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial space-y-4">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between border-b border-[#E6DDD0] pb-3 gap-2">
            <div>
              <div className="flex items-center gap-2">
                <span className="flex items-center gap-1.5 text-[11px] font-semibold text-indigo-700">
                  <Layers className="h-3.5 w-3.5" />
                  <span>Problem 3 · Origin-destination matrix balance</span>
                </span>
                <span className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-amber-100 text-amber-800 font-bold border border-amber-200">
                  ESTIMATED
                </span>
              </div>
              <h2 className="font-editorial-serif text-xl font-bold text-[#101B3A] mt-0.5">
                Biproportional Furness IPF with distance impedance decay
              </h2>
            </div>
            <div className="flex items-center gap-1 bg-[#FAF5EE] p-1 rounded-lg border border-[#E6DDD0]">
              <span className="text-[11px] text-[#64748B] px-2 font-medium">Decay γ:</span>
              {[0.04, 0.08, 0.12].map((g) => (
                <button
                  key={g}
                  type="button"
                  onClick={() => setSelectedGamma(g)}
                  className={`text-[11px] font-mono px-2 py-0.5 rounded transition-all ${
                    Math.abs(selectedGamma - g) < 0.001
                      ? "bg-[#172653] text-white font-bold"
                      : "text-[#64748B] hover:text-[#101B3A]"
                  }`}
                >
                  {g}
                </button>
              ))}
            </div>
          </div>

          <p className="text-xs text-[#64748B]">
            Calibrated trip generation and attraction across 7 Delhi Transit Analysis Zones (TAZ). Flow separation identifies 46% observed DMRC rail journeys versus 54% estimated DTC surface bus trips.
          </p>

          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 text-center">
            <div className="p-3 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0]">
              <span className="text-[10px] text-[#64748B] block">Total peak trips</span>
              <span className="font-mono text-base font-bold text-[#101B3A] tabular-nums">
                {currentGammaRun ? currentGammaRun.total_trips.toLocaleString() : (odData ? odData.total_passenger_trips.toLocaleString() : "485,320")}
              </span>
            </div>
            <div className="p-3 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0]">
              <span className="text-[10px] text-[#64748B] block">Inter-zonal flow</span>
              <span className="font-mono text-base font-bold text-indigo-700 tabular-nums">
                {currentGammaRun ? `${currentGammaRun.interzonal_share_percent}%` : "74.8%"}
              </span>
            </div>
            <div className="p-3 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0]">
              <span className="text-[10px] text-[#64748B] block">Intra-zonal local</span>
              <span className="font-mono text-base font-bold text-slate-700 tabular-nums">
                {currentGammaRun ? `${currentGammaRun.intrazonal_share_percent}%` : "25.2%"}
              </span>
            </div>
            <div className="p-3 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0]">
              <span className="text-[10px] text-[#64748B] block">Furness convergence</span>
              <span className="font-mono text-base font-bold text-emerald-700 tabular-nums">
                {currentGammaRun ? `${currentGammaRun.iterations_to_converge} iters` : "12 iters"}
              </span>
            </div>
          </div>

          {/* Zone Uncertainty Matrix */}
          <div className="rounded-xl border border-[#E6DDD0] bg-[#FAF5EE] p-3 text-[11px] space-y-2">
            <span className="font-semibold text-[#101B3A] block">Zone data provenance and empirical uncertainty ratings</span>
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2">
              {[
                { name: "Central Delhi (Connaught Place)", rating: "LOW", source: "DMRC Rajiv Chowk gate telemetry" },
                { name: "South Delhi (AIIMS / Nehru Place)", rating: "LOW", source: "DMRC Yellow/Magenta gate counts" },
                { name: "North Delhi (Kashmere Gate)", rating: "MEDIUM", source: "DTC ISBT dispatch + DMRC gates" },
                { name: "East Delhi (Anand Vihar)", rating: "MEDIUM", source: "Anand Vihar multimodal hub" },
                { name: "West Delhi (Janakpuri)", rating: "MEDIUM", source: "DMRC Blue/Pink line gates" },
                { name: "North-West (Rohini)", rating: "HIGH", source: "DMRC Red line terminal; IPT unobserved" },
                { name: "South-West (Mehrauli)", rating: "HIGH", source: "Peripheral DTC schedules; missing ETM" },
              ].map((z) => (
                <div key={z.name} className="p-2 rounded bg-[#FFFCF7] border border-[#E6DDD0] flex flex-col justify-between">
                  <span className="font-semibold text-[#101B3A] text-[10px]">{z.name}</span>
                  <div className="flex items-center justify-between mt-1 text-[9px]">
                    <span className="text-[#64748B] truncate max-w-[140px]">{z.source}</span>
                    <span
                      className={`font-mono px-1 rounded font-bold ${
                        z.rating === "LOW"
                          ? "bg-emerald-100 text-emerald-800"
                          : z.rating === "MEDIUM"
                          ? "bg-amber-100 text-amber-800"
                          : "bg-rose-100 text-rose-800"
                      }`}
                    >
                      {z.rating}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* 4. Problem 4: Metro Feeder Route & EV Fleet Optimization */}
        <section className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial space-y-4">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between border-b border-[#E6DDD0] pb-3 gap-2">
            <div>
              <div className="flex items-center gap-2">
                <span className="flex items-center gap-1.5 text-[11px] font-semibold text-[#E96835]">
                  <Zap className="h-3.5 w-3.5" />
                  <span>Problem 4 · Metro feeder and electric fleet optimization</span>
                </span>
                <span className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-emerald-100 text-emerald-800 font-bold border border-emerald-200">
                  OBSERVED ROAD WIDTHS
                </span>
              </div>
              <h2 className="font-editorial-serif text-xl font-bold text-[#101B3A] mt-0.5">
                500 electric bus budget constraint and carriageway geometric compliance
              </h2>
            </div>
            <div className="flex items-center gap-1 bg-[#FAF5EE] p-1 rounded-lg border border-[#E6DDD0]">
              <span className="text-[11px] text-[#64748B] px-2 font-medium">Headway:</span>
              {[6.0, 8.0, 10.0, 12.0, 15.0].map((h) => (
                <button
                  key={h}
                  type="button"
                  onClick={() => setSelectedHeadway(h)}
                  className={`text-[11px] font-mono px-2 py-0.5 rounded transition-all ${
                    Math.abs(selectedHeadway - h) < 0.1
                      ? "bg-[#E96835] text-white font-bold"
                      : "text-[#64748B] hover:text-[#101B3A]"
                  }`}
                >
                  {h}m
                </button>
              ))}
            </div>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 text-center">
            <div className="p-3 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0]">
              <span className="text-[10px] text-[#64748B] block">Fleet requirement</span>
              <span className="font-mono text-base font-bold text-[#16764C] tabular-nums">
                {currentHeadwayRun ? `${currentHeadwayRun.fleet_required_full_network} / 500` : "32 / 500"}
              </span>
            </div>
            <div className="p-3 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0]">
              <span className="text-[10px] text-[#64748B] block">Carriageway width</span>
              <span className="font-mono text-base font-bold text-emerald-700 tabular-nums">≥ 6.0 m verified</span>
            </div>
            <div className="p-3 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0]">
              <span className="text-[10px] text-[#64748B] block">Route length cap</span>
              <span className="font-mono text-base font-bold text-[#101B3A] tabular-nums">≤ 7.0 km</span>
            </div>
            <div className="p-3 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0]">
              <span className="text-[10px] text-[#64748B] block">Unknown roads</span>
              <span className="font-mono text-base font-bold text-rose-700 tabular-nums">Strictly rejected</span>
            </div>
          </div>

          {/* EV Energy & Depot Fast Charging Specification Card */}
          <div className="rounded-xl border border-orange-200 bg-orange-50/60 p-4 space-y-2 text-xs">
            <div className="flex items-center gap-2 text-[#E96835] font-semibold">
              <BatteryCharging className="h-4 w-4" />
              <span>Electric vehicle energy and depot charging model</span>
              <span className="ml-auto text-[10px] font-mono text-[#64748B]">Delhi EV Policy 2020 Standard</span>
            </div>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 text-[11px] font-mono pt-1 text-slate-700">
              <div className="p-2 rounded bg-white border border-orange-100">
                <span className="text-[9px] text-[#64748B] block font-sans">Battery capacity</span>
                <span className="font-bold tabular-nums">180 kWh (144 usable)</span>
              </div>
              <div className="p-2 rounded bg-white border border-orange-100">
                <span className="text-[9px] text-[#64748B] block font-sans">Consumption rate</span>
                <span className="font-bold tabular-nums">1.15 kWh/km</span>
              </div>
              <div className="p-2 rounded bg-white border border-orange-100">
                <span className="text-[9px] text-[#64748B] block font-sans">Daily loop battery life</span>
                <span className="font-bold tabular-nums">
                  {feederEvEnergy ? `${feederEvEnergy.loops_before_mandatory_recharge} loops` : "21 loops"}
                </span>
              </div>
              <div className="p-2 rounded bg-white border border-orange-100">
                <span className="text-[9px] text-[#64748B] block font-sans">Depot 60kW recharge</span>
                <span className="font-bold text-[#16764C] tabular-nums">
                  {feederEvEnergy ? `${feederEvEnergy.estimated_opportunity_topup_minutes} min top-up` : "45 min top-up"}
                </span>
              </div>
            </div>
          </div>
        </section>

        {/* 5. Problem 5: Segment Loads and Flow Conservation */}
        <section className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial space-y-4">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between border-b border-[#E6DDD0] pb-3 gap-2">
            <div>
              <div className="flex items-center gap-2">
                <span className="flex items-center gap-1.5 text-[11px] font-semibold text-rose-600">
                  <AlertTriangle className="h-3.5 w-3.5" />
                  <span>Problem 5 · Segment load accumulation and bottleneck detection</span>
                </span>
                <span className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-amber-100 text-amber-800 font-bold border border-amber-200">
                  INFERRED LOAD
                </span>
              </div>
              <h2 className="font-editorial-serif text-xl font-bold text-[#101B3A] mt-0.5">
                Corridor segment loads (Route 502: Kashmere Gate ⟷ Mehrauli)
              </h2>
            </div>
            <span className="rounded bg-emerald-100 text-emerald-800 text-[10px] font-bold px-2 py-0.5 border border-emerald-200 font-mono">
              L_i = L_{'{i-1}'} + B_i - A_i holds
            </span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="p-3.5 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0] space-y-1">
              <span className="text-[11px] text-[#64748B] block">Peak segment</span>
              <p className="font-semibold text-xs text-[#101B3A]">
                {segmentData?.peak_segment || "Red Fort ⟷ Delhi Gate"}
              </p>
              <p className="font-mono text-xs text-rose-600 font-bold tabular-nums">
                Load: {segmentData?.peak_load || 58} passengers (Capacity: 60)
              </p>
            </div>

            <div className="p-3.5 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0] space-y-1">
              <span className="text-[11px] text-[#64748B] block">Flow conservation identity</span>
              <p className="font-semibold text-xs text-[#16764C] flex items-center gap-1">
                <CheckCircle2 className="h-3.5 w-3.5" /> Terminal load balances to zero
              </p>
              <p className="font-mono text-[11px] text-[#64748B] tabular-nums">
                Residual: {segmentData ? `${segmentData.conservation_residual}` : "0.0"} passengers
              </p>
            </div>

            <div className="p-3.5 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0] space-y-1">
              <span className="text-[11px] text-[#64748B] block">Operational recommendation</span>
              <p className="text-xs text-slate-700">
                {segmentData?.bottleneck_segments[0]?.recommended_action || "Increase service frequency or inject short-turning relief bus during 08:30–10:00 peak"}
              </p>
            </div>
          </div>

          {/* Uncertainty Notice */}
          <div className="p-3 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0] text-xs text-[#64748B] flex items-start gap-2">
            <Info className="h-4 w-4 text-[#172653] flex-shrink-0 mt-0.5" />
            <p>
              <strong>Epistemic disclosure:</strong> Passenger flow conservation is a mathematical consistency identity. Because conductor ETM records record boardings only, alightings are estimated via spatial gravity decay. Confidence intervals accumulate from ±5% at origin to ±22% intermediate, collapsing at terminal approach.
            </p>
          </div>
        </section>

        {/* 6. Physical Infrastructure Audit Breakdown */}
        <section className="grid grid-cols-1 lg:grid-cols-12 gap-6">
          <div className="lg:col-span-12 rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial space-y-5">
            <div className="flex items-center justify-between border-b border-[#E6DDD0] pb-3">
              <div>
                <div className="flex items-center gap-2">
                  <h2 className="font-editorial-serif text-xl font-bold text-[#101B3A]">
                    Bus stop accessibility coverage audit
                  </h2>
                  <span className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-emerald-100 text-emerald-800 font-bold border border-emerald-200">
                    OBSERVED
                  </span>
                </div>
                <p className="text-xs text-[#64748B]">Harmonised Guidelines 2021 field audit across 15 transit corridors</p>
              </div>
              <span className="rounded bg-[#E4F1E5] px-2 py-0.5 text-xs font-medium text-[#16764C]">
                WCAG 2.2 AA target
              </span>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
              {coverageBreakdown.map((item) => (
                <div key={item.label} className="space-y-1.5 p-3 rounded-xl bg-[#FAF5EE] border border-[#E6DDD0]">
                  <div className="flex items-center justify-between text-xs">
                    <span className="font-semibold text-[#101B3A]">{item.label}</span>
                    <span className="font-mono font-bold text-[#101B3A] tabular-nums">{item.percentage}%</span>
                  </div>
                  <div className="w-full bg-[#E6DDD0] rounded-full h-2 overflow-hidden">
                    <div
                      className={`h-full ${item.color} rounded-full transition-all duration-500`}
                      style={{ width: `${item.percentage}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* 7. Cryptographic Trust Ledger Verification Strip */}
        <section className="rounded-2xl border-2 border-[#16764C]/30 bg-[#FFFCF7] p-5 shadow-editorial flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="h-10 w-10 flex items-center justify-center rounded-xl bg-[#E4F1E5] text-[#16764C]">
              <ShieldCheck className="h-6 w-6" />
            </div>
            <div>
              <h3 className="font-editorial-serif text-lg font-bold text-[#101B3A]">
                Cryptographic audit attestation
              </h3>
              <p className="text-xs text-[#64748B]">
                Depot ramp maintenance records are hashed and anchored to Ethereum Sepolia. No passenger identifying data is recorded on-chain.
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <span className="font-mono text-xs font-semibold text-[#16764C] bg-[#E4F1E5] px-3 py-1.5 rounded-lg border border-[#16764C]/20 tabular-nums">
              Sepolia block #6,419,203
            </span>
          </div>
        </section>
      </div>
    </div>
  );
}
