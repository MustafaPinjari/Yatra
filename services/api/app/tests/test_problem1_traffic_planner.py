import pytest
from app.engines.traffic_engine import TrafficEngine
from app.engines.journey_planner import RaptorJourneyPlanner


def test_traffic_engine_congestion_factors():
    engine = TrafficEngine()
    # Morning peak 8:00 - 11:00
    assert engine.get_time_of_day_congestion_factor(9.0) == 1.45
    # Evening peak 17:00 - 20:30
    assert engine.get_time_of_day_congestion_factor(18.5) == 1.55
    # Midday shoulder
    assert engine.get_time_of_day_congestion_factor(14.0) == 1.18
    # Off-peak night
    assert engine.get_time_of_day_congestion_factor(23.0) == 1.00


def test_traffic_engine_dwell_time_with_ramp():
    engine = TrafficEngine()
    res_standard = engine.calculate_segment_travel_time("stop_delhi_001", "stop_delhi_002", ramp_required=False)
    res_ramp = engine.calculate_segment_travel_time("stop_delhi_001", "stop_delhi_002", ramp_required=True)

    assert res_ramp["dwell_time_seconds"] > res_standard["dwell_time_seconds"]
    assert res_ramp["dwell_time_seconds"] == res_standard["dwell_time_seconds"] + 35.0
    assert res_ramp["expected_travel_minutes"] > res_standard["expected_travel_minutes"]
    assert res_ramp["percentile_95_travel_minutes"] >= res_ramp["expected_travel_minutes"]


def test_raptor_journey_planner_direct_or_transfer():
    planner = RaptorJourneyPlanner()
    # Route from Kashmere Gate (28.6675, 77.2285) to AIIMS (28.5684, 77.2078)
    result = planner.plan_multimodal_journey(
        origin_lat=28.6675,
        origin_lon=77.2285,
        dest_lat=28.5684,
        dest_lon=77.2078,
        departure_hour=9.0,
        objective="FASTEST",
    )

    assert result["algorithm"] == "RAPTOR (Round-Based Public Transit Routing)"
    assert result["itineraries_count"] > 0
    itinerary = result["itineraries"][0]
    assert itinerary["total_duration_minutes"] > 0
    assert len(itinerary["legs"]) >= 1
    assert itinerary["relative_crowding_index"] >= 0.0
    assert itinerary["accessibility_score"] >= 0.0


def test_raptor_accessible_routing():
    planner = RaptorJourneyPlanner()
    result = planner.plan_multimodal_journey(
        origin_lat=28.6675,
        origin_lon=77.2285,
        dest_lat=28.5684,
        dest_lon=77.2078,
        departure_hour=9.0,
        wheelchair_only=True,
        objective="MOST_ACCESSIBLE",
    )

    assert result["itineraries_count"] > 0
    top = result["itineraries"][0]
    assert top["is_step_free_accessible"] is True
    assert top["accessibility_score"] >= 75.0
