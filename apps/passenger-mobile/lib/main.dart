import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/yatra_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: YatraPassengerApp(),
    ),
  );
}

class YatraPassengerApp extends ConsumerWidget {
  const YatraPassengerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'YATRA Passenger',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: YatraTheme.lightTheme,
    );
  }
}
