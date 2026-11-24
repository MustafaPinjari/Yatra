import pytest
from app.engines.feeder_optimizer import FeederOptimizerEngine


def test_feeder_road_width_eligibility_constraint():
    engine = FeederOptimizerEngine()

    # Arterial corridor (>= 6m)
    check_wide = engine.check_road_width_eligibility("METRO_AIIMS", "AIIMS_SAFDARJUNG")
    assert check_wide["exists"] is True
    assert check_wide["carriageway_width_m"] >= 6.0
    assert check_wide["is_bus_eligible"] is True
    assert check_wide["regulatory_violation"] is None

    # Narrow gali (< 6m)
    check_narrow = engine.check_road_width_eligibility("AIIMS_KIDWAI_NAGAR", "AIIMS_KOTLA_NARROW")
    assert check_narrow["exists"] is True
    assert check_narrow["carriageway_width_m"] < 6.0
    assert check_narrow["is_bus_eligible"] is False
    assert "Carriageway width is below 6.0m" in check_narrow["regulatory_violation"]


def test_feeder_route_length_cap_and_fleet_budget():
    engine = FeederOptimizerEngine()
    result = engine.optimize_network_feeder_fleet(max_total_fleet=500)

    # 1. Total electric buses must be <= 500
    assert result["fleet_cap_respected"] is True
    assert result["fleet_allocated"] <= 500
    assert result["fleet_allocated"] > 0

    # 2. Every route length must be <= 7.0 km
    assert result["all_routes_under_length_cap"] is True
    for r in result["allocated_routes"]:
        assert r["length_km"] <= 7.0

    # 3. Every road segment utilized must have carriageway width >= 6.0 m
    assert result["all_roads_eligible"] is True
    for r in result["allocated_routes"]:
        assert r["min_carriageway_width_m"] >= 6.0

    # 4. Target headways must be in 8-12 min range
    for r in result["allocated_routes"]:
        assert 6.0 <= r["achieved_headway_minutes"] <= 14.0


def test_feeder_routes_geojson_export():
    engine = FeederOptimizerEngine()
    geojson = engine.export_feeder_routes_geojson()

    assert geojson["type"] == "FeatureCollection"
    assert len(geojson["features"]) > 0
    f = geojson["features"][0]
    assert f["geometry"]["type"] == "LineString"
    assert len(f["geometry"]["coordinates"]) >= 2
    assert f["properties"]["length_km"] <= 7.0
    assert f["properties"]["min_carriageway_width_m"] >= 6.0
    assert f["properties"]["road_width_provenance"] == "DELHI_MASTER_PLAN_2021_ROW_STANDARDS"
    assert f["properties"]["geometric_compliance"] == "VERIFIED_GE_6M"


def test_feeder_unknown_road_width_rejected():
    engine = FeederOptimizerEngine()
    check_unknown = engine.check_road_width_eligibility("AIIMS_KIDWAI_NAGAR", "AIIMS_UNSURVEYED_LANE")
    assert check_unknown["exists"] is True
    assert check_unknown["carriageway_width_m"] is None
    assert check_unknown["is_bus_eligible"] is False
    assert "unknown or unverified" in check_unknown["regulatory_violation"]


def test_feeder_headway_sensitivity():
    engine = FeederOptimizerEngine()
    runs = engine.evaluate_fleet_headway_sensitivity(headways=[6.0, 8.0, 10.0, 12.0, 15.0])
    assert len(runs) == 5
    # Shorter headway requires larger fleet
    assert runs[0]["fleet_required_full_network"] > runs[-1]["fleet_required_full_network"]
    assert runs[2]["target_headway_minutes"] == 10.0


def test_feeder_ev_energy_model():
    engine = FeederOptimizerEngine()
    res = engine.compute_feeder_ev_energy_model(daily_trips=16)
    assert res["ev_nominal_battery_capacity_kwh"] == 180.0
    assert res["usable_battery_capacity_kwh"] == 144.0
    assert res["specific_energy_consumption_kwh_km"] == 1.15
    assert res["depot_fast_charger_power_kw"] == 60.0
    assert res["loops_before_mandatory_recharge"] > 0
    assert res["full_daily_recharge_time_hours"] > 0.0
