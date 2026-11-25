import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_api_journey_plan_fastest():
    payload = {
        "origin_lat": 28.6675,
        "origin_lon": 77.2285,
        "destination_lat": 28.5684,
        "destination_lon": 77.2078,
        "departure_hour": 9.0,
        "objective": "FASTEST",
    }
    response = client.post("/api/v1/analytics/journey/plan", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["algorithm"] == "RAPTOR (Round-Based Public Transit Routing)"
    assert data["itineraries_count"] > 0
    assert "legs" in data["itineraries"][0]


def test_api_crowding_estimate():
    response = client.get("/api/v1/analytics/crowding?route_id=route_delhi_502&hour=8.5")
    assert response.status_code == 200
    data = response.json()
    assert "relative_crowding_index" in data
    assert "comfort_index" in data
    assert 0.0 <= data["relative_crowding_index"] <= 1.0


def test_api_od_matrix():
    response = client.get("/api/v1/analytics/od-matrix?time_period=AM_PEAK")
    assert response.status_code == 200
    data = response.json()
    assert data["converged"] is True
    assert len(data["matrix"]) > 0


def test_api_od_desire_lines():
    response = client.get("/api/v1/analytics/od-desire-lines?time_period=AM_PEAK&min_trips_threshold=1000")
    assert response.status_code == 200
    data = response.json()
    assert data["type"] == "FeatureCollection"


def test_api_feeder_routes_constraints():
    response = client.get("/api/v1/analytics/feeder-routes?max_fleet=500")
    assert response.status_code == 200
    data = response.json()
    assert data["fleet_cap_respected"] is True
    assert data["all_routes_under_length_cap"] is True
    assert data["all_roads_eligible"] is True
    assert data["fleet_allocated"] <= 500


def test_api_feeder_routes_fleet_cap_violation():
    # Attempting to allocate > 500 electric buses should return 400 Bad Request
    response = client.get("/api/v1/analytics/feeder-routes?max_fleet=600")
    assert response.status_code == 422 or response.status_code == 400


def test_api_feeder_road_width_check():
    # Wide road
    res_wide = client.get("/api/v1/analytics/feeder-routes/check-road?u=METRO_AIIMS&v=AIIMS_SAFDARJUNG")
    assert res_wide.status_code == 200
    assert res_wide.json()["is_bus_eligible"] is True

    # Narrow gali
    res_narrow = client.get("/api/v1/analytics/feeder-routes/check-road?u=AIIMS_KIDWAI_NAGAR&v=AIIMS_KOTLA_NARROW")
    assert res_narrow.status_code == 200
    assert res_narrow.json()["is_bus_eligible"] is False


def test_api_segment_loads():
    response = client.get("/api/v1/analytics/segment-loads?route_id=route_delhi_502&departure_hour=8.5")
    assert response.status_code == 200
    data = response.json()
    assert data["conservation_equation_holds"] is True
    assert len(data["segments"]) > 0


def test_api_metro_corridor_loads():
    response = client.get("/api/v1/analytics/metro-corridor-loads?line=Yellow&train_type=8-car")
    assert response.status_code == 200
    data = response.json()
    assert "Yellow" in data["corridor"]
    assert len(data["segments"]) > 0


def test_api_validation_metrics():
    response = client.get("/api/v1/analytics/validation/metrics")
    assert response.status_code == 200
    data = response.json()
    assert data["traffic_mae_minutes"] == 6.71
    assert data["traffic_mape_percent"] == 12.91
    assert data["congestion_multipliers_calibrated"] is False
    assert data["historical_gps_traces_present"] is False
    assert data["etm_ticketing_data_present"] is False
    assert data["conservation_equation_satisfied"] is True


def test_api_od_sensitivity():
    response = client.get("/api/v1/analytics/od-sensitivity?time_period=AM_PEAK")
    assert response.status_code == 200
    data = response.json()
    assert len(data["sensitivity_runs"]) == 3
    assert data["sensitivity_runs"][0]["gamma"] == 0.04
    assert data["sensitivity_runs"][1]["gamma"] == 0.08
    assert data["sensitivity_runs"][2]["gamma"] == 0.12


def test_api_feeder_sensitivity():
    response = client.get("/api/v1/analytics/feeder-sensitivity?max_fleet=500")
    assert response.status_code == 200
    data = response.json()
    assert len(data["sensitivity_runs"]) == 5
    assert data["fleet_cap"] == 500


def test_api_feeder_ev_energy():
    response = client.get("/api/v1/analytics/feeder-ev-energy?daily_trips=16")
    assert response.status_code == 200
    data = response.json()
    assert data["ev_nominal_battery_capacity_kwh"] == 180.0
    assert data["usable_battery_capacity_kwh"] == 144.0
    assert data["specific_energy_consumption_kwh_km"] == 1.15
    assert data["complete_loops_before_recharge"] == 21
    assert data["theoretical_range_km"] == 125.22
    assert data["opportunity_charging_energy_kwh"] == 45.0
    assert data["opportunity_charging_additional_range_km"] == 39.13


def test_api_journey_plan_invalid_coordinates():
    # Out of Delhi NCT bounds (lat > 29.0)
    payload = {
        "origin_lat": 35.6675,
        "origin_lon": 77.2285,
        "destination_lat": 28.5684,
        "destination_lon": 77.2078,
        "departure_hour": 9.0,
    }
    response = client.post("/api/v1/analytics/journey/plan", json=payload)
    assert response.status_code == 422
