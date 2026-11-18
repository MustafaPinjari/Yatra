from fastapi import APIRouter

from app.core.config import get_settings
from app.schemas.common import ApiResponse, HealthResponse

router = APIRouter()
settings = get_settings()


@router.get("/health", response_model=ApiResponse[HealthResponse])
async def get_health_status() -> ApiResponse[HealthResponse]:
    return ApiResponse(
        success=True,
        data=HealthResponse(
            status="healthy",
            environment=settings.ENVIRONMENT,
            services={
                "api": "operational",
                "database": "configured",
                "redis": "configured",
            },
        ),
    )
