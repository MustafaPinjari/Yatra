import pytest
from httpx import ASGITransport, AsyncClient

from app.main import app


@pytest.mark.asyncio
async def test_get_gtfs_status():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        resp = await client.get("/api/v1/gtfs/status")
        assert resp.status_code == 200
        body = resp.json()
        assert body["success"] is True
        assert "totalStops" in body["data"]
        assert "totalRoutes" in body["data"]
        assert body["data"]["totalRoutes"] >= 3


@pytest.mark.asyncio
async def test_get_routes_and_stops():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        # 1. List routes
        resp = await client.get("/api/v1/routes")
        assert resp.status_code == 200
        body = resp.json()
        assert body["success"] is True
        assert len(body["data"]) >= 3

        # 2. Get specific route
        route_resp = await client.get("/api/v1/routes/route_delhi_502")
        assert route_resp.status_code == 200
        assert route_resp.json()["data"]["route_short_name"] == "502"

        # 3. Get route stops
        stops_resp = await client.get("/api/v1/routes/route_delhi_502/stops")
        assert stops_resp.status_code == 200
        assert len(stops_resp.json()["data"]) > 0

        # 4. List stops with spatial radius query (near AIIMS: 28.5684, 77.2078)
        radius_resp = await client.get("/api/v1/stops?lat=28.5684&lon=77.2078&radius_km=5.0")
        assert radius_resp.status_code == 200
        assert len(radius_resp.json()["data"]) > 0


@pytest.mark.asyncio
async def test_get_realtime_endpoints():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        # 1. Realtime vehicles
        resp = await client.get("/api/v1/realtime/vehicles")
        assert resp.status_code == 200
        body = resp.json()
        assert body["success"] is True
        assert len(body["data"]) >= 3

        # 2. Realtime health
        health_resp = await client.get("/api/v1/realtime/health")
        assert health_resp.status_code == 200
        health_body = health_resp.json()
        assert health_body["success"] is True
        assert "status" in health_body["data"]
        assert "total_active_vehicles" in health_body["data"]

        # 3. Operator fleet live alias
        fleet_resp = await client.get("/api/v1/operator/fleet/live")
        assert fleet_resp.status_code == 200
        fleet_body = fleet_resp.json()
        assert fleet_body["success"] is True
        assert len(fleet_body["data"]) >= 3
        first_bus = fleet_body["data"][0]
        assert "vehicleId" in first_bus
        assert "coordinates" in first_bus
