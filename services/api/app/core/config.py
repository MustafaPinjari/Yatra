from functools import lru_cache

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    APP_NAME: str = "YATRA"
    ENVIRONMENT: str = "development"
    DEBUG: bool = True
    LOG_LEVEL: str = "INFO"
    VERSION: str = "0.1.0"

    API_HOST: str = "0.0.0.0"
    API_PORT: int = 8000
    CORS_ORIGINS: list[str] = [
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "http://localhost:8000",
        "http://127.0.0.1:8000",
        "*",
    ]
    CORS_ORIGIN_REGEX: str = r"^https?://.*"

    # Database & Cache
    DATABASE_URL: str = "postgresql+asyncpg://postgres:postgres@localhost:5432/yatra_dev"
    SYNC_DATABASE_URL: str = "postgresql://postgres:postgres@localhost:5432/yatra_dev"
    REDIS_URL: str = "redis://localhost:6379/0"

    # Security
    JWT_SECRET: str = "replace_with_a_secure_random_secret_key_minimum_32_chars"
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60

    # Google AI
    GEMINI_API_KEY: str = Field(default="")
    GEMINI_MODEL: str = "gemini-2.5-flash"

    # Delhi Transport Stack (DTS) Integrations
    DTS_GTFS_STATIC_URL: str = Field(default="")
    DTS_GTFS_RT_API_ENDPOINT: str = Field(default="")
    DTS_GTFS_RT_API_KEY: str = Field(default="")
    DTS_GTFS_RT_POLL_INTERVAL_SECONDS: int = 15
    DATA_DIR: str = "./data"
    GTFS_DIR: str = "./data/gtfs"

    # Blockchain (Sepolia)
    ETHEREUM_SEPOLIA_RPC_URL: str = "https://rpc.sepolia.org"
    TRUST_CONTRACT_ADDRESS: str = "0x0000000000000000000000000000000000000000"


@lru_cache
def get_settings() -> Settings:
    return Settings()
