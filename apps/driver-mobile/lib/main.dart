import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final driverRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DriverConsoleScreen(),
      ),
    ],
  );
});

void main() {
  runApp(
    const ProviderScope(
      child: YatraDriverApp(),
    ),
  );
}

class YatraDriverApp extends ConsumerWidget {
  const YatraDriverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(driverRouterProvider);

    return MaterialApp.router(
      title: 'DriverAssist | YATRA',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      // Default to dark high-contrast mode for glare reduction and in-cab night vision
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E293B),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
    );
  }
}

class DriverConsoleScreen extends StatefulWidget {
  const DriverConsoleScreen({super.key});

  @override
  State<DriverConsoleScreen> createState() => _DriverConsoleScreenState();
}

class _DriverConsoleScreenState extends State<DriverConsoleScreen> {
  bool _acknowledged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.directions_bus_filled, color: Color(0xFF10B981)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'DRIVER ASSIST — BUS DL 1PD 4421',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF065F46),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.wifi, size: 16, color: Color(0xFF34D399)),
                SizedBox(width: 6),
                Text(
                  'ROUTE 502 ACTIVE',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current / Next Stop Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NEXT SCHEDULED STOP (350m ahead)',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'AIIMS Metro Station (Stop 04)',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Incoming Handshake Alert Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _acknowledged ? const Color(0xFF064E3B) : const Color(0xFF7F1D1D),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _acknowledged ? const Color(0xFF059669) : const Color(0xFFDC2626),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _acknowledged ? Icons.check_circle : Icons.accessible_forward,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _acknowledged ? 'BOARDING ASSISTANCE CONFIRMED' : 'WHEELCHAIR BOARDING REQUESTED',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _acknowledged
                        ? 'Stop smoothly at curb bay. Deploy hydraulic ramp.'
                        : 'Passenger waiting at AIIMS Stop 04 requires ramp deployment.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 32),

                    // Massive touch target for high-stress driver operation
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _acknowledged ? const Color(0xFF10B981) : Colors.white,
                        foregroundColor: _acknowledged ? Colors.white : const Color(0xFF991B1B),
                        minimumSize: const Size.fromHeight(64), // Extra large target
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _acknowledged = !_acknowledged;
                        });
                      },
                      child: Text(
                        _acknowledged ? 'ACKNOWLEDGED — TAP TO RESET' : 'TAP TO ACKNOWLEDGE ASSISTANCE',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
