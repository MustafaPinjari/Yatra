import asyncio
from collections.abc import AsyncGenerator
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1.api import api_router
from app.core.config import get_settings
from app.core.logging import setup_logging
from app.integrations.gtfs_rt.processor import get_vehicle_processor
from app.middleware.error_handler import global_exception_handler
from app.schemas.common import ApiResponse, HealthResponse

settings = get_settings()
setup_logging(settings.LOG_LEVEL)


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    # Non-blocking background startup poll for GTFS-RT feed
    processor = get_vehicle_processor()
    if processor.client.is_configured:
        asyncio.create_task(processor.poll_and_process())
    yield
    # Shutdown actions


app = FastAPI(
    title=settings.APP_NAME,
    description="Universal Public Transit Accessibility & Operations Platform",
    version=settings.VERSION,
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
)

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global Exception Handler
app.add_exception_handler(Exception, global_exception_handler)


# Root unauthenticated health check
@app.get("/health", response_model=ApiResponse[HealthResponse], tags=["Root"])
async def root_health() -> ApiResponse[HealthResponse]:
    return ApiResponse(
        success=True,
        data=HealthResponse(
            status="healthy",
            environment=settings.ENVIRONMENT,
            services={"api": "operational"},
        ),
    )


# Include API v1 Router
app.include_router(api_router, prefix="/api/v1")
