class JourneyLeg {
  final String mode; // WALK or BUS
  final String fromName;
  final String toName;
  final double fromLat;
  final double fromLon;
  final double toLat;
  final double toLon;
  final String? routeId;
  final String? routeShortName;
  final String departureTime;
  final String arrivalTime;
  final double durationMinutes;
  final double distanceKm;
  final double walkingMeters;
  final double relativeCrowdingIndex;
  final String crowdingLevel;
  final bool stepFreeAccessible;

  const JourneyLeg({
    required this.mode,
    required this.fromName,
    required this.toName,
    required this.fromLat,
    required this.fromLon,
    required this.toLat,
    required this.toLon,
    this.routeId,
    this.routeShortName,
    required this.departureTime,
    required this.arrivalTime,
    required this.durationMinutes,
    required this.distanceKm,
    this.walkingMeters = 0.0,
    this.relativeCrowdingIndex = 0.0,
    this.crowdingLevel = 'LOW',
    this.stepFreeAccessible = true,
  });

  factory JourneyLeg.fromJson(Map<String, dynamic> json) {
    return JourneyLeg(
      mode: json['mode']?.toString() ?? 'WALK',
      fromName: json['from_name']?.toString() ?? 'Origin',
      toName: json['to_name']?.toString() ?? 'Destination',
      fromLat: (json['from_lat'] as num?)?.toDouble() ?? 0.0,
      fromLon: (json['from_lon'] as num?)?.toDouble() ?? 0.0,
      toLat: (json['to_lat'] as num?)?.toDouble() ?? 0.0,
      toLon: (json['to_lon'] as num?)?.toDouble() ?? 0.0,
      routeId: json['route_id']?.toString(),
      routeShortName: json['route_short_name']?.toString(),
      departureTime: json['departure_time']?.toString() ?? '--:--',
      arrivalTime: json['arrival_time']?.toString() ?? '--:--',
      durationMinutes: (json['duration_minutes'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      walkingMeters: (json['walking_meters'] as num?)?.toDouble() ?? 0.0,
      relativeCrowdingIndex: (json['relative_crowding_index'] as num?)?.toDouble() ?? 0.0,
      crowdingLevel: json['crowding_level']?.toString() ?? 'LOW',
      stepFreeAccessible: json['step_free_accessible'] != false,
    );
  }
}

class JourneyItinerary {
  final String itineraryId;
  final String summary;
  final int transfers;
  final double totalDurationMinutes;
  final double inVehicleMinutes;
  final double walkingMinutes;
  final double waitingMinutes;
  final double totalWalkingDistanceMeters;
  final double relativeCrowdingIndex;
  final String crowdingLevel;
  final double accessibilityScore;
  final bool isStepFreeAccessible;
  final double rankScore;
  final List<JourneyLeg> legs;

  const JourneyItinerary({
    required this.itineraryId,
    required this.summary,
    required this.transfers,
    required this.totalDurationMinutes,
    required this.inVehicleMinutes,
    required this.walkingMinutes,
    required this.waitingMinutes,
    required this.totalWalkingDistanceMeters,
    required this.relativeCrowdingIndex,
    required this.crowdingLevel,
    required this.accessibilityScore,
    required this.isStepFreeAccessible,
    required this.rankScore,
    required this.legs,
  });

  /// Calculates official Delhi transit fare based on legs & distance
  int get estimatedFareInr {
    int fare = 0;
    for (final leg in legs) {
      if (leg.mode == 'BUS') {
        // DTC Low floor AC / Electric fare slabs
        final dist = leg.distanceKm;
        if (dist <= 4.0) {
          fare += 10;
        } else if (dist <= 8.0) {
          fare += 15;
        } else if (dist <= 12.0) {
          fare += 20;
        } else {
          fare += 25;
        }
      } else if (leg.mode == 'METRO') {
        // DMRC fare slab
        final dist = leg.distanceKm;
        if (dist <= 2.0) {
          fare += 10;
        } else if (dist <= 5.0) {
          fare += 20;
        } else if (dist <= 12.0) {
          fare += 30;
        } else if (dist <= 21.0) {
          fare += 40;
        } else if (dist <= 32.0) {
          fare += 50;
        } else {
          fare += 60;
        }
      }
    }
    return fare > 0 ? fare : 15; // default DTC bus fare
  }

  String get primaryRouteShortName {
    for (final leg in legs) {
      if (leg.routeShortName != null && leg.routeShortName!.isNotEmpty) {
        return leg.routeShortName!;
      }
      if (leg.routeId != null && leg.routeId!.isNotEmpty) {
        return leg.routeId!.replaceAll('route_delhi_', '').toUpperCase();
      }
    }
    return '502';
  }

  String get departureTime {
    if (legs.isNotEmpty) return legs.first.departureTime;
    return '--:--';
  }

  String get arrivalTime {
    if (legs.isNotEmpty) return legs.last.arrivalTime;
    return '--:--';
  }

  factory JourneyItinerary.fromJson(Map<String, dynamic> json) {
    final rawLegs = json['legs'] as List<dynamic>? ?? [];
    return JourneyItinerary(
      itineraryId: json['itinerary_id']?.toString() ?? '',
      summary: json['summary']?.toString() ?? 'Multimodal connection',
      transfers: (json['transfers'] as num?)?.toInt() ?? 0,
      totalDurationMinutes: (json['total_duration_minutes'] as num?)?.toDouble() ?? 0.0,
      inVehicleMinutes: (json['in_vehicle_minutes'] as num?)?.toDouble() ?? 0.0,
      walkingMinutes: (json['walking_minutes'] as num?)?.toDouble() ?? 0.0,
      waitingMinutes: (json['waiting_minutes'] as num?)?.toDouble() ?? 0.0,
      totalWalkingDistanceMeters: (json['total_walking_distance_meters'] as num?)?.toDouble() ?? 0.0,
      relativeCrowdingIndex: (json['relative_crowding_index'] as num?)?.toDouble() ?? 0.0,
      crowdingLevel: json['crowding_level']?.toString() ?? 'LOW',
      accessibilityScore: (json['accessibility_score'] as num?)?.toDouble() ?? 80.0,
      isStepFreeAccessible: json['is_step_free_accessible'] != false,
      rankScore: (json['rank_score'] as num?)?.toDouble() ?? 0.0,
      legs: rawLegs.map((e) => JourneyLeg.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
