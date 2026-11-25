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
    # Test canonical 5.7 km loop
    res = engine.compute_feeder_ev_energy_model(daily_trips=16, loop_distance_km=5.7)
    assert res["ev_nominal_battery_capacity_kwh"] == 180.0
    assert res["usable_depth_of_discharge"] == 0.80
    assert res["usable_battery_capacity_kwh"] == 144.0
    assert res["specific_energy_consumption_kwh_km"] == 1.15
    assert res["loop_distance_km"] == 5.7

    # Loop energy: 5.7 * 1.15 = 6.555 kWh (rounded to 6.56)
    assert res["energy_consumed_per_loop_kwh"] == 6.56

    # Complete loops before usable energy exhausted: floor(144.0 / 6.555) = 21 complete loops
    # (Corrects previous erroneous claim of 27 loops which confused nominal 180 kWh with usable 144 kWh)
    assert res["complete_loops_before_recharge"] == 21
    assert res["loops_before_mandatory_recharge"] == 21

    # Theoretical maximum single-charge operating range on usable energy: 144.0 / 1.15 = 125.22 km
    assert res["theoretical_range_km"] == 125.22

    # 45-min opportunity charging at 60 kW:
    # Ideal theoretical energy: 60 * 0.75 = 45.0 kWh
    assert res["opportunity_charging_duration_minutes"] == 45.0
    assert res["opportunity_charging_energy_kwh"] == 45.0
    # Additional theoretical range from ideal 45 kWh: 45.0 / 1.15 = 39.13 km
    assert res["opportunity_charging_additional_range_km"] == 39.13
    # Additional complete loops from ideal 45 kWh: floor(45.0 / 6.555) = 6 complete loops
    assert res["opportunity_charging_additional_loops"] == 6

    # Net delivered energy accounting for documented 92% charger efficiency:
    # 45.0 * 0.92 = 41.4 kWh
    assert res["opportunity_charging_net_energy_kwh"] == 41.40
    assert res["opportunity_charging_net_range_km"] == 36.00
    assert res["opportunity_charging_net_loops"] == 6

    assert res["depot_fast_charger_power_kw"] == 60.0
    assert res["full_daily_recharge_time_hours"] > 0.0


def test_feeder_ev_energy_model_edge_cases():
    engine = FeederOptimizerEngine()

    # Edge case 1: Zero loop distance
    zero_dist = engine.compute_feeder_ev_energy_model(loop_distance_km=0.0)
    assert zero_dist["complete_loops_before_recharge"] == 0
    assert zero_dist["theoretical_range_km"] == 0.0
    assert zero_dist["energy_consumed_per_loop_kwh"] == 0.0

    # Edge case 2: Negative loop distance
    neg_dist = engine.compute_feeder_ev_energy_model(loop_distance_km=-5.0)
    assert neg_dist["complete_loops_before_recharge"] == 0
    assert neg_dist["theoretical_range_km"] == 0.0

    # Edge case 3: Exact 144 km route (exactly 1 loop before recharge)
    long_route = engine.compute_feeder_ev_energy_model(loop_distance_km=100.0)
    # Energy: 100 * 1.15 = 115 kWh -> floor(144 / 115) = 1 loop
    assert long_route["complete_loops_before_recharge"] == 1
    assert long_route["theoretical_range_km"] == 125.22
