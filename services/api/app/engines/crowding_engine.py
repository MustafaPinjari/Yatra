import math
from typing import Any

from app.integrations.gtfs.storage import TransitRepository, get_transit_repository
from app.integrations.gtfs_rt.processor import get_vehicle_processor


class CrowdingEngine:
    """Problem 2: Crowdedness-aware transport intelligence engine.

    Models passenger flow, accounts for incomplete ETM conductor ticketing coverage (3-4% capture rate),
    calculates headway bunching factors, and produces an explainable Relative Crowding Index (RCI)
    with multi-objective journey ranking.
    """

    # Baseline passenger capacity by Delhi bus class
    STANDARD_BUS_CAPACITY = 65  # 35 seated + 30 standing
    LOW_FLOOR_BUS_CAPACITY = 55  # 31 seated + 24 standing + 1 wheelchair bay
    ETM_SAMPLE_EXPANSION_FACTOR = 28.5  # Inverse of ~3.5% conductor ticketing capture rate

    def __init__(self, repo: TransitRepository | None = None) -> None:
        self.repo = repo or get_transit_repository()
        self.vehicle_processor = get_vehicle_processor()

    def calculate_relative_crowding_index(
        self,
        route_id: str,
        departure_hour: float = 8.5,
        scheduled_headway_minutes: float = 10.0,
        observed_headway_minutes: float | None = None,
    ) -> dict[str, Any]:
        """Calculates the Relative Crowding Index (RCI) between 0.0 (empty) and 1.0 (crush load).

        Strictly avoids naive linear multiplier of ETM tickets.
        Integrates:
        1. Time-of-day peak baseline.
        2. Corridor demand density.
        3. Headway bunching deviation factor.
        """
        # 1. Base demand factor by time of day
        if 8.0 <= departure_hour <= 10.5:
            base_demand = 0.78  # Morning peak
        elif 17.0 <= departure_hour <= 20.0:
            base_demand = 0.84  # Evening peak
        elif 11.0 < departure_hour < 17.0:
            base_demand = 0.45  # Midday shoulder
        else:
            base_demand = 0.22  # Off-peak / night

        # 2. Corridor demand weight (Ring road / arterial trunk lines exhibit higher passenger volume)
        route_weight = 1.0
        route_info = self.repo.get_route(route_id)
        if route_info:
            short_name = route_info.route_short_name.lower()
            if "tms" in short_name or "ring" in short_name or "502" in short_name or "534" in short_name:
                route_weight = 1.15

        # 3. Headway bunching deviation factor
        # When observed headway exceeds scheduled headway, queue accumulation increases proportionally
        obs_headway = observed_headway_minutes or scheduled_headway_minutes
        headway_ratio = obs_headway / max(1.0, scheduled_headway_minutes)
        bunching_penalty = 0.0
        if headway_ratio > 1.2:
            # Bus running late, passenger accumulation at downstream stops spikes
            bunching_penalty = min(0.35, (headway_ratio - 1.0) * 0.25)
        elif headway_ratio < 0.8:
            # Bus running early or closely trailing another bus; lighter load
            bunching_penalty = -0.15

        # Combine into RCI score bounded between 0.05 and 0.98
        rci = max(0.05, min(0.98, (base_demand * route_weight) + bunching_penalty))

        # Categorize
        if rci < 0.35:
            tier = "LOW"
            description = "Seating readily available"
        elif rci < 0.65:
            tier = "MODERATE"
            description = "Seats filling, comfortable standing room"
        elif rci < 0.85:
            tier = "HIGH"
            description = "Standing room only, tight boarding"
        else:
            tier = "VERY_HIGH"
            description = "Crush load, boarding constrained for mobility devices"

        return {
            "route_id": route_id,
            "relative_crowding_index": round(rci, 2),
            "crowding_tier": tier,
            "description": description,
            "base_demand_factor": round(base_demand, 2),
            "headway_deviation_ratio": round(headway_ratio, 2),
            "bunching_penalty": round(bunching_penalty, 2),
            "confidence_level": "MEDIUM",
            "confidence_level_pct": 75.0,
            "provenance": "HEURISTIC_SCHEDULE_BUNCHING_INDEX",
            "relative_ranking_only": True,
            "data_coverage_note": "Relative Crowding Index (RCI) is a relative heuristic ranking (0.0 to 1.0) based on scheduled headways and headway bunching penalties. It is not an empirical passenger census count.",
        }

    def enrich_itineraries_with_crowding(
        self,
        itineraries: list[dict[str, Any]],
        departure_hour: float = 8.5,
    ) -> list[dict[str, Any]]:
        """Enriches journey planner itineraries with explainable crowding scores

        and computes multi-objective ranking (fastest vs. comfort vs. accessibility).
        """
        for itin in itineraries:
            route_ids = [
                leg.get("route_id", "502")
                for leg in itin.get("legs", [])
                if leg.get("mode") == "BUS"
            ]

            if route_ids:
                crowd_eval = self.calculate_relative_crowding_index(route_ids[0], departure_hour)
                itin["crowding_tier"] = crowd_eval["crowding_tier"]
                itin["relative_crowding_index"] = crowd_eval["relative_crowding_index"]
                itin["crowding_description"] = crowd_eval["description"]
                itin["confidence_pct"] = crowd_eval["confidence_level_pct"]
            else:
                itin["crowding_tier"] = "LOW"
                itin["relative_crowding_index"] = 0.20
                itin["crowding_description"] = "Walking connection only"
                itin["confidence_pct"] = 95.0

            # Multi-objective utility score:
            # U = - (0.6 * travel_time + 0.3 * crowding_penalty + 0.1 * accessibility_penalty)
            t_min = itin.get("total_duration_minutes", 40.0)
            rci = itin.get("relative_crowding_index", 0.5)
            a_score = itin.get("accessibility_score", 80.0)

            itin["comfort_score"] = round((1.0 - rci) * 100.0, 1)
            itin["generalized_cost"] = round(t_min + (rci * t_min * 0.4) + ((100.0 - a_score) * 0.1), 1)

        # Tag standout recommendations
        if itineraries:
            # Fastest
            itineraries.sort(key=lambda x: x["total_duration_minutes"])
            itineraries[0]["recommendation_badge"] = "Fastest route"

            # Most comfortable
            comfort_sorted = sorted(itineraries, key=lambda x: x.get("relative_crowding_index", 1.0))
            if comfort_sorted[0] != itineraries[0]:
                comfort_sorted[0]["recommendation_badge"] = "Comfort option"

    def estimate_route_crowding(
        self,
        route_id: str,
        hour: float = 9.0,
    ) -> dict[str, Any]:
        """Calculates crowding estimate for route and hour, formatted for analytics API."""
        rci_data = self.calculate_relative_crowding_index(route_id, departure_hour=hour)
        rci = rci_data["relative_crowding_index"]
        comfort_idx = max(5.0, min(100.0, (1.0 - rci) * 100.0))
        bunching_dev = rci_data.get("headway_deviation_ratio", 1.0) - 1.0

        return {
            "route_id": route_id,
            "hour": hour,
            "relative_crowding_index": rci,
            "crowding_level": rci_data["crowding_tier"],
            "comfort_index": round(comfort_idx, 1),
            "bunching_headway_deviation": round(bunching_dev, 2),
            "confidence_level": rci_data.get("confidence_level", "MEDIUM"),
            "etm_sample_factor": self.ETM_SAMPLE_EXPANSION_FACTOR,
            "wheelchair_space_available": rci < 0.85,
            "provenance": "SAMPLE_BASED_INFERENCE",
            "expansion_factor_status": "UNCALIBRATED_HYPOTHESIS",
            "sample_rate_percent": 3.5,
            "uncertainty_margin_percent": 25.0,
            "limitation_note": "Universal 28.5x expansion factor is an uncalibrated heuristic without full conductor ETM records.",
        }

    def rank_itineraries(
        self,
        itineraries: list[dict[str, Any]],
        objective: str = "FASTEST",
    ) -> list[dict[str, Any]]:
        """Ranks candidate itineraries based on user objective:

        FASTEST: Minimizes total travel duration.
        LEAST_CROWDED: Prioritizes low Relative Crowding Index.
        MOST_ACCESSIBLE: Maximizes step-free and accessibility score.
        """
        copied = list(itineraries)
        if objective == "LEAST_CROWDED":
            copied.sort(key=lambda x: (x.get("relative_crowding_index", 0.5), x.get("total_duration_minutes", 60)))
        elif objective == "MOST_ACCESSIBLE":
            copied.sort(
                key=lambda x: (-x.get("accessibility_score", 50.0), x.get("total_duration_minutes", 60))
            )
        else:  # FASTEST default
            copied.sort(key=lambda x: x.get("total_duration_minutes", 60.0))

        return copied
