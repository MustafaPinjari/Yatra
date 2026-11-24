import time
import pytest
from google.transit import gtfs_realtime_pb2

from app.integrations.gtfs_rt.client import GtfsRtClient
from app.integrations.gtfs_rt.processor import VehiclePositionProcessor


def create_mock_protobuf_feed(
    vehicle_id: str = "DL_1PD_9999",
    lat: float = 28.5684,
    lon: float = 77.2078,
    timestamp: int | None = None,
) -> gtfs_realtime_pb2.FeedMessage:
    """Creates a GTFS-RT Protobuf FeedMessage in memory."""
    feed = gtfs_realtime_pb2.FeedMessage()
    feed.header.gtfs_realtime_version = "2.0"
    feed.header.incrementality = gtfs_realtime_pb2.FeedHeader.FULL_DATASET
    feed.header.timestamp = timestamp or int(time.time())

    entity = feed.entity.add()
    entity.id = vehicle_id
    vehicle = entity.vehicle
    vehicle.vehicle.id = vehicle_id
    vehicle.trip.route_id = "route_delhi_502"
    vehicle.trip.trip_id = "TRIP_502_0830"
    vehicle.position.latitude = lat
    vehicle.position.longitude = lon
    vehicle.position.bearing = 180.0
    vehicle.position.speed = 10.0  # m/s -> 36 km/h
    vehicle.timestamp = timestamp or int(time.time())
    vehicle.current_status = gtfs_realtime_pb2.VehiclePosition.IN_TRANSIT_TO
    return feed


def test_gtfs_rt_client_unconfigured():
    client = GtfsRtClient(endpoint_url="", api_key="")
    assert client.is_configured is False


def test_gtfs_rt_client_configured():
    client = GtfsRtClient(endpoint_url="https://api.delhi.gov.in/gtfs-rt", api_key="test_secret_key")
    assert client.is_configured is True
    # Ensure key is not in default string representation
    assert "test_secret_key" not in repr(client)


def test_vehicle_processor_protobuf_processing():
    processor = VehiclePositionProcessor()
    feed = create_mock_protobuf_feed(vehicle_id="BUS_TEST_01", lat=28.5684, lon=77.2078)
    now = int(time.time())

    count = processor._process_protobuf_feed(feed, now)
    assert count == 1
    assert "BUS_TEST_01" in processor.vehicles

    v = processor.vehicles["BUS_TEST_01"]
    assert round(v.latitude, 4) == 28.5684
    assert round(v.longitude, 4) == 77.2078
    assert v.speed_kmh == 36.0  # 10 m/s * 3.6
    assert v.route_short_name == "502"  # Enriched from static GTFS repo
    assert v.is_stale is False


def test_vehicle_processor_out_of_bounds_filtering():
    processor = VehiclePositionProcessor()
    # Mumbai coordinate (lat 19.07, lon 72.87) — outside Delhi bounds
    feed = create_mock_protobuf_feed(vehicle_id="BUS_OUT_OF_BOUNDS", lat=19.0760, lon=72.8777)
    now = int(time.time())

    count = processor._process_protobuf_feed(feed, now)
    assert count == 0
    assert "BUS_OUT_OF_BOUNDS" not in processor.vehicles


def test_vehicle_processor_stale_detection():
    processor = VehiclePositionProcessor()
    # 600 seconds old timestamp (10 minutes ago)
    stale_ts = int(time.time()) - 600
    feed = create_mock_protobuf_feed(vehicle_id="BUS_STALE", timestamp=stale_ts)
    now = int(time.time())

    processor._process_protobuf_feed(feed, now)
    v = processor.vehicles["BUS_STALE"]
    assert v.is_stale is True
    assert v.freshness_seconds >= 600


def test_vehicle_processor_json_processing():
    processor = VehiclePositionProcessor()
    now = int(time.time())
    json_data = {
        "entity": [
            {
                "id": "BUS_JSON_01",
                "vehicle": {
                    "vehicle": {"id": "BUS_JSON_01"},
                    "position": {"latitude": 28.6415, "longitude": 77.2405, "bearing": 90.0, "speed": 8.0},
                    "timestamp": now - 30,
                    "trip": {"route_id": "route_delhi_534"},
                },
            }
        ]
    }

    count = processor._process_json_feed(json_data, now)
    assert count == 1
    assert "BUS_JSON_01" in processor.vehicles
    assert processor.vehicles["BUS_JSON_01"].latitude == 28.6415
