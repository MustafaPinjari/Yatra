import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/transit_stop.dart';
import '../models/journey_result.dart';

class JourneyPlannerService {
  final ApiClient _client;

  JourneyPlannerService([ApiClient? client]) : _client = client ?? ApiClient();

  /// Searches Delhi bus stops and metro stations with partial & prefix matching.
  Future<List<TransitStop>> searchStops(String query, {CancelToken? cancelToken}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/api/v1/stops',
        queryParameters: {
          'search': trimmed,
          'limit': 20,
        },
        cancelToken: cancelToken,
      );

      final data = response.data;
      if (data != null && data['success'] == true && data['data'] is List) {
        final list = data['data'] as List<dynamic>;
        return list.map((item) => TransitStop.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return [];
      }
      rethrow;
    }
  }

  /// Plans multimodal journey between origin and destination coordinates.
  Future<List<JourneyItinerary>> planJourney({
    required double originLat,
    required double originLon,
    required double destLat,
    required double destLon,
    double departureHour = 9.0,
    bool wheelchairAccessibleOnly = false,
    String objective = 'FASTEST', // FASTEST, LEAST_CROWDED, MOST_ACCESSIBLE
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/api/v1/analytics/journey/plan',
        data: {
          'origin_lat': originLat,
          'origin_lon': originLon,
          'destination_lat': destLat,
          'destination_lon': destLon,
          'departure_hour': departureHour,
          'wheelchair_accessible_only': wheelchairAccessibleOnly,
          'objective': objective,
          'max_walking_distance_meters': 1200.0,
        },
        cancelToken: cancelToken,
      );

      final data = response.data;
      if (data != null && data['itineraries'] is List) {
        final list = data['itineraries'] as List<dynamic>;
        return list.map((item) => JourneyItinerary.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
