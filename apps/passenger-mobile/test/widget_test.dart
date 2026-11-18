import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/main.dart';

void main() {
  testWidgets('Passenger app smoke test renders YATRA', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: YatraPassengerApp(),
      ),
    );

    expect(find.text('YATRA'), findsOneWidget);
    expect(find.text('AccessHandshake'), findsOneWidget);
  });
}
