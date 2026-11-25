import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/live_vehicle.dart';
import '../../planner/models/transit_stop.dart';

class LiveTrackingService {
  final ApiClient _client;

  LiveTrackingService([ApiClient? client]) : _client = client ?? ApiClient();

  /// Fetches live vehicle positions for a given route (e.g. "502").
  Future<List<LiveVehicle>> getLiveVehicles({String? routeId, CancelToken? cancelToken}) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/api/v1/realtime/vehicles',
        queryParameters: routeId != null ? {'route_id': routeId} : null,
        cancelToken: cancelToken,
      );

      final data = response.data;
      if (data != null && data['success'] == true && data['data'] is List) {
        final list = data['data'] as List<dynamic>;
        return list.map((item) => LiveVehicle.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches ordered stop sequence for a route.
  Future<List<TransitStop>> getRouteStops(String routeId, {CancelToken? cancelToken}) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/api/v1/routes/$routeId/stops',
        cancelToken: cancelToken,
      );

      final data = response.data;
      if (data != null && data['success'] == true && data['data'] is List) {
        final list = data['data'] as List<dynamic>;
        return list.map((item) => TransitStop.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Fetches corridor geometry points for a route.
  Future<List<Map<String, double>>> getRouteShape(String routeId, {CancelToken? cancelToken}) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/api/v1/routes/$routeId/shape',
        cancelToken: cancelToken,
      );

      final data = response.data;
      if (data != null && data['success'] == true && data['data'] is List) {
        final list = data['data'] as List<dynamic>;
        return list.map((item) {
          final m = item as Map<String, dynamic>;
          return {
            'lat': (m['shape_pt_lat'] as num).toDouble(),
            'lon': (m['shape_pt_lon'] as num).toDouble(),
          };
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Checks GTFS-RT feed health and freshness.
  Future<Map<String, dynamic>?> getFeedHealth({CancelToken? cancelToken}) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/api/v1/realtime/health',
        cancelToken: cancelToken,
      );
      final data = response.data;
      if (data != null && data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
