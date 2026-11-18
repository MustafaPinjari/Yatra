import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:driver_mobile/main.dart';

void main() {
  testWidgets('Driver app smoke test renders Driver Assist console', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: YatraDriverApp(),
      ),
    );

    expect(find.textContaining('DRIVER ASSIST'), findsOneWidget);
    expect(find.textContaining('NEXT SCHEDULED STOP'), findsOneWidget);
  });
}
