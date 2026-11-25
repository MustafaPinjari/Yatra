class LiveVehicle {
  final String vehicleId;
  final String routeId;
  final String routeShortName;
  final String? tripId;
  final double latitude;
  final double longitude;
  final double bearing;
  final double speedKmh;
  final int timestamp; // epoch
  final String recordedAtIso;
  final String? stopId;
  final String currentStatus;
  final String? occupancyStatus;
  final bool isLowFloor;
  final bool rampFunctional;
  final bool isStale;
  final int freshnessSeconds;

  const LiveVehicle({
    required this.vehicleId,
    required this.routeId,
    required this.routeShortName,
    this.tripId,
    required this.latitude,
    required this.longitude,
    this.bearing = 0.0,
    this.speedKmh = 0.0,
    required this.timestamp,
    required this.recordedAtIso,
    this.stopId,
    this.currentStatus = 'IN_TRANSIT_TO',
    this.occupancyStatus,
    this.isLowFloor = true,
    this.rampFunctional = true,
    this.isStale = false,
    this.freshnessSeconds = 0,
  });

  bool get isTelemetryFresh => !isStale && freshnessSeconds <= 300;

  String get formattedFreshness {
    if (freshnessSeconds <= 5) return 'just now';
    if (freshnessSeconds < 60) return '${freshnessSeconds}s ago';
    final mins = freshnessSeconds ~/ 60;
    return '${mins}m ago';
  }

  String get occupancyDisplay {
    if (occupancyStatus == 'MANY_SEATS_AVAILABLE') return 'Seats available';
    if (occupancyStatus == 'FEW_SEATS_AVAILABLE') return 'Standing room only';
    if (occupancyStatus == 'FULL') return 'Full bus';
    return 'Moderate load';
  }

  factory LiveVehicle.fromJson(Map<String, dynamic> json) {
    return LiveVehicle(
      vehicleId: json['vehicle_id']?.toString() ?? json['vehicleId']?.toString() ?? 'DL-UNKNOWN',
      routeId: json['route_id']?.toString() ?? json['routeId']?.toString() ?? '502',
      routeShortName: json['route_short_name']?.toString() ?? json['routeShortName']?.toString() ?? '502',
      tripId: json['trip_id']?.toString() ?? json['tripId']?.toString(),
      latitude: (json['latitude'] as num?)?.toDouble() ??
          (json['coordinates'] is Map ? (json['coordinates']['latitude'] as num?)?.toDouble() : null) ??
          28.5684,
      longitude: (json['longitude'] as num?)?.toDouble() ??
          (json['coordinates'] is Map ? (json['coordinates']['longitude'] as num?)?.toDouble() : null) ??
          77.2078,
      bearing: (json['bearing'] as num?)?.toDouble() ?? 0.0,
      speedKmh: (json['speed_kmh'] as num?)?.toDouble() ?? (json['speedKmh'] as num?)?.toDouble() ?? 0.0,
      timestamp: (json['timestamp'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      recordedAtIso: json['recorded_at_iso']?.toString() ?? json['lastUpdated']?.toString() ?? DateTime.now().toIso8601String(),
      stopId: json['stop_id']?.toString(),
      currentStatus: json['current_status']?.toString() ?? 'IN_TRANSIT_TO',
      occupancyStatus: json['occupancy_status']?.toString() ?? json['crowdingTier']?.toString(),
      isLowFloor: json['is_low_floor'] != false && json['isLowFloor'] != false,
      rampFunctional: json['ramp_functional'] != false && json['hasOperationalRamp'] != false,
      isStale: json['is_stale'] == true || json['isStale'] == true,
      freshnessSeconds: (json['freshness_seconds'] as num?)?.toInt() ?? (json['freshnessSeconds'] as num?)?.toInt() ?? 0,
    );
  }
}
