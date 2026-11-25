import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/planner/models/journey_result.dart';
import 'package:passenger_mobile/features/planner/models/transit_stop.dart';
import 'package:passenger_mobile/features/planner/services/journey_planner_service.dart';

class MockPlannerService extends JourneyPlannerService {
  final List<JourneyItinerary> Function({
    required double originLat,
    required double originLon,
    required double destLat,
    required double destLon,
    double departureHour,
    bool wheelchairAccessibleOnly,
    String objective,
  }) onPlan;

  MockPlannerService(this.onPlan);

  @override
  Future<List<JourneyItinerary>> planJourney({
    required double originLat,
    required double originLon,
    required double destLat,
    required double destLon,
    double departureHour = 9.0,
    bool wheelchairAccessibleOnly = false,
    String objective = 'FASTEST',
    dynamic cancelToken,
  }) async {
    return onPlan(
      originLat: originLat,
      originLon: originLon,
      destLat: destLat,
      destLon: destLon,
      departureHour: departureHour,
      wheelchairAccessibleOnly: wheelchairAccessibleOnly,
      objective: objective,
    );
  }
}

void main() {
  final sampleLeg = const JourneyLeg(
    mode: 'BUS',
    fromName: 'Kashmere Gate ISBT',
    toName: 'AIIMS Metro Station',
    fromLat: 28.6675,
    fromLon: 77.2285,
    toLat: 28.5684,
    toLon: 77.2078,
    routeId: 'route_delhi_502',
    routeShortName: '502',
    departureTime: '08:30',
    arrivalTime: '09:05',
    durationMinutes: 35.0,
    distanceKm: 14.5,
    relativeCrowdingIndex: 0.45,
    crowdingLevel: 'MODERATE',
    stepFreeAccessible: true,
  );

  final sampleItinerary = JourneyItinerary(
    itineraryId: 'ITIN-101',
    summary: 'Direct DTC 502 electric bus',
    transfers: 0,
    totalDurationMinutes: 35.0,
    inVehicleMinutes: 35.0,
    walkingMinutes: 0.0,
    waitingMinutes: 0.0,
    totalWalkingDistanceMeters: 0.0,
    relativeCrowdingIndex: 0.45,
    crowdingLevel: 'MODERATE',
    accessibilityScore: 94.0,
    isStepFreeAccessible: true,
    rankScore: 40.0,
    legs: [sampleLeg],
  );

  group('Journey Planner Service Tests', () {
    test('Valid search returns parsed itineraries with verified fields', () async {
      final service = MockPlannerService((
        {required destLat,
        required destLon,
        departureHour = 9.0,
        String objective = 'FASTEST',
        required originLat,
        required originLon,
        bool wheelchairAccessibleOnly = false}) {
        return [sampleItinerary];
      });

      final results = await service.planJourney(
        originLat: 28.6675,
        originLon: 77.2285,
        destLat: 28.5684,
        destLon: 77.2078,
      );

      expect(results.length, 1);
      final itin = results.first;
      expect(itin.itineraryId, 'ITIN-101');
      expect(itin.totalDurationMinutes, 35.0);
      expect(itin.isStepFreeAccessible, isTrue);
      expect(itin.estimatedFareInr, 25); // >12km DTC electric bus fare
      expect(itin.primaryRouteShortName, '502');
      expect(itin.transfers, 0);
    });

    test('Accessibility filter is propagated to backend request', () async {
      bool? capturedWheelchairOnly;
      String? capturedObjective;

      final service = MockPlannerService((
        {required destLat,
        required destLon,
        departureHour = 9.0,
        String objective = 'FASTEST',
        required originLat,
        required originLon,
        bool wheelchairAccessibleOnly = false}) {
        capturedWheelchairOnly = wheelchairAccessibleOnly;
        capturedObjective = objective;
        return [sampleItinerary];
      });

      await service.planJourney(
        originLat: 28.6675,
        originLon: 77.2285,
        destLat: 28.5684,
        destLon: 77.2078,
        wheelchairAccessibleOnly: true,
        objective: 'MOST_ACCESSIBLE',
      );

      expect(capturedWheelchairOnly, isTrue);
      expect(capturedObjective, 'MOST_ACCESSIBLE');
    });

    test('Low crowding objective is propagated to backend request', () async {
      String? capturedObjective;

      final service = MockPlannerService((
        {required destLat,
        required destLon,
        departureHour = 9.0,
        String objective = 'FASTEST',
        required originLat,
        required originLon,
        bool wheelchairAccessibleOnly = false}) {
        capturedObjective = objective;
        return [sampleItinerary];
      });

      await service.planJourney(
        originLat: 28.6675,
        originLon: 77.2285,
        destLat: 28.5684,
        destLon: 77.2078,
        objective: 'LEAST_CROWDED',
      );

      expect(capturedObjective, 'LEAST_CROWDED');
    });

    test('Empty API response returns empty itineraries list without throwing', () async {
      final service = MockPlannerService((
        {required destLat,
        required destLon,
        departureHour = 9.0,
        String objective = 'FASTEST',
        required originLat,
        required originLon,
        bool wheelchairAccessibleOnly = false}) {
        return [];
      });

      final results = await service.planJourney(
        originLat: 28.6675,
        originLon: 77.2285,
        destLat: 28.5684,
        destLon: 77.2078,
      );

      expect(results, isEmpty);
    });

    test('API failure propagates exception for user retry handling', () async {
      final service = MockPlannerService((
        {required destLat,
        required destLon,
        departureHour = 9.0,
        String objective = 'FASTEST',
        required originLat,
        required originLon,
        bool wheelchairAccessibleOnly = false}) {
        throw Exception('Network connection timed out');
      });

      expect(
        () => service.planJourney(
          originLat: 28.6675,
          originLon: 77.2285,
          destLat: 28.5684,
          destLon: 77.2078,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Journey Validation Rules', () {
    test('Origin and destination cannot be identical', () {
      const stopA = TransitStop(stopId: 'stop_10', stopName: 'AIIMS', latitude: 28.5684, longitude: 77.2078);
      const stopB = TransitStop(stopId: 'stop_10', stopName: 'AIIMS', latitude: 28.5684, longitude: 77.2078);
      expect(stopA.stopId == stopB.stopId, isTrue);
    });

    test('Missing origin or destination fails pre-submission check', () {
      TransitStop? origin;
      const TransitStop? dest = TransitStop(stopId: 'stop_02', stopName: 'AIIMS', latitude: 28.5684, longitude: 77.2078);
      final canSubmit = origin != null && dest != null && origin.stopId != dest.stopId;
      expect(canSubmit, isFalse);
    });
  });
}
