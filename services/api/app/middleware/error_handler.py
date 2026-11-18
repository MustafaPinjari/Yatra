import logging

from fastapi import Request, status
from fastapi.responses import JSONResponse

from app.schemas.common import ApiError, ApiMetadata, ApiResponse

logger = logging.getLogger(__name__)


async def global_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    logger.exception("Unhandled error occurred while processing request: %s", exc)
    error_payload = ApiResponse(
        success=False,
        error=ApiError(
            code="INTERNAL_SERVER_ERROR",
            message="An unexpected error occurred. Please contact system support.",
        ),
        metadata=ApiMetadata(requestId=request.headers.get("x-request-id")),
    )
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content=error_payload.model_dump(mode="json"),
    )
