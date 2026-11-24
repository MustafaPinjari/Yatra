from fastapi import APIRouter

from app.api.v1.endpoints import analytics, health, realtime, system, transit

api_router = APIRouter()

api_router.include_router(health.router, tags=["Health"])
api_router.include_router(system.router, prefix="/system", tags=["System"])
api_router.include_router(transit.router, tags=["GTFS Static & Transit"])
api_router.include_router(realtime.router, tags=["GTFS-Realtime & Fleet"])
api_router.include_router(analytics.router, tags=["Transit Intelligence & Analytics"])
