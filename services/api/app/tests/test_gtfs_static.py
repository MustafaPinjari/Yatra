import io
import zipfile
import pytest

from app.integrations.gtfs.parser import GtfsParser
from app.integrations.gtfs.storage import TransitRepository


def create_mock_gtfs_zip(
    include_required: bool = True,
    corrupt_coord: bool = False,
    out_of_bounds_coord: bool = False,
) -> bytes:
    """Helper to generate in-memory GTFS ZIP archive for unit testing."""
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as zf:
        if include_required:
            zf.writestr(
                "agency.txt",
                "agency_id,agency_name,agency_url,agency_timezone\n"
                "DTC,Delhi Transport Corporation,http://dtc.delhi.gov.in,Asia/Kolkata\n",
            )

            lat_val = "INVALID_LAT" if corrupt_coord else ("12.9716" if out_of_bounds_coord else "28.6675")
            lon_val = "77.2285"

            zf.writestr(
                "stops.txt",
                "stop_id,stop_name,stop_lat,stop_lon,wheelchair_boarding\n"
                f"STOP_01,Kashmere Gate ISBT,{lat_val},{lon_val},1\n"
                "STOP_02,AIIMS Metro Station,28.5684,77.2078,1\n"
                "STOP_03,Delhi Gate,28.6415,77.2405,0\n",
            )

            zf.writestr(
                "routes.txt",
                "route_id,route_short_name,route_long_name,route_type\n"
                "ROUTE_502,502,Kashmere Gate to Mehrauli,3\n"
                "ROUTE_534,534,Anand Vihar to Mehrauli,3\n",
            )

            zf.writestr(
                "trips.txt",
                "trip_id,route_id,service_id,trip_headsign\n"
                "TRIP_502_01,ROUTE_502,DAILY,Mehrauli Terminal\n"
                "TRIP_502_02,ROUTE_UNKNOWN,DAILY,Unknown Destination\n",  # Intentional orphan for FK test
            )

            zf.writestr(
                "stop_times.txt",
                "trip_id,stop_id,arrival_time,departure_time,stop_sequence\n"
                "TRIP_502_01,STOP_01,08:00:00,08:00:00,1\n"
                "TRIP_502_01,STOP_02,08:35:00,08:35:00,2\n"
                "TRIP_502_01,NON_EXISTENT_STOP,08:50:00,08:50:00,3\n",  # Intentional orphan
            )
        else:
            # Only agency provided, missing stops and routes
            zf.writestr(
                "agency.txt",
                "agency_id,agency_name,agency_url,agency_timezone\n"
                "DTC,Delhi Transport Corporation,http://dtc.delhi.gov.in,Asia/Kolkata\n",
            )
    return buf.getvalue()


def test_gtfs_parser_valid_feed():
    zip_bytes = create_mock_gtfs_zip(include_required=True)
    parser = GtfsParser(zip_bytes)
    report = parser.parse()

    assert report.import_status == "PARTIAL" or report.import_status == "SUCCESS"
    assert report.summary.total_agencies == 1
    assert report.summary.total_stops == 3
    assert report.summary.total_routes == 2
    assert report.summary.total_trips == 2
    assert report.summary.total_stop_times == 3
    assert "STOP_01" in parser.stops
    assert parser.stops["STOP_01"].stop_name == "Kashmere Gate ISBT"
    assert parser.stops["STOP_01"].has_wheelchair_ramp is True


def test_gtfs_parser_missing_required_files():
    zip_bytes = create_mock_gtfs_zip(include_required=False)
    parser = GtfsParser(zip_bytes)
    report = parser.parse()

    assert report.import_status == "FAILED"
    assert "stops.txt" in report.summary.missing_required_files
    assert "routes.txt" in report.summary.missing_required_files


def test_gtfs_parser_corrupt_coordinates():
    zip_bytes = create_mock_gtfs_zip(include_required=True, corrupt_coord=True)
    parser = GtfsParser(zip_bytes)
    report = parser.parse()

    # The invalid coordinate stop should be skipped, leaving 2 stops
    assert report.summary.total_stops == 2
    assert any("Invalid coordinate" in w for w in report.summary.validation_warnings)


def test_gtfs_parser_out_of_bounds_warning():
    zip_bytes = create_mock_gtfs_zip(include_required=True, out_of_bounds_coord=True)
    parser = GtfsParser(zip_bytes)
    report = parser.parse()

    # Stop is parsed but warned about out-of-bounds latitude (Bangalore coords)
    assert any("out of Delhi bounds" in w for w in report.summary.validation_warnings)


def test_gtfs_parser_referential_integrity():
    zip_bytes = create_mock_gtfs_zip(include_required=True)
    parser = GtfsParser(zip_bytes)
    report = parser.parse()

    # Verify that orphan trip and orphan stop_time are detected and reported
    assert any("unknown route_id" in w for w in report.summary.validation_warnings)
    assert any("non-existent stop_id" in w for w in report.summary.validation_warnings)


def test_transit_repository_spatial_query():
    repo = TransitRepository()
    # Query near Kashmere Gate (28.6675, 77.2285) with 5km radius
    nearby = repo.get_all_stops(lat=28.6675, lon=77.2285, radius_km=5.0)
    assert len(nearby) > 0

    # Distance calculation test
    d = TransitRepository.haversine_distance_km(28.6675, 77.2285, 28.5684, 77.2078)
    assert 10.0 < d < 15.0  # Approx 11.2 km between Kashmere Gate and AIIMS
