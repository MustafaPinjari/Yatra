import pytest
from app.engines.crowding_engine import CrowdingEngine


def test_crowding_engine_rci_bounds():
    engine = CrowdingEngine()
    # Route 502 peak hour
    res_peak = engine.estimate_route_crowding("route_delhi_502", hour=9.0)
    assert 0.0 <= res_peak["relative_crowding_index"] <= 1.0
    assert res_peak["crowding_level"] in ["LOW", "MODERATE", "HIGH", "VERY_HIGH", "SEVERE"]
    assert 0.0 <= res_peak["comfort_index"] <= 100.0
    assert res_peak["confidence_level"] in ["HIGH", "MEDIUM", "LOW"]

    # Off-peak should have lower or equal crowding
    res_offpeak = engine.estimate_route_crowding("route_delhi_502", hour=23.0)
    assert res_offpeak["relative_crowding_index"] <= res_peak["relative_crowding_index"]


def test_crowding_engine_etm_scaling():
    engine = CrowdingEngine()
    # ETM sample factor reflects an uncalibrated planning hypothesis, not a measured census expansion
    assert engine.ETM_SAMPLE_EXPANSION_FACTOR > 1.0
    assert engine.ETM_SAMPLE_EXPANSION_FACTOR == 28.5

    res = engine.estimate_route_crowding("route_delhi_502", hour=9.0)
    assert res["expansion_factor_status"] == "UNCALIBRATED_HYPOTHESIS"
    assert res["sample_rate_status"] == "UNVERIFIED_PLANNING_HYPOTHESIS"
    assert res["uncertainty_rating"] == "UNVERIFIED_HEURISTIC"
    assert res["provenance"] == "ESTIMATED_RELATIVE_HEURISTIC"
    assert "YATRA estimates relative crowding" in res["limitation_note"]


def test_crowding_engine_multi_objective_ranking():
    engine = CrowdingEngine()
    mock_itineraries = [
        {"itinerary_id": "ITIN_FAST", "total_duration_minutes": 35.0, "relative_crowding_index": 0.85, "accessibility_score": 70.0},
        {"itinerary_id": "ITIN_COMFORT", "total_duration_minutes": 42.0, "relative_crowding_index": 0.25, "accessibility_score": 75.0},
        {"itinerary_id": "ITIN_ACCESS", "total_duration_minutes": 45.0, "relative_crowding_index": 0.40, "accessibility_score": 98.0},
    ]

    fastest_sorted = engine.rank_itineraries(mock_itineraries, objective="FASTEST")
    assert fastest_sorted[0]["itinerary_id"] == "ITIN_FAST"

    comfort_sorted = engine.rank_itineraries(mock_itineraries, objective="LEAST_CROWDED")
    assert comfort_sorted[0]["itinerary_id"] == "ITIN_COMFORT"

    access_sorted = engine.rank_itineraries(mock_itineraries, objective="MOST_ACCESSIBLE")
    assert access_sorted[0]["itinerary_id"] == "ITIN_ACCESS"
