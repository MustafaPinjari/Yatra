import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// GoRouter setup with semantic accessible navigation
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const PassengerHomeScreen(),
      ),
      GoRoute(
        path: '/handshake',
        builder: (context, state) => const HandshakeScreen(),
      ),
    ],
  );
});

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
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'YATRA Passenger',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Indigo brand
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          label: 'YATRA Accessible Transit Platform',
          child: const Row(
            children: [
              Icon(Icons.directions_bus, color: Color(0xFF4F46E5)),
              SizedBox(width: 8),
              Text(
                'YATRA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.accessibility_new),
            tooltip: 'Accessibility Settings',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Accessibility Mode Active: Screen-Reader & Ramp Filters enabled.'),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Accessible Banner
            Semantics(
              label: 'Welcome banner. Every Passenger, Every Bus, Every Journey.',
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Every Passenger. Every Bus. Every Journey.',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Plan wheelchair-accessible, low-crowding bus trips across Delhi.',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFF4338CA),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Handshake Action Card
            Semantics(
              button: true,
              label: 'Initiate Boarding Handshake with approaching bus driver',
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.sensors, color: Color(0xFF059669)),
                          SizedBox(width: 8),
                          Text(
                            'AccessHandshake',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Signal an approaching bus driver 5 minutes before arrival so they deploy the wheelchair ramp or provide extra boarding time.',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48), // WCAG touch target
                        ),
                        onPressed: () => context.go('/handshake'),
                        icon: const Icon(Icons.touch_app),
                        label: const Text(
                          'Request Boarding Assistance',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HandshakeScreen extends StatelessWidget {
  const HandshakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boarding Assistance Request'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 72,
                color: Color(0xFF059669),
              ),
              const SizedBox(height: 16),
              const Text(
                'Handshake Signaling Ready',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select route 502 or TMS(+) when at the bus stop to notify the approaching driver.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to Routes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
