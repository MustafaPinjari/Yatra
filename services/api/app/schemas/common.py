from datetime import UTC, datetime
from typing import Any, TypeVar

from pydantic import BaseModel, Field

T = TypeVar("T")


class ApiMetadata(BaseModel):
    timestamp: datetime = Field(default_factory=lambda: datetime.now(UTC))
    version: str = "0.1.0"
    requestId: str | None = None


class ApiError(BaseModel):
    code: str
    message: str
    details: Any | None = None


class ApiResponse[T](BaseModel):
    success: bool = True
    data: T | None = None
    error: ApiError | None = None
    metadata: ApiMetadata = Field(default_factory=ApiMetadata)


class HealthResponse(BaseModel):
    status: str = "healthy"
    environment: str
    timestamp: datetime = Field(default_factory=lambda: datetime.now(UTC))
    services: dict[str, str] = Field(default_factory=dict)


class SystemInfoResponse(BaseModel):
    name: str = "YATRA"
    version: str = "0.1.0"
    description: str = "Your Accessible Transport & Reliable Assistance Platform"
    environment: str
    activeModules: list[str] = Field(default_factory=list)
