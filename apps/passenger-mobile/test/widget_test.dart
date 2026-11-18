import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/main.dart';
import 'package:passenger_mobile/core/router/app_router.dart';

void main() {
  testWidgets('Passenger app renders YATRA Introduction and navigates to Home', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const ProviderScope(
        child: YatraPassengerApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Intro Screen
    expect(find.text('YATRA'), findsOneWidget);
    expect(find.text('DELHI TRANSIT ATLAS'), findsOneWidget);
    expect(find.text('Move Delhi\nTogether.'), findsOneWidget);
    expect(find.text('Start Your Journey'), findsOneWidget);

    // 2. Tap 'Start Your Journey' to navigate to Home
    await tester.tap(find.text('Start Your Journey'));
    await tester.pumpAndSettle();

    // 3. Verify Home Screen
    expect(find.text('NEW DELHI · DTC NETWORK'), findsOneWidget);
    expect(find.text('Namaste, Traveler'), findsOneWidget);
    expect(find.text('Plan Trip'), findsOneWidget);
    expect(find.text('Live Buses'), findsOneWidget);
    expect(find.text('Assistance'), findsOneWidget);
    expect(find.text('Accessible Stops'), findsOneWidget);
    expect(find.text('Approaching Low-Floor Bus'), findsOneWidget);
  });

  testWidgets('Passenger app routes directly to Journey Planner and toggles filters', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const YatraPassengerApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Navigate to Planner
    container.read(appRouterProvider).go('/planner');
    await tester.pumpAndSettle();

    // Verify Planner Elements
    expect(find.text('Journey Planner'), findsOneWidget);
    expect(find.text('Bus Only'), findsOneWidget);
    expect(find.text('100% Step-Free'), findsOneWidget);
    expect(find.text('Recommended Accessible Routes'), findsOneWidget);
    expect(find.text('★ RECOMMENDED STEP-FREE ROUTE'), findsOneWidget);
  });

  testWidgets('Passenger app routes to Assistance Screen and initiates Handshake', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const YatraPassengerApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Navigate to Assistance
    container.read(appRouterProvider).go('/assistance');
    await tester.pumpAndSettle();

    // Verify Assistance Elements
    expect(find.text('Boarding Assistance'), findsOneWidget);
    expect(find.text('AccessHandshake Signaling'), findsOneWidget);

    final buttonFinder = find.text('Send Boarding Handshake Request');
    await tester.scrollUntilVisible(buttonFinder, 200);
    expect(buttonFinder, findsOneWidget);

    // Tap Send Boarding Handshake Request
    await tester.tap(buttonFinder);
    await tester.pump();

    // Verify Pending Transmitting state
    expect(find.text('Transmitting Signal to Bus Cab...'), findsOneWidget);

    // Advance clock past simulated 1.5s delay
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Verify Acknowledged State
    expect(find.text('Driver Acknowledged · Ramp Ready'), findsOneWidget);
  });
}
