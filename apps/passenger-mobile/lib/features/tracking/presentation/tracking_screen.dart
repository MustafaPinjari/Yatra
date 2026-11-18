import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';
import '../../../core/widgets/yatra_painters.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YatraColors.parchmentBg,
      appBar: AppBar(
        title: Text('Route 502 Live Tracking', style: YatraTypography.sectionTitle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Telemetry',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Updated live telemetry from Delhi Transport Stack.')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Map Canvas View with Live Animated Bus Beacon
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: YatraColors.softBorder, width: 1.2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedBuilder(
                        animation: _animController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: RouteMapPainter(animationProgress: _animController.value),
                          );
                        },
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: YatraColors.inkPrimary.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.sensors, size: 12, color: YatraColors.heritageGreen),
                              SizedBox(width: 6),
                              Text(
                                'GPS FEED: 2 SEC AGO',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Live Bus Status & Stop Timeline Sheet
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: YatraColors.surfaceCream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 12,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Route & Next Stop Summary
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: YatraColors.navyDeep,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '502',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Central Secretariat (Bay 2)',
                                style: YatraTypography.sectionTitle(fontSize: 17),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'DL 1PD 8241 · Tata Starbus EV Low-Floor',
                                style: YatraTypography.bodySans(fontSize: 12, color: YatraColors.inkSecondary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '4 min',
                              style: YatraTypography.metricSerif(fontSize: 24, color: YatraColors.terracotta),
                            ),
                            Text(
                              'Approaching',
                              style: YatraTypography.labelCaps(fontSize: 10, color: YatraColors.heritageGreen),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Accessibility & Fleet Telemetry Cards
                    Row(
                      children: [
                        Expanded(
                          child: _TelemetryPill(
                            label: 'RAMP STATUS',
                            value: 'Operational',
                            icon: Icons.check_circle_outline,
                            color: YatraColors.heritageGreen,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _TelemetryPill(
                            label: 'KNEELING AIR SUSPENSION',
                            value: 'Active',
                            icon: Icons.airline_seat_legroom_extra,
                            color: YatraColors.navyDeep,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _TelemetryPill(
                            label: 'PASSENGER LOAD',
                            value: '42% (Seated)',
                            icon: Icons.people_outline,
                            color: YatraColors.amberWarning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Boarding Handshake CTA
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: YatraColors.terracotta,
                      ),
                      onPressed: () => context.push('/assistance'),
                      icon: const Icon(Icons.sensors),
                      label: const Text('Signal Approaching Driver (AccessHandshake)'),
                    ),
                    const SizedBox(height: 16),

                    // Stop Sequence Timeline
                    Text(
                      'Stop Sequence',
                      style: YatraTypography.sectionTitle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    _TimelineStop(
                      stopName: 'Udyog Bhawan',
                      isPast: true,
                      isCurrent: false,
                    ),
                    _TimelineStop(
                      stopName: 'Central Secretariat (You are here)',
                      isPast: false,
                      isCurrent: true,
                      eta: '4 min away',
                    ),
                    _TimelineStop(
                      stopName: 'Patel Chowk',
                      isPast: false,
                      isCurrent: false,
                      eta: '9 min away',
                    ),
                    _TimelineStop(
                      stopName: 'Kashmere Gate ISBT',
                      isPast: false,
                      isCurrent: false,
                      eta: '28 min away',
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

class _TelemetryPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _TelemetryPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: YatraColors.parchmentBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: YatraColors.softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                    color: YatraColors.inkMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStop extends StatelessWidget {
  final String stopName;
  final bool isPast;
  final bool isCurrent;
  final String? eta;

  const _TimelineStop({
    required this.stopName,
    required this.isPast,
    required this.isCurrent,
    this.eta,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isCurrent
                ? Icons.radio_button_checked
                : isPast
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
            size: 18,
            color: isCurrent
                ? YatraColors.terracotta
                : isPast
                    ? YatraColors.heritageGreen
                    : YatraColors.inkMuted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              stopName,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                color: isPast ? YatraColors.inkMuted : YatraColors.inkPrimary,
              ),
            ),
          ),
          if (eta != null)
            Text(
              eta!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCurrent ? YatraColors.terracotta : YatraColors.inkMuted,
              ),
            ),
        ],
      ),
    );
  }
}
