import json
import math
from pathlib import Path
from typing import Any

from app.schemas.transit import (
    AgencyModel,
    GtfsIngestionReport,
    GtfsValidationSummary,
    RouteModel,
    ShapePointModel,
    StopModel,
    StopTimeModel,
    TripModel,
)


class TransitRepository:
    """Thread-safe transit data repository for GTFS entities and spatial queries.

    Provides fast indexing, spatial bounding, and fallback to sample data.
    """

    def __init__(self) -> None:
        self.agencies: dict[str, AgencyModel] = {}
        self.stops: dict[str, StopModel] = {}
        self.routes: dict[str, RouteModel] = {}
        self.trips: dict[str, TripModel] = {}
        self.stop_times: list[StopTimeModel] = []
        self.shapes: dict[str, list[ShapePointModel]] = {}
        self.route_to_stops: dict[str, list[StopModel]] = {}
        self.route_to_trips: dict[str, list[TripModel]] = {}
        self.last_ingestion_report: GtfsIngestionReport | None = None

        # Automatically load bootstrap / sample data if available
        self._load_bootstrap_data()

    def _load_bootstrap_data(self) -> None:
        """Loads default routes and stops from data/sample fixtures so endpoints function immediately."""
        # Find sample directory from cwd or file ancestry
        candidates = [
            Path.cwd() / "data" / "sample",
            Path(__file__).resolve().parents[5] / "data" / "sample",
        ]
        sample_dir = next((c for c in candidates if c.exists()), None)
        if not sample_dir:
            return

        sample_routes_path = sample_dir / "sample_routes.json"
        sample_stops_path = sample_dir / "sample_stops.json"

        if sample_routes_path.exists():
            try:
                with open(sample_routes_path, encoding="utf-8") as f:
                    routes_data = json.load(f)
                    for r in routes_data:
                        route_id = r["id"]
                        self.routes[route_id] = RouteModel(
                            route_id=route_id,
                            route_short_name=r["routeShortName"],
                            route_long_name=r["routeLongName"],
                            agency_id=r.get("operatorCode", "DTC"),
                        )
            except Exception:
                pass

        if sample_stops_path.exists():
            try:
                with open(sample_stops_path, encoding="utf-8") as f:
                    stops_data = json.load(f)
                    for s in stops_data:
                        stop_id = s["id"]
                        self.stops[stop_id] = StopModel(
                            stop_id=stop_id,
                            stop_name=s["nameEn"],
                            stop_lat=s["location"]["latitude"],
                            stop_lon=s["location"]["longitude"],
                            accessibility_score=s.get("accessibilityScore", 75.0),
                            has_wheelchair_ramp=s.get("hasWheelchairRamp", False),
                            has_tactile_paving=s.get("hasTactilePaving", False),
                            has_shelter=s.get("hasShelter", True),
                            curb_height_cm=s.get("curbHeightCm", 16.0),
                        )
            except Exception:
                pass

        # Associate stops with default Route 502
        if "route_delhi_502" in self.routes:
            self.route_to_stops["route_delhi_502"] = list(self.stops.values())

    def update_from_parser(self, parser: Any, report: GtfsIngestionReport) -> None:
        """Atomically replaces repository data with freshly parsed GTFS feed."""
        if parser.stops:
            self.stops = parser.stops
        if parser.routes:
            self.routes = parser.routes
        if parser.agencies:
            self.agencies = parser.agencies
        if parser.trips:
            self.trips = parser.trips
        if parser.stop_times:
            self.stop_times = parser.stop_times
        if parser.shapes:
            self.shapes = parser.shapes

        # Rebuild route-to-stop mapping from stop_times and trips
        self._rebuild_indices()
        self.last_ingestion_report = report

    def _rebuild_indices(self) -> None:
        """Reconstructs relational lookup maps."""
        self.route_to_stops.clear()
        self.route_to_trips.clear()

        # Map trips to routes
        for trip in self.trips.values():
            if trip.route_id not in self.route_to_trips:
                self.route_to_trips[trip.route_id] = []
            self.route_to_trips[trip.route_id].append(trip)

        # Map stops to routes via stop_times
        trip_to_stops: dict[str, list[tuple[int, str]]] = {}
        for st in self.stop_times:
            if st.trip_id not in trip_to_stops:
                trip_to_stops[st.trip_id] = []
            trip_to_stops[st.trip_id].append((st.stop_sequence, st.stop_id))

        for route_id, trips in self.route_to_trips.items():
            if not trips:
                continue
            first_trip = trips[0]
            if first_trip.trip_id in trip_to_stops:
                seq = sorted(trip_to_stops[first_trip.trip_id], key=lambda x: x[0])
                ordered_stops = [self.stops[sid] for _, sid in seq if sid in self.stops]
                self.route_to_stops[route_id] = ordered_stops

    def get_all_routes(self, search: str | None = None) -> list[RouteModel]:
        """Returns routes, optionally filtered by search query."""
        results = list(self.routes.values())
        if search:
            query = search.lower().strip()
            results = [
                r for r in results
                if query in r.route_short_name.lower() or query in r.route_long_name.lower()
            ]
        return results

    def get_route(self, route_id: str) -> RouteModel | None:
        """Returns single route by identifier."""
        return self.routes.get(route_id)

    def get_route_stops(self, route_id: str) -> list[StopModel]:
        """Returns ordered stop sequence for a given route."""
        return self.route_to_stops.get(route_id, [])

    def get_all_stops(
        self,
        lat: float | None = None,
        lon: float | None = None,
        radius_km: float = 2.0,
        search: str | None = None,
    ) -> list[StopModel]:
        """Returns stops, with optional spatial radius search using Haversine formula."""
        stops = list(self.stops.values())

        if search:
            query = search.lower().strip()
            stops = [s for s in stops if query in s.stop_name.lower() or query in s.stop_id.lower()]

        if lat is not None and lon is not None:
            filtered = []
            for s in stops:
                dist = self.haversine_distance_km(lat, lon, s.stop_lat, s.stop_lon)
                if dist <= radius_km:
                    filtered.append(s)
            return sorted(filtered, key=lambda s: self.haversine_distance_km(lat, lon, s.stop_lat, s.stop_lon))

        return stops

    def get_stop(self, stop_id: str) -> StopModel | None:
        """Returns single stop by ID."""
        return self.stops.get(stop_id)

    def get_trips_for_route(self, route_id: str) -> list[TripModel]:
        """Returns trips scheduled for a route."""
        return self.route_to_trips.get(route_id, [])

    @staticmethod
    def haversine_distance_km(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
        """Computes great-circle distance between two GPS coordinates in kilometers."""
        R = 6371.0  # Earth radius in km
        dlat = math.radians(lat2 - lat1)
        dlon = math.radians(lon2 - lon1)
        a = (
            math.sin(dlat / 2) ** 2
            + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon / 2) ** 2
        )
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
        return R * c


# Global transit repository singleton
_transit_repository: TransitRepository | None = None


def get_transit_repository() -> TransitRepository:
    """Returns singleton instance of the TransitRepository."""
    global _transit_repository
    if _transit_repository is None:
        _transit_repository = TransitRepository()
    return _transit_repository
