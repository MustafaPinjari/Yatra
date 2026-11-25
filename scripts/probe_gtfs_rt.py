"""Sanitized probe script for Delhi Transport Stack GTFS-RT endpoint."""
import asyncio
import os
import sys
from dotenv import load_dotenv
import httpx
from google.transit import gtfs_realtime_pb2

load_dotenv()
endpoint = os.getenv("DTS_GTFS_RT_API_ENDPOINT", "")
api_key = os.getenv("DTS_GTFS_RT_API_KEY", "")

async def main():
    sanitized_url = endpoint.split("?")[0] if endpoint else "NOT_CONFIGURED"
    print(f"Target endpoint: {sanitized_url}")
    print(f"API key configured: {bool(api_key)}")
    if api_key:
        print(f"API key format: length={len(api_key)}, prefix={api_key[:4]}..., suffix=...{api_key[-4:]}")
    else:
        print("STATUS: UNCONFIGURED - No API key present")
        return

    methods = [
        ("Header x-api-key", {"x-api-key": api_key}, {}),
        ("Header Authorization Bearer", {"Authorization": f"Bearer {api_key}"}, {}),
        ("Both headers (x-api-key + Bearer)", {"x-api-key": api_key, "Authorization": f"Bearer {api_key}"}, {}),
        ("Query parameter ?key=", {}, {"key": api_key}),
        ("Query parameter ?api_key=", {}, {"api_key": api_key}),
    ]

    for name, headers, params in methods:
        headers["User-Agent"] = "YATRA-Delhi-Transit-Platform/1.0"
        headers["Accept"] = "application/x-protobuf, application/octet-stream, application/json, */*"
        print(f"\n--- Testing Auth Method: {name} ---")
        try:
            async with httpx.AsyncClient(timeout=10.0, follow_redirects=True) as client:
                resp = await client.get(endpoint, headers=headers, params=params)
                print(f"HTTP Status: {resp.status_code}")
                content_type = resp.headers.get("content-type", "none")
                print(f"Content-Type: {content_type}")
                print(f"Content Length: {len(resp.content)} bytes")

                if resp.status_code == 200:
                    # Try protobuf
                    try:
                        feed = gtfs_realtime_pb2.FeedMessage()
                        feed.ParseFromString(resp.content)
                        print(f"Protobuf Parse: SUCCESS")
                        print(f"Header timestamp: {feed.header.timestamp}")
                        print(f"Total entities: {len(feed.entity)}")
                        if feed.entity:
                            sample = feed.entity[0]
                            print(f"Sample entity ID: {sample.id}")
                            if sample.HasField("vehicle"):
                                print(f"Vehicle: {sample.vehicle.vehicle.id}, Route: {sample.vehicle.trip.route_id}")
                                print(f"Position: ({sample.vehicle.position.latitude}, {sample.vehicle.position.longitude})")
                        print("\nRESULT: AUTHENTICATED_LIVE_SUCCESS")
                        return True
                    except Exception as pe:
                        print(f"Protobuf Parse Failed: {pe}")

                    # Try JSON
                    try:
                        data = resp.json()
                        print(f"JSON Parse: SUCCESS")
                        if isinstance(data, dict):
                            print(f"Keys: {list(data.keys())}")
                        elif isinstance(data, list):
                            print(f"Items: {len(data)}")
                        print("\nRESULT: AUTHENTICATED_LIVE_SUCCESS")
                        return True
                    except Exception as je:
                        print(f"JSON Parse Failed: {je}")
                else:
                    snippet = resp.text[:200].replace(api_key, "[REDACTED]") if api_key in resp.text else resp.text[:200]
                    print(f"Response Body Snippet: {snippet}")

        except httpx.ConnectError as ce:
            print(f"Connection Error: {ce}")
        except httpx.TimeoutException as te:
            print(f"Timeout Error: {te}")
        except Exception as e:
            print(f"Unexpected Exception: {type(e).__name__}: {e}")

    print("\nRESULT: LIVE_FEED_UNVERIFIED_OR_BLOCKED")
    return False

if __name__ == "__main__":
    asyncio.run(main())
