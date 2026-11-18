from fastapi import APIRouter

from app.core.config import get_settings
from app.schemas.common import ApiResponse, SystemInfoResponse

router = APIRouter()
settings = get_settings()


@router.get("/info", response_model=ApiResponse[SystemInfoResponse])
async def get_system_info() -> ApiResponse[SystemInfoResponse]:
    return ApiResponse(
        success=True,
        data=SystemInfoResponse(
            name=settings.APP_NAME,
            version=settings.VERSION,
            environment=settings.ENVIRONMENT,
            activeModules=[
                "AccessGraph",
                "AccessHandshake",
                "DriverAssist",
                "OperatorCommand",
                "CrowdIntelligence",
                "TrustLedger",
            ],
        ),
    )
