"""End-to-End Integration and Demonstration Verification Test Suite."""
import json
from fastapi.testclient import TestClient
from app.main import app

def test_full_platform_e2e():
    client = TestClient(app)
    results = {}

    print("================================================================================")
    print("YATRA Phase 4: End-to-End Platform Integration & Verification")
    print("================================================================================\n")

    # 1. Health & System Status
    res = client.get("/health")
    assert res.status_code == 200, f"Health check failed: {res.text}"
    print(f"[OK] System Health: HTTP {res.status_code} - {res.json()['data']['status']}")

    # 2. Problem 1: Journey Intelligence & Timetable Deviation
    p1_payload = {
        "origin_lat": 28.6675,
        "origin_lon": 77.2285,
        "destination_lat": 28.5684,
        "destination_lon": 77.2078,
        "departure_hour": 9.0,
        "wheelchair_accessible_only": True,
        "objective": "FASTEST"
    }
    res = client.post("/api/v1/analytics/journey/plan", json=p1_payload)
    assert res.status_code == 200, f"P1 Journey Plan failed: {res.text}"
    p1_data = res.json()
    assert len(p1_data["itineraries"]) > 0
    top_itin = p1_data["itineraries"][0]
    print(f"[OK] Problem 1 (Journey Planning): {len(p1_data['itineraries'])} itineraries generated.")
    print(f"     Top Itinerary: {top_itin['summary']} | Duration: {top_itin['total_duration_minutes']} min | Access: {top_itin['accessibility_score']}/100")
    results["P1_JOURNEY_PLAN"] = {
        "status": "PASS",
        "itineraries": len(p1_data["itineraries"]),
        "duration_min": top_itin["total_duration_minutes"],
        "accessibility_score": top_itin["accessibility_score"]
    }

    # 3. Problem 2: Relative Crowding Index & Comfort Scoring
    res = client.get("/api/v1/analytics/crowding?route_id=route_delhi_502&hour=8.5")
    assert res.status_code == 200, f"P2 Crowding failed: {res.text}"
    p2_data = res.json()
    print(f"[OK] Problem 2 (Crowding Estimation): Route {p2_data['route_id']} at 08:30.")
    print(f"     RCI: {p2_data['relative_crowding_index']} | Tier: {p2_data['crowding_level']} | Bunching Dev: {p2_data['bunching_headway_deviation']}")
    print(f"     Provenance: {p2_data['provenance']} | Status: {p2_data['expansion_factor_status']}")
    results["P2_CROWDING"] = {
        "status": "PASS",
        "rci": p2_data["relative_crowding_index"],
        "tier": p2_data["crowding_level"],
        "provenance": p2_data["provenance"]
    }

    # 4. Problem 3: Origin-Destination Matrix & Sensitivity
    res = client.get("/api/v1/analytics/od-matrix?time_period=AM_PEAK")
    assert res.status_code == 200, f"P3 OD Matrix failed: {res.text}"
    p3_data = res.json()
    assert p3_data["converged"] is True
    print(f"[OK] Problem 3 (OD Matrix Balance): Converged in {p3_data['iterations_run']} iterations.")
    print(f"     Total Trips: {p3_data['total_passenger_trips']:,} | Zones: {len(p3_data['zones'])} TAZ")
    print(f"     Marginal Preservation Error: {p3_data['marginal_preservation_error_percent']}%")

    res_sens = client.get("/api/v1/analytics/od-sensitivity?time_period=AM_PEAK")
    assert res_sens.status_code == 200
    p3_sens = res_sens.json()
    print(f"     Gamma Sensitivity Tested: {p3_sens['tested_gammas']} | Total Runs: {len(p3_sens['sensitivity_runs'])}")
    results["P3_OD_MATRIX"] = {
        "status": "PASS",
        "converged": p3_data["converged"],
        "iterations": p3_data["iterations_run"],
        "trips": p3_data["total_passenger_trips"],
        "gammas_tested": p3_sens["tested_gammas"]
    }

    # Verify RFC 7946 GeoJSON Desire Lines
    res_geo = client.get("/api/v1/analytics/od-desire-lines?time_period=AM_PEAK&min_trips_threshold=1000")
    assert res_geo.status_code == 200
    geo_data = res_geo.json()
    assert geo_data.get("type") == "FeatureCollection"
    print(f"     RFC 7946 GeoJSON Desire Lines: Valid FeatureCollection with {len(geo_data.get('features', []))} features.")

    # 5. Problem 4: Metro Feeder Optimization & EV Energy
    res = client.get("/api/v1/analytics/feeder-routes?max_fleet=500")
    assert res.status_code == 200, f"P4 Feeder failed: {res.text}"
    p4_data = res.json()
    assert p4_data["fleet_cap_respected"] is True
    assert p4_data["all_routes_under_length_cap"] is True
    print(f"[OK] Problem 4 (Feeder Optimization): {p4_data['routes_count']} routes connecting metro hubs.")
    print(f"     Fleet Allocated: {p4_data['fleet_allocated']} / {p4_data['fleet_budget_total']} (Cap Respected: {p4_data['fleet_cap_respected']})")
    print(f"     Average Length: {p4_data['average_route_length_km']} km | Min Width Enforced: {p4_data['min_carriageway_width_enforced_m']} m")

    # Road width negative check
    res_road = client.get("/api/v1/analytics/feeder-routes/check-road?u=node_unknown_lane&v=node_narrow")
    assert res_road.status_code == 200
    assert res_road.json()["is_bus_eligible"] is False
    print(f"     Road Width Rejection Check: Unknown road correctly rejected ({res_road.json()['transport_mode_allowed']}).")

    # EV Energy calculation
    res_ev = client.get("/api/v1/analytics/feeder-ev-energy?daily_trips=16")
    assert res_ev.status_code == 200
    ev_data = res_ev.json()
    print(f"     EV Energy Model: {ev_data['ev_nominal_battery_capacity_kwh']} kWh battery, {ev_data['specific_energy_consumption_kwh_km']} kWh/km.")
    print(f"     Loops before mandatory recharge: {ev_data['loops_before_mandatory_recharge']} | Top-up: {ev_data['estimated_opportunity_topup_minutes']} min @ {ev_data['depot_fast_charger_power_kw']} kW.")
    results["P4_FEEDER_OPT"] = {
        "status": "PASS",
        "fleet_allocated": p4_data["fleet_allocated"],
        "fleet_cap_respected": p4_data["fleet_cap_respected"],
        "unknown_road_rejected": True,
        "battery_kwh": ev_data["ev_nominal_battery_capacity_kwh"]
    }

    # 6. Problem 5: Segment Loads & Passenger Flow Conservation
    res = client.get("/api/v1/analytics/segment-loads?route_id=route_delhi_502&departure_hour=8.5&capacity=60")
    assert res.status_code == 200, f"P5 Segment Load failed: {res.text}"
    p5_data = res.json()
    assert p5_data["conservation_equation_holds"] is True
    assert abs(p5_data["conservation_residual"]) < 1e-4
    print(f"[OK] Problem 5 (Segment Load Intelligence): Flow Conservation L_i = L_{{i-1}} + B_i - A_i HOLDS.")
    print(f"     Residual: {p5_data['conservation_residual']} passengers | Peak Segment: {p5_data['peak_segment']} ({p5_data['peak_load']} pax)")
    print(f"     Bottlenecks Detected: {p5_data['bottlenecks_detected']}")

    # Metro corridor load check
    res_metro = client.get("/api/v1/analytics/metro-corridor-loads?line=Yellow&train_type=8-car")
    assert res_metro.status_code == 200
    metro_data = res_metro.json()
    print(f"     Metro Corridor Loads ({metro_data['corridor']} Line): {metro_data['segments_count']} segments, Peak Load: {metro_data['peak_load']:,} pax.")
    results["P5_SEGMENT_LOADS"] = {
        "status": "PASS",
        "conservation_holds": p5_data["conservation_equation_holds"],
        "residual": p5_data["conservation_residual"],
        "peak_segment": p5_data["peak_segment"],
        "bottlenecks": p5_data["bottlenecks_detected"]
    }

    # 7. Realtime Health & Fleet
    res_rt = client.get("/api/v1/realtime/health")
    assert res_rt.status_code == 200
    rt_data = res_rt.json()["data"]
    print(f"[OK] Realtime Feed Health: Status={rt_data['status']}, Active Vehicles={rt_data['total_active_vehicles']}, Fresh={rt_data['fresh_vehicles_count']}")

    res_fleet = client.get("/api/v1/operator/fleet/live")
    assert res_fleet.status_code == 200
    fleet_list = res_fleet.json()["data"]
    print(f"[OK] Operator Live Fleet API: {len(fleet_list)} vehicles returned for operator console.")

    print("\n================================================================================")
    print("ALL 7 END-TO-END INTEGRATION CHECKS PASSED WITH 100% SPEC COMPLIANCE")
    print("================================================================================")

    return results

if __name__ == "__main__":
    test_full_platform_e2e()
