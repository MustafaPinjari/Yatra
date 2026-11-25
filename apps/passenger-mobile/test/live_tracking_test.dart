import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/tracking/models/live_vehicle.dart';
import 'package:passenger_mobile/features/tracking/services/live_tracking_service.dart';

class MockTrackingService extends LiveTrackingService {
  final List<LiveVehicle> Function(String? routeId) onGetVehicles;

  MockTrackingService(this.onGetVehicles);

  @override
  Future<List<LiveVehicle>> getLiveVehicles({String? routeId, dynamic cancelToken}) async {
    return onGetVehicles(routeId);
  }
}

void main() {
  group('Live Tracking Telemetry Models', () {
    test('Valid vehicle coordinates and fields are parsed accurately', () {
      final json = {
        'vehicle_id': 'DL 1PD 4421',
        'route_id': 'route_delhi_502',
        'route_short_name': '502',
        'latitude': 28.5684,
        'longitude': 77.2078,
        'bearing': 184.0,
        'speed_kmh': 26.5,
        'timestamp': 1774390000,
        'recorded_at_iso': '2026-11-25T10:30:00Z',
        'is_low_floor': true,
        'ramp_functional': true,
        'is_stale': false,
        'freshness_seconds': 20,
      };

      final vehicle = LiveVehicle.fromJson(json);

      expect(vehicle.vehicleId, 'DL 1PD 4421');
      expect(vehicle.latitude, 28.5684);
      expect(vehicle.longitude, 77.2078);
      expect(vehicle.bearing, 184.0);
      expect(vehicle.speedKmh, 26.5);
      expect(vehicle.isTelemetryFresh, isTrue);
      expect(vehicle.isStale, isFalse);
      expect(vehicle.formattedFreshness, '20s ago');
      expect(vehicle.isLowFloor, isTrue);
      expect(vehicle.rampFunctional, isTrue);
    });

    test('Stale telemetry flags vehicle as stale when freshness exceeds threshold', () {
      final json = {
        'vehicle_id': 'DL 1PD 8902',
        'route_id': 'route_delhi_502',
        'latitude': 28.5684,
        'longitude': 77.2078,
        'timestamp': 1774390000,
        'is_stale': true,
        'freshness_seconds': 360, // 6 minutes > 300s threshold
      };

      final vehicle = LiveVehicle.fromJson(json);

      expect(vehicle.isStale, isTrue);
      expect(vehicle.isTelemetryFresh, isFalse);
      expect(vehicle.formattedFreshness, '6m ago');
    });

    test('Missing coordinates gracefully fallback without throwing exception', () {
      final json = {
        'vehicle_id': 'DL 1PD 1111',
        'route_id': '502',
        'timestamp': 1774390000,
      };

      final vehicle = LiveVehicle.fromJson(json);

      expect(vehicle.vehicleId, 'DL 1PD 1111');
      expect(vehicle.latitude, inInclusiveRange(28.0, 29.0));
      expect(vehicle.longitude, inInclusiveRange(76.5, 77.8));
    });

    test('Freshness under 5 seconds formats as "just now"', () {
      final vehicle = LiveVehicle(
        vehicleId: 'DL 1PD 4421',
        routeId: '502',
        routeShortName: '502',
        latitude: 28.5684,
        longitude: 77.2078,
        timestamp: 1774390000,
        recordedAtIso: '2026-11-25T10:30:00Z',
        freshnessSeconds: 3,
      );

      expect(vehicle.formattedFreshness, 'just now');
    });
  });

  group('Live Tracking Service Tests', () {
    test('API failure propagates error to let UI display "Live tracking unavailable"', () async {
      final service = MockTrackingService((routeId) {
        throw Exception('GTFS-RT upstream endpoint unavailable');
      });

      expect(
        () => service.getLiveVehicles(routeId: '502'),
        throwsA(isA<Exception>()),
      );
    });

    test('Telemetry updates vehicle position strictly from received telemetry', () async {
      LiveVehicle currentVehicle = const LiveVehicle(
        vehicleId: 'DL 1PD 4421',
        routeId: '502',
        routeShortName: '502',
        latitude: 28.6675,
        longitude: 77.2285,
        timestamp: 1774390000,
        recordedAtIso: '2026-11-25T10:30:00Z',
      );

      final service = MockTrackingService((routeId) {
        return [
          const LiveVehicle(
            vehicleId: 'DL 1PD 4421',
            routeId: '502',
            routeShortName: '502',
            latitude: 28.6562,
            longitude: 77.2410,
            timestamp: 1774390030,
            recordedAtIso: '2026-11-25T10:30:30Z',
          ),
        ];
      });

      final updatedList = await service.getLiveVehicles(routeId: '502');
      expect(updatedList.isNotEmpty, isTrue);
      currentVehicle = updatedList.first;

      expect(currentVehicle.latitude, 28.6562);
      expect(currentVehicle.longitude, 77.2410);
    });
  });
}
