import pytest
from app.engines.od_engine import OdMatrixEngine


def test_od_matrix_furness_ipf_convergence():
    engine = OdMatrixEngine()
    result = engine.compute_biproportional_od_matrix(time_period="AM_PEAK", max_iterations=20)

    assert result["converged"] is True
    assert result["iterations_run"] <= 20
    assert result["total_passenger_trips"] > 0
    assert len(result["matrix"]) == len(result["zones"])
    assert len(result["matrix"][0]) == len(result["zones"])

    # Verify all matrix cells are non-negative
    for row in result["matrix"]:
        for cell in row:
            assert cell >= 0


def test_od_matrix_desire_lines_geojson():
    engine = OdMatrixEngine()
    geojson = engine.export_desire_lines_geojson(time_period="AM_PEAK", min_trips_threshold=500)

    assert geojson["type"] == "FeatureCollection"
    assert len(geojson["features"]) > 0
    feature = geojson["features"][0]
    assert feature["geometry"]["type"] == "LineString"
    assert len(feature["geometry"]["coordinates"]) == 2
    assert "trip_volume" in feature["properties"]
    assert feature["properties"]["trip_volume"] >= 500
