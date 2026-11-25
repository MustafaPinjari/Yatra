import asyncio
import logging
import time
from typing import Any
import httpx

from google.transit import gtfs_realtime_pb2
from app.core.config import get_settings

logger = logging.getLogger("yatra.gtfs_rt.client")


class GtfsRtClient:
    """Production-grade client for Delhi Transport Stack GTFS-Realtime APIs.

    Supports Protocol Buffer (protobuf) and JSON response formats,
    secure API key authentication, connection timeouts, and exponential backoff.
    """

    def __init__(
        self,
        endpoint_url: str | None = None,
        api_key: str | None = None,
        timeout_seconds: float = 15.0,
    ) -> None:
        settings = get_settings()
        self.endpoint_url = endpoint_url if endpoint_url is not None else settings.DTS_GTFS_RT_API_ENDPOINT
        self.api_key = api_key if api_key is not None else settings.DTS_GTFS_RT_API_KEY
        self.timeout_seconds = timeout_seconds
        self.last_status_code: int | None = None
        self.last_latency_ms: float = 0.0
        self.last_network_latency_ms: float = 0.0
        self.last_decode_ms: float = 0.0
        self.last_error: str | None = None

    @property
    def is_configured(self) -> bool:
        """Returns True only if both endpoint URL and API key are configured."""
        return bool(self.endpoint_url and self.api_key)

    async def fetch_feed(self) -> tuple[gtfs_realtime_pb2.FeedMessage | dict[str, Any] | None, float]:
        """Fetches the latest GTFS-RT feed using secure GET and returns (feed_message_or_dict, latency_ms).

        Never logs the API key.
        """
        if not self.is_configured:
            self.last_error = "GTFS-RT API endpoint or key not configured in .env"
            return None, 0.0

        headers = {
            "Accept": "application/x-protobuf, application/octet-stream, application/json, */*",
            "User-Agent": "YATRA-Delhi-Transit-Platform/1.0",
        }

        # Add authenticating x-api-key header without logging header content
        # Note: Do not send Authorization: Bearer as DTS rejects it with 401 invalid token type
        if self.api_key:
            headers["x-api-key"] = self.api_key

        max_retries = 3
        backoff_seconds = 1.0

        for attempt in range(1, max_retries + 1):
            start_time = time.perf_counter()
            try:
                async with httpx.AsyncClient(
                    timeout=httpx.Timeout(self.timeout_seconds, connect=10.0),
                    follow_redirects=True,
                ) as client:
                    resp = await client.get(self.endpoint_url, headers=headers)
                    net_time = round((time.perf_counter() - start_time) * 1000, 2)
                    self.last_latency_ms = net_time
                    self.last_network_latency_ms = net_time
                    self.last_status_code = resp.status_code

                    if resp.status_code == 200:
                        content_type = resp.headers.get("content-type", "").lower()
                        self.last_error = None

                        # Check if response is JSON
                        if "json" in content_type or resp.content.startswith(b"{"):
                            try:
                                t_json_start = time.perf_counter()
                                json_data = resp.json()
                                self.last_decode_ms = round((time.perf_counter() - t_json_start) * 1000, 2)
                                return json_data, self.last_latency_ms
                            except Exception:
                                pass

                        # Parse standard Protocol Buffer
                        try:
                            t_pb_start = time.perf_counter()
                            feed = gtfs_realtime_pb2.FeedMessage()
                            feed.ParseFromString(resp.content)
                            self.last_decode_ms = round((time.perf_counter() - t_pb_start) * 1000, 2)
                            return feed, self.last_latency_ms
                        except Exception as pb_err:
                            # If protobuf parse fails, try JSON fallback
                            try:
                                t_json_start = time.perf_counter()
                                json_data = resp.json()
                                self.last_decode_ms = round((time.perf_counter() - t_json_start) * 1000, 2)
                                return json_data, self.last_latency_ms
                            except Exception:
                                self.last_error = f"Failed to parse response as Protobuf or JSON: {pb_err}"
                                return None, self.last_latency_ms

                    elif resp.status_code in (429, 502, 503, 504):
                        logger.warning(
                            f"Transient HTTP {resp.status_code} from GTFS-RT API. Retry {attempt}/{max_retries}"
                        )
                        await asyncio.sleep(backoff_seconds)
                        backoff_seconds *= 2
                    else:
                        self.last_error = f"HTTP {resp.status_code} error from GTFS-RT API"
                        return None, self.last_latency_ms

            except httpx.TimeoutException:
                self.last_error = f"Connection timed out after {self.timeout_seconds}s"
                logger.warning(f"GTFS-RT timeout on attempt {attempt}")
                await asyncio.sleep(backoff_seconds)
                backoff_seconds *= 2
            except httpx.RequestError as req_err:
                self.last_error = f"Network request error: {type(req_err).__name__}"
                logger.error(f"GTFS-RT request failure: {self.last_error}")
                break

        return None, self.last_latency_ms
