import pytest
from app.engines.segment_load_engine import SegmentLoadEngine


def test_passenger_flow_conservation_equation():
    engine = SegmentLoadEngine()
    result = engine.compute_route_segment_loads(route_id="route_delhi_502", departure_hour=8.5)

    assert result["stops_count"] > 1
    assert result["segments_count"] == result["stops_count"] - 1

    # Invariant: Conservation equation holds (terminal load == 0)
    assert result["conservation_equation_holds"] is True
    assert result["conservation_residual"] < 1.0

    # Total boardings must equal total alightings
    assert abs(result["total_boardings"] - result["total_alightings"]) < 1.0

    # All segment loads must be non-negative
    for seg in result["segments"]:
        assert seg["passenger_load"] >= 0.0
        assert seg["vehicle_capacity"] == 60


def test_missing_alighting_estimation():
    engine = SegmentLoadEngine()
    boardings = [20.0, 15.0, 10.0, 5.0, 0.0]
    stop_ids = ["S1", "S2", "S3", "S4", "S5"]

    alightings = engine.estimate_alightings_from_boardings(boardings, stop_ids)
    assert len(alightings) == 5
    # First stop has 0 alightings
    assert alightings[0] == 0.0
    # Total alightings must equal total boardings exactly
    assert round(sum(alightings), 1) == round(sum(boardings), 1)


def test_bottleneck_detection():
    engine = SegmentLoadEngine()
    # High boardings early to trigger bottleneck (> 90% of capacity 60 = 54)
    boardings = [50.0, 20.0, 10.0, 0.0]
    alightings = [0.0, 2.0, 5.0, 73.0]

    res = engine.compute_route_segment_loads(
        route_id="test_route",
        boardings_input=boardings,
        alightings_input=alightings,
        capacity=60,
    )

    assert res["bottlenecks_detected"] >= 1
    bottleneck = res["bottleneck_segments"][0]
    assert bottleneck["load_factor"] >= 0.90
    assert "relief bus" in bottleneck["recommended_action"] or "headway" in bottleneck["recommended_action"]


def test_metro_corridor_loads():
    engine = SegmentLoadEngine()
    res = engine.compute_metro_corridor_loads(line_name="Yellow", train_type="8-car")

    assert "Yellow" in res["corridor"]
    assert res["train_nominal_capacity"] == 2000
    assert res["total_stations"] > 0
    assert res["peak_load"] > 0


def test_segment_load_uncertainty_and_provenance():
    engine = SegmentLoadEngine()
    res = engine.compute_route_segment_loads(route_id="route_delhi_502", departure_hour=8.5)

    assert "flow_conservation_note" in res
    assert "identity" in res["flow_conservation_note"]
    assert res["data_provenance"] == "GTFS_ROUTE_SEQUENCE_WITH_ESTIMATED_ALIGHTINGS"

    # Check uncertainty bounds on segments
    for seg in res["segments"]:
        assert seg["observed_boardings"] >= 0.0
        assert seg["is_alighting_estimated"] is True
        assert seg["passenger_load_lower_bound"] <= seg["passenger_load"]
        assert seg["passenger_load_upper_bound"] >= seg["passenger_load"]
        assert 0.0 <= seg["uncertainty_margin_percent"] <= 30.0


def test_segment_load_boundary_conditions_and_edge_cases():
    engine = SegmentLoadEngine()
    res = engine.compute_route_segment_loads(route_id="route_delhi_502", departure_hour=8.5)

    # Invariant: Terminal residual explanation explicitly documents model boundary condition
    assert "boundary condition" in res["terminal_residual_explanation"]
    assert res["conservation_residual"] < 1.0

    # Test empty boardings raises ValueError
    with pytest.raises(ValueError, match="cannot be empty"):
        engine.compute_route_segment_loads(route_id="test_route", boardings_input=[])

    # Test mismatched boardings length raises ValueError on known route
    with pytest.raises(ValueError, match="must match stop count"):
        engine.compute_route_segment_loads(route_id="route_delhi_502", boardings_input=[10.0, 5.0])

    # Test mismatched alightings length raises ValueError
    with pytest.raises(ValueError, match="must match stop count"):
        engine.compute_route_segment_loads(
            route_id="test_route",
            boardings_input=[10.0, 5.0],
            alightings_input=[0.0, 10.0, 5.0],
        )

    # Test negative boardings are clamped to non-negative without negative passenger loads
    stops = engine.repo.get_route_stops("route_delhi_502")
    n = len(stops) if stops else 12
    boardings_with_negatives = [-10.0] + [5.0] * (n - 2) + [0.0]
    res_clamped = engine.compute_route_segment_loads(
        route_id="route_delhi_502",
        boardings_input=boardings_with_negatives,
    )
    for seg in res_clamped["segments"]:
        assert seg["passenger_load"] >= 0.0
