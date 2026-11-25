"""Unit tests verifying GTFS-RT client and processor resilience during failure modes:
1. API timeout
2. HTTP 401 unauthorized
3. Malformed Protobuf
4. Empty response
5. Stale feed detection
"""
import time
import pytest
import httpx
from unittest.mock import AsyncMock, patch, MagicMock
from google.transit import gtfs_realtime_pb2

from app.integrations.gtfs_rt.client import GtfsRtClient
from app.integrations.gtfs_rt.processor import (
    VehiclePositionProcessor,
    STALE_THRESHOLD_SECONDS,
)
from app.schemas.transit import VehiclePositionModel


def create_sample_protobuf_feed(ts: int | None = None) -> bytes:
    feed = gtfs_realtime_pb2.FeedMessage()
    feed.header.gtfs_realtime_version = "2.0"
    feed.header.timestamp = ts or int(time.time())

    entity = feed.entity.add()
    entity.id = "TEST_BUS_01"
    v = entity.vehicle
    v.vehicle.id = "TEST_BUS_01"
    v.position.latitude = 28.6675
    v.position.longitude = 77.2285
    v.position.speed = 8.5
    v.timestamp = ts or int(time.time())
    v.trip.route_id = "502"
    return feed.SerializeToString()


@pytest.mark.asyncio
async def test_failure_mode_timeout():
    """Verify client handles network timeouts gracefully without crashing."""
    client = GtfsRtClient(endpoint_url="https://fake.url/feed.pb", api_key="secret", timeout_seconds=0.1)

    with patch("httpx.AsyncClient.get", side_effect=httpx.TimeoutException("Connection timed out")):
        feed, latency = await client.fetch_feed()
        assert feed is None
        assert "timed out" in client.last_error.lower()

        processor = VehiclePositionProcessor(client=client)
        count = await processor.poll_and_process()
        health = processor.get_health_status()
        assert health.status == "API_ERROR"
        assert health.error_message is not None


@pytest.mark.asyncio
async def test_failure_mode_http_401_unauthorized():
    """Verify client handles HTTP 401 unauthorized gracefully."""
    client = GtfsRtClient(endpoint_url="https://fake.url/feed.pb", api_key="invalid_key")

    mock_resp = MagicMock()
    mock_resp.status_code = 401
    mock_resp.headers = {"content-type": "application/json"}
    mock_resp.text = '{"message":"Given token not valid for any token type"}'

    with patch("httpx.AsyncClient.get", return_value=mock_resp):
        feed, latency = await client.fetch_feed()
        assert feed is None
        assert client.last_status_code == 401
        assert "401" in client.last_error

        processor = VehiclePositionProcessor(client=client)
        await processor.poll_and_process()
        health = processor.get_health_status()
        assert health.status == "API_ERROR"
        assert health.http_status_code == 401


@pytest.mark.asyncio
async def test_failure_mode_malformed_protobuf():
    """Verify client handles corrupted binary streams without raising unhandled exceptions."""
    client = GtfsRtClient(endpoint_url="https://fake.url/feed.pb", api_key="secret")

    mock_resp = MagicMock()
    mock_resp.status_code = 200
    mock_resp.headers = {"content-type": "application/octet-stream"}
    mock_resp.content = b"THIS IS NOT A VALID PROTOCOL BUFFER STREAM \x00\xFF\xAA"
    mock_resp.json.side_effect = ValueError("Invalid JSON")

    with patch("httpx.AsyncClient.get", return_value=mock_resp):
        feed, latency = await client.fetch_feed()
        assert feed is None
        assert "failed to parse" in client.last_error.lower()

        processor = VehiclePositionProcessor(client=client)
        await processor.poll_and_process()
        health = processor.get_health_status()
        assert health.status == "API_ERROR"


@pytest.mark.asyncio
async def test_failure_mode_empty_response():
    """Verify client handles zero-byte responses gracefully."""
    client = GtfsRtClient(endpoint_url="https://fake.url/feed.pb", api_key="secret")

    mock_resp = MagicMock()
    mock_resp.status_code = 200
    mock_resp.headers = {"content-type": "application/octet-stream"}
    mock_resp.content = b""

    with patch("httpx.AsyncClient.get", return_value=mock_resp):
        feed, latency = await client.fetch_feed()
        # Empty protobuf parses to empty FeedMessage
        processor = VehiclePositionProcessor(client=client)
        if feed is not None:
            count = processor._process_protobuf_feed(feed, int(time.time()))
            assert count == 0


@pytest.mark.asyncio
async def test_failure_mode_stale_feed():
    """Verify processor flags vehicles older than STALE_THRESHOLD_SECONDS as stale."""
    now = int(time.time())
    stale_timestamp = now - (STALE_THRESHOLD_SECONDS + 120)  # 420s old (> 300s)

    corrupt_pb_bytes = create_sample_protobuf_feed(ts=stale_timestamp)
    feed = gtfs_realtime_pb2.FeedMessage()
    feed.ParseFromString(corrupt_pb_bytes)

    processor = VehiclePositionProcessor()
    # Clear baseline fleet to isolate test
    processor.vehicles.clear()

    count = processor._process_protobuf_feed(feed, now)
    assert count == 1
    assert "TEST_BUS_01" in processor.vehicles

    v = processor.vehicles["TEST_BUS_01"]
    assert v.is_stale is True
    assert v.freshness_seconds >= STALE_THRESHOLD_SECONDS

    # Verify health status reflects stale data
    health = processor.get_health_status()
    assert health.stale_vehicles_count == 1
    assert health.fresh_vehicles_count == 0
    assert health.status == "STALE_DATA"
