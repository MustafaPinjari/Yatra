class TransitStop {
  final String stopId;
  final String stopName;
  final double latitude;
  final double longitude;
  final String? stopCode;
  final String? stopDesc;
  final int locationType; // 0 = Bus Stop, 1 = Metro Station
  final double accessibilityScore;
  final bool hasWheelchairRamp;
  final bool hasTactilePaving;
  final bool hasShelter;
  final double curbHeightCm;

  const TransitStop({
    required this.stopId,
    required this.stopName,
    required this.latitude,
    required this.longitude,
    this.stopCode,
    this.stopDesc,
    this.locationType = 0,
    this.accessibilityScore = 75.0,
    this.hasWheelchairRamp = false,
    this.hasTactilePaving = false,
    this.hasShelter = true,
    this.curbHeightCm = 16.0,
  });

  bool get isMetroStation => locationType == 1 || stopName.toLowerCase().contains('metro');

  String get typeLabel => isMetroStation ? 'Metro Station' : 'Bus Stop';

  factory TransitStop.fromJson(Map<String, dynamic> json) {
    return TransitStop(
      stopId: json['stop_id']?.toString() ?? '',
      stopName: json['stop_name']?.toString() ?? '',
      latitude: (json['stop_lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['stop_lon'] as num?)?.toDouble() ?? 0.0,
      stopCode: json['stop_code']?.toString(),
      stopDesc: json['stop_desc']?.toString(),
      locationType: (json['location_type'] as num?)?.toInt() ?? 0,
      accessibilityScore: (json['accessibility_score'] as num?)?.toDouble() ?? 75.0,
      hasWheelchairRamp: json['has_wheelchair_ramp'] == true,
      hasTactilePaving: json['has_tactile_paving'] == true,
      hasShelter: json['has_shelter'] != false,
      curbHeightCm: (json['curb_height_cm'] as num?)?.toDouble() ?? 16.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'stop_id': stopId,
    'stop_name': stopName,
    'stop_lat': latitude,
    'stop_lon': longitude,
    'stop_code': stopCode,
    'stop_desc': stopDesc,
    'location_type': locationType,
    'accessibility_score': accessibilityScore,
    'has_wheelchair_ramp': hasWheelchairRamp,
    'has_tactile_paving': hasTactilePaving,
    'has_shelter': hasShelter,
    'curb_height_cm': curbHeightCm,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransitStop && runtimeType == other.runtimeType && stopId == other.stopId;

  @override
  int get hashCode => stopId.hashCode;

  @override
  String toString() => '$stopName ($stopId)';
}
