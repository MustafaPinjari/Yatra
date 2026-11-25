"""Measurement probe for live GTFS-RT feed: separate network, decoding, and processing timing."""
import asyncio
import os
import sys
import time
from pathlib import Path
from dotenv import load_dotenv
import httpx
from google.transit import gtfs_realtime_pb2

# Add services/api to sys.path for standalone script execution
api_dir = str(Path(__file__).resolve().parent.parent / "services" / "api")
if api_dir not in sys.path:
    sys.path.insert(0, api_dir)

# Delhi NCR Bounding Box & Staleness Threshold (aligned with app.integrations.gtfs_rt.processor)
DELHI_MIN_LAT = 28.0
DELHI_MAX_LAT = 29.2
DELHI_MIN_LON = 76.5
DELHI_MAX_LON = 77.8
STALE_THRESHOLD_SECONDS = 300

load_dotenv()
endpoint = os.getenv("DTS_GTFS_RT_API_ENDPOINT")
api_key = os.getenv("DTS_GTFS_RT_API_KEY")

async def probe():
    headers = {
        "x-api-key": api_key,
        "User-Agent": "YATRA-Delhi-Transit-Platform/1.0",
        "Accept": "application/x-protobuf, application/octet-stream, */*",
    }
    
    t0 = time.perf_counter()
    async with httpx.AsyncClient(timeout=15.0, follow_redirects=True) as client:
        resp = await client.get(endpoint, headers=headers)
    t1 = time.perf_counter()
    http_rtt_ms = round((t1 - t0) * 1000, 2)
    
    print(f"HTTP Status: {resp.status_code}")
    print(f"Content-Type: {resp.headers.get('content-type')}")
    print(f"Payload Size: {len(resp.content)} bytes")
    print(f"Snippet: {resp.content[:200]}")
    
    if resp.status_code != 200:
        print(f"Non-200 response: {resp.text}")
        return

    # Check if JSON
    if resp.content.startswith(b"{") or resp.content.startswith(b"["):
        print("Response appears to be JSON text rather than binary protobuf.")
        return

    t2 = time.perf_counter()
    try:
        feed = gtfs_realtime_pb2.FeedMessage()
        feed.ParseFromString(resp.content)
    except Exception as e:
        print(f"Protobuf Parse Error: {type(e).__name__}: {e}")
        return
    t3 = time.perf_counter()
    protobuf_decode_ms = round((t3 - t2) * 1000, 2)
    
    now = int(time.time())
    t4 = time.perf_counter()
    total_entities = len(feed.entity)
    has_vehicle = 0
    in_bounds = 0
    out_of_bounds = 0
    lats = []
    lons = []
    fresh_count = 0
    stale_count = 0
    no_timestamp_count = 0
    routes = set()
    
    for entity in feed.entity:
        if not entity.HasField("vehicle"):
            continue
        has_vehicle += 1
        v = entity.vehicle
        pos = v.position
        lat = float(pos.latitude)
        lon = float(pos.longitude)
        lats.append(lat)
        lons.append(lon)
        
        if DELHI_MIN_LAT <= lat <= DELHI_MAX_LAT and DELHI_MIN_LON <= lon <= DELHI_MAX_LON:
            in_bounds += 1
        else:
            out_of_bounds += 1
            
        if v.timestamp:
            freshness = now - int(v.timestamp)
            if freshness <= STALE_THRESHOLD_SECONDS:
                fresh_count += 1
            else:
                stale_count += 1
        else:
            no_timestamp_count += 1
            
        if v.HasField("trip") and v.trip.route_id:
            routes.add(v.trip.route_id)
            
    t5 = time.perf_counter()
    process_ms = round((t5 - t4) * 1000, 2)
    
    print("=== LIVE GTFS-RT TELEMETRY MEASUREMENTS ===")
    print(f"HTTP Status: {resp.status_code}")
    print(f"Content-Type: {resp.headers.get('content-type')}")
    print(f"Payload Size: {len(resp.content)} bytes ({round(len(resp.content)/1024, 1)} KB)")
    print(f"HTTP Round-Trip Time (Network Latency): {http_rtt_ms} ms")
    print(f"Protobuf ParseFromString Time (Binary Decoding): {protobuf_decode_ms} ms")
    print(f"Validation & Processing Time (Fleet Filtering): {process_ms} ms")
    print(f"Total Combined Ingestion Time: {round(http_rtt_ms + protobuf_decode_ms + process_ms, 2)} ms")
    print(f"Total Entities in Feed: {total_entities}")
    print(f"Entities with VehiclePosition: {has_vehicle}")
    print(f"Configured Bounding Box: [{DELHI_MIN_LAT}, {DELHI_MAX_LAT}] N, [{DELHI_MIN_LON}, {DELHI_MAX_LON}] E")
    print(f"In Bounds Vehicles: {in_bounds} ({round(in_bounds/has_vehicle*100, 2)}%)")
    print(f"Out of Bounds Vehicles: {out_of_bounds}")
    print(f"Observed Latitude Range: [{min(lats):.6f}, {max(lats):.6f}] N")
    print(f"Observed Longitude Range: [{min(lons):.6f}, {max(lons):.6f}] E")
    print(f"Stale Threshold: {STALE_THRESHOLD_SECONDS} seconds")
    print(f"Fresh Vehicles (<= {STALE_THRESHOLD_SECONDS}s): {fresh_count}")
    print(f"Stale Vehicles (> {STALE_THRESHOLD_SECONDS}s): {stale_count}")
    print(f"Vehicles Without Timestamp: {no_timestamp_count}")
    print(f"Verification Check: {fresh_count} + {stale_count} + {no_timestamp_count} = {fresh_count + stale_count + no_timestamp_count} == {has_vehicle}")
    print(f"Active Distinct Routes: {len(routes)}")

if __name__ == "__main__":
    asyncio.run(probe())
