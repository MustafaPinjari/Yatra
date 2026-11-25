import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, dynamic>> _alerts = const [
    {
      'title': 'Handshake Acknowledged by Driver',
      'body': 'Bus 502 (DL 1PD 8241) driver Rajesh Kumar has received your ramp request for Central Secretariat Bay 2.',
      'time': '3 min ago',
      'icon': Icons.check_circle,
      'color': YatraColors.heritageGreen,
      'isNew': true,
    },
    {
      'title': 'Low-Floor Fleet Priority Alert',
      'body': 'Three low-floor electric buses scheduled on Route 502 within the next 15 minutes.',
      'time': '25 min ago',
      'icon': Icons.directions_bus,
      'color': YatraColors.navyDeep,
      'isNew': false,
    },
    {
      'title': 'AccessGraph Stop Maintenance',
      'body': 'Tactile paving upgrade completed at Patel Chowk Bus Bay. Level boarding verified.',
      'time': '2 hours ago',
      'icon': Icons.build_circle_outlined,
      'color': YatraColors.terracotta,
      'isNew': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YatraColors.parchmentBg,
      appBar: AppBar(
        title: Text('Notifications', style: YatraTypography.sectionTitle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          itemCount: _alerts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final alert = _alerts[index];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (alert['isNew'] as bool) ? YatraColors.surfaceCream : YatraColors.parchmentBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: (alert['isNew'] as bool) ? YatraColors.terracotta : YatraColors.softBorder,
                  width: (alert['isNew'] as bool) ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(alert['icon'] as IconData, color: alert['color'] as Color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                alert['title'] as String,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: YatraColors.inkPrimary,
                                ),
                              ),
                            ),
                            Text(
                              alert['time'] as String,
                              style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: YatraColors.inkMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alert['body'] as String,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: YatraColors.inkSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

