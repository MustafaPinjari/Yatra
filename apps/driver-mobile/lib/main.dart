import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/yatra_colors.dart';
import 'core/theme/yatra_driver_theme.dart';
import 'core/theme/yatra_typography.dart';
import 'core/theme/yatra_radii.dart';

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
      title: 'Driver console | YATRA',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: ThemeMode.dark,
      darkTheme: YatraDriverTheme.cabTheme,
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
  bool _rampDeployed = false;
  bool _doorHeld = false;
  int _doorHoldRemainingSeconds = 0;
  Timer? _doorHoldTimer;
  int _currentStopIndex = 0;

  final List<Map<String, dynamic>> _stops = const [
    {
      'name': 'AIIMS Metro Station (Bay 04)',
      'distance': '350m ahead',
      'eta': '2 min',
      'ramp_available': true,
      'tactile_path': true,
      'transfers': 'Yellow Line · DTC 502/534',
    },
    {
      'name': 'Green Park Main Market',
      'distance': '1.4 km ahead',
      'eta': '6 min',
      'ramp_available': true,
      'tactile_path': false,
      'transfers': 'Yellow Line feeder',
    },
    {
      'name': 'Hauz Khas IIT Gate',
      'distance': '2.8 km ahead',
      'eta': '11 min',
      'ramp_available': true,
      'tactile_path': true,
      'transfers': 'Magenta Line · Yellow Line',
    },
    {
      'name': 'Adchini Crossing',
      'distance': '4.1 km ahead',
      'eta': '16 min',
      'ramp_available': false,
      'tactile_path': false,
      'transfers': 'DTC local feeder',
    },
    {
      'name': 'Qutub Minar Metro Gate',
      'distance': '5.7 km ahead',
      'eta': '21 min',
      'ramp_available': true,
      'tactile_path': true,
      'transfers': 'Yellow Line interchange',
    },
    {
      'name': 'Mehrauli Terminal (Bay 01)',
      'distance': '7.2 km ahead',
      'eta': '27 min',
      'ramp_available': true,
      'tactile_path': true,
      'transfers': 'Route terminus',
    },
  ];

  @override
  void dispose() {
    _doorHoldTimer?.cancel();
    super.dispose();
  }

  void _toggleAcknowledge() {
    setState(() {
      _acknowledged = !_acknowledged;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _acknowledged ? YatraColors.heritageGreen : YatraColors.terracotta,
        content: Text(
          _acknowledged
              ? 'Boarding request acknowledged · Passenger notified on phone'
              : 'Assistance request reset to pending',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleRamp() {
    setState(() {
      _rampDeployed = !_rampDeployed;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _rampDeployed ? YatraColors.heritageGreen : YatraColors.navyDeep,
        content: Text(
          _rampDeployed
              ? 'Hydraulic ramp extended · Kneel suspension engaged'
              : 'Hydraulic ramp safely stowed · Suspension raised',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _holdDoors() {
    _doorHoldTimer?.cancel();
    setState(() {
      _doorHeld = true;
      _doorHoldRemainingSeconds = 30;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: YatraColors.amberWarning,
        content: Text('Door hold active for 30 seconds'),
        duration: Duration(seconds: 2),
      ),
    );

    _doorHoldTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_doorHoldRemainingSeconds > 1) {
          _doorHoldRemainingSeconds--;
        } else {
          _doorHeld = false;
          _doorHoldRemainingSeconds = 0;
          timer.cancel();
        }
      });
    });
  }

  void _playChime() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: YatraColors.navyDeep,
        content: Text('Audio announcement: Step-free boarding in progress'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _advanceStop() {
    setState(() {
      _currentStopIndex = (_currentStopIndex + 1) % _stops.length;
      _acknowledged = false;
      _rampDeployed = false;
    });
  }

  void _showStopList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF101B3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Route 502 · Stop sequence',
                      style: YatraTypography.sectionTitle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: _stops.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Color(0xFF233554),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final s = _stops[index];
                      final isCurrent = index == _currentStopIndex;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isCurrent ? YatraColors.terracotta : const Color(0xFF141F36),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCurrent ? YatraColors.terracotta : const Color(0xFF233554),
                            ),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCurrent ? Colors.white : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        title: Text(
                          s['name'] as String,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                            color: isCurrent ? Colors.white : const Color(0xFFE2E8F0),
                          ),
                        ),
                        subtitle: Text(
                          '${s['distance']} · ${s['transfers']}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        trailing: s['ramp_available'] == true
                            ? const Icon(Icons.accessible_forward, size: 18, color: Color(0xFF34D399))
                            : const SizedBox.shrink(),
                        onTap: () {
                          setState(() {
                            _currentStopIndex = index;
                            _acknowledged = false;
                            _rampDeployed = false;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStop = _stops[_currentStopIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF101B3A),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: YatraColors.terracotta.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.directions_bus, color: YatraColors.terracotta, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Driver console',
                    style: YatraTypography.sectionTitle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Bus DL 1PD 4421 · Rajesh Kumar',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: YatraColors.heritageGreen.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: YatraColors.heritageGreen, width: 1),
            ),
            child: const Row(
              children: [
                Icon(Icons.wifi, size: 13, color: Color(0xFF34D399)),
                SizedBox(width: 5),
                Text(
                  'Route 502 · Active',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE2E8F0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Next Scheduled Stop & Operational Telemetry Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF141F36),
                  borderRadius: YatraRadii.radiusCard,
                  border: Border.all(color: const Color(0xFF233554), width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: YatraColors.terracotta,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Next stop · ${currentStop['distance']} (${currentStop['eta']})',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Color(0xFFCBD5E1), size: 22),
                          tooltip: 'Advance to next stop',
                          onPressed: _advanceStop,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentStop['name'] as String,
                      style: YatraTypography.displayHeadline(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Interchange: ${currentStop['transfers']}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Telemetry Row (Speed, Headway, Battery, Load)
                    Row(
                      children: const [
                        _TelemetryMini(label: 'Speed', value: '24 km/h'),
                        SizedBox(width: 8),
                        _TelemetryMini(label: 'Headway', value: '+1.2 min'),
                        SizedBox(width: 8),
                        _TelemetryMini(label: 'Battery', value: '78%'),
                        SizedBox(width: 8),
                        _TelemetryMini(label: 'Load', value: '42%'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // AccessHandshake Boarding Alert Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: _acknowledged ? const Color(0xFF093322) : const Color(0xFF2E150B),
                    borderRadius: YatraRadii.radiusCard,
                    border: Border.all(
                      color: _acknowledged ? YatraColors.heritageGreen : YatraColors.terracotta,
                      width: 1.8,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (_acknowledged ? YatraColors.heritageGreen : YatraColors.terracotta)
                              .withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _acknowledged ? Icons.check_circle_outline : Icons.accessible_forward,
                          size: 52,
                          color: _acknowledged ? const Color(0xFF34D399) : const Color(0xFFFBBF24),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _acknowledged
                            ? 'Boarding assistance confirmed'
                            : 'Wheelchair boarding requested',
                        textAlign: TextAlign.center,
                        style: YatraTypography.sectionTitle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _acknowledged
                            ? 'Suspension kneeling ready. Deploy hydraulic ramp at curb bay.'
                            : 'Passenger waiting at ${currentStop['name']} requires step-free boarding.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Color(0xFFCBD5E1),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Large touch target for driver safety
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _acknowledged ? YatraColors.heritageGreen : YatraColors.terracotta,
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: YatraRadii.radiusButton,
                            ),
                          ),
                          onPressed: _toggleAcknowledge,
                          child: Text(
                            _acknowledged ? 'Reset assistance state' : 'Acknowledge boarding request',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Operational Driver Controls Strip (Ramp, Door Hold, Chime, Stop List)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _rampDeployed
                            ? YatraColors.heritageGreen.withValues(alpha: 0.25)
                            : const Color(0xFF141F36),
                        side: BorderSide(
                          color: _rampDeployed ? const Color(0xFF34D399) : const Color(0xFF233554),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: const RoundedRectangleBorder(borderRadius: YatraRadii.radiusSm),
                      ),
                      onPressed: _toggleRamp,
                      icon: Icon(
                        _rampDeployed ? Icons.check : Icons.ramp_right,
                        size: 18,
                        color: _rampDeployed ? const Color(0xFF34D399) : Colors.white,
                      ),
                      label: Text(
                        _rampDeployed ? 'Ramp deployed' : 'Deploy ramp',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _rampDeployed ? const Color(0xFF34D399) : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _doorHeld
                            ? YatraColors.amberWarning.withValues(alpha: 0.25)
                            : const Color(0xFF141F36),
                        side: BorderSide(
                          color: _doorHeld ? const Color(0xFFFBBF24) : const Color(0xFF233554),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: const RoundedRectangleBorder(borderRadius: YatraRadii.radiusSm),
                      ),
                      onPressed: _holdDoors,
                      icon: Icon(
                        Icons.timer,
                        size: 18,
                        color: _doorHeld ? const Color(0xFFFBBF24) : Colors.white,
                      ),
                      label: Text(
                        _doorHeld ? 'Held (${_doorHoldRemainingSeconds}s)' : 'Hold doors',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _doorHeld ? const Color(0xFFFBBF24) : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Tooltip(
                    message: 'Play accessibility arrival chime',
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF141F36),
                        side: const BorderSide(color: Color(0xFF233554)),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        shape: const RoundedRectangleBorder(borderRadius: YatraRadii.radiusSm),
                      ),
                      onPressed: _playChime,
                      child: const Icon(Icons.volume_up, size: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Tooltip(
                    message: 'View route stop sequence',
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF141F36),
                        side: const BorderSide(color: Color(0xFF233554)),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        shape: const RoundedRectangleBorder(borderRadius: YatraRadii.radiusSm),
                      ),
                      onPressed: _showStopList,
                      child: const Icon(Icons.list_alt, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TelemetryMini extends StatelessWidget {
  final String label;
  final String value;

  const _TelemetryMini({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF0B132B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF233554), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontFeatures: [FontFeature.tabularFigures()],
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
