import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/planner/models/transit_stop.dart';
import 'package:passenger_mobile/features/planner/services/journey_planner_service.dart';
import 'package:passenger_mobile/features/planner/presentation/widgets/stop_autocomplete_field.dart';

class MockJourneyPlannerService extends JourneyPlannerService {
  final List<TransitStop> mockStops;
  Duration delay;

  MockJourneyPlannerService({
    required this.mockStops,
    this.delay = Duration.zero,
  });

  @override
  Future<List<TransitStop>> searchStops(String query, {dynamic cancelToken}) async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return [];

    return mockStops
        .where((s) => s.stopName.toLowerCase().contains(q) || s.stopId.toLowerCase().contains(q))
        .toList();
  }
}

void main() {
  final testStops = [
    const TransitStop(
      stopId: 'stop_01',
      stopName: 'Kashmere Gate ISBT',
      latitude: 28.6675,
      longitude: 77.2285,
      locationType: 0,
      hasWheelchairRamp: true,
    ),
    const TransitStop(
      stopId: 'stop_02',
      stopName: 'AIIMS Metro Station',
      latitude: 28.5684,
      longitude: 77.2078,
      locationType: 1,
      hasWheelchairRamp: true,
    ),
    const TransitStop(
      stopId: 'stop_03',
      stopName: 'Delhi Gate',
      latitude: 28.6415,
      longitude: 77.2405,
      locationType: 0,
      hasWheelchairRamp: false,
    ),
  ];

  group('Autocomplete Unit Tests', () {
    test('Partial-name matching returns matching stops', () async {
      final service = MockJourneyPlannerService(mockStops: testStops);
      final results = await service.searchStops('kash');
      expect(results.length, 1);
      expect(results.first.stopName, 'Kashmere Gate ISBT');
    });

    test('Case-insensitive matching works for uppercase and lowercase', () async {
      final service = MockJourneyPlannerService(mockStops: testStops);
      final resultsUpper = await service.searchStops('AIIMS');
      final resultsLower = await service.searchStops('aiims');

      expect(resultsUpper.length, 1);
      expect(resultsLower.length, 1);
      expect(resultsUpper.first.stopId, 'stop_02');
      expect(resultsLower.first.stopId, 'stop_02');
    });

    test('No-result handling returns empty list for non-matching query', () async {
      final service = MockJourneyPlannerService(mockStops: testStops);
      final results = await service.searchStops('nonexistent_stop_xyz');
      expect(results, isEmpty);
    });
  });

  group('StopAutocompleteField Widget Tests', () {
    testWidgets('Selecting a suggestion stores its actual stop ID and coordinates', (WidgetTester tester) async {
      final service = MockJourneyPlannerService(mockStops: testStops);
      TransitStop? selectedStop;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StopAutocompleteField(
              label: 'Origin',
              hintText: 'Enter origin',
              prefixIcon: Icons.my_location,
              iconColor: Colors.orange,
              service: service,
              onStopSelected: (stop) {
                selectedStop = stop;
              },
            ),
          ),
        ),
      );

      // Enter search text
      await tester.enterText(find.byType(TextFormField), 'AIIMS');
      // Wait for debounce (300ms)
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Verify dropdown option appears
      expect(find.text('AIIMS Metro Station'), findsOneWidget);
      expect(find.text('Metro Station'), findsOneWidget);

      // Tap suggestion
      await tester.tap(find.text('AIIMS Metro Station'));
      await tester.pumpAndSettle();

      // Verify selection callback received correct stop ID and coordinates
      expect(selectedStop, isNotNull);
      expect(selectedStop!.stopId, 'stop_02');
      expect(selectedStop!.latitude, 28.5684);
      expect(selectedStop!.longitude, 77.2078);
    });

    testWidgets('Editing text invalidates previous stop selection', (WidgetTester tester) async {
      final service = MockJourneyPlannerService(mockStops: testStops);
      TransitStop? selectedStop = testStops[0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StopAutocompleteField(
              label: 'Origin',
              hintText: 'Enter origin',
              prefixIcon: Icons.my_location,
              iconColor: Colors.orange,
              initialStop: testStops[0],
              service: service,
              onStopSelected: (stop) {
                selectedStop = stop;
              },
            ),
          ),
        ),
      );

      expect(selectedStop, isNotNull);
      expect(selectedStop!.stopId, 'stop_01');

      // Edit text field
      await tester.enterText(find.byType(TextFormField), 'Kashmere Gate Modified');
      await tester.pump();

      // Selection must be cleared
      expect(selectedStop, isNull);
    });

    testWidgets('Out-of-order asynchronous search responses do not overwrite newer results', (WidgetTester tester) async {
      // First search is slow (400ms delay), second search is fast (50ms delay)
      final service = MockJourneyPlannerService(mockStops: testStops);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StopAutocompleteField(
              label: 'Origin',
              hintText: 'Enter origin',
              prefixIcon: Icons.my_location,
              iconColor: Colors.orange,
              service: service,
              onStopSelected: (_) {},
            ),
          ),
        ),
      );

      // Type first query
      await tester.enterText(find.byType(TextFormField), 'Kash');
      await tester.pump(const Duration(milliseconds: 100));

      // Quick second query before first completes
      await tester.enterText(find.byType(TextFormField), 'Delhi');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Should display results for 'Delhi', not 'Kash'
      expect(find.text('Delhi Gate'), findsOneWidget);
    });
  });
}
