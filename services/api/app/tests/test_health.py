import pytest
from httpx import AsyncClient


@pytest.mark.asyncio
async def test_root_health(client: AsyncClient):
    response = await client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["data"]["status"] == "healthy"
    assert data["data"]["environment"] == "development"


@pytest.mark.asyncio
async def test_v1_health(client: AsyncClient):
    response = await client.get("/api/v1/health")
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["data"]["status"] == "healthy"
    assert "api" in data["data"]["services"]


@pytest.mark.asyncio
async def test_system_info(client: AsyncClient):
    response = await client.get("/api/v1/system/info")
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["data"]["name"] == "YATRA"
    assert "AccessHandshake" in data["data"]["activeModules"]
    assert "CrowdIntelligence" in data["data"]["activeModules"]

