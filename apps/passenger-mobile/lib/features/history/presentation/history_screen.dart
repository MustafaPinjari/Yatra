import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  final List<Map<String, dynamic>> _trips = const [
    {
      'date': 'Today, 8:45 AM',
      'route': '502',
      'from': 'AIIMS Interchange',
      'to': 'Central Secretariat',
      'duration': '18 min',
      'fare': '₹10',
      'rampUsed': true,
      'carbonKg': '1.4 kg CO2 saved',
    },
    {
      'date': 'Yesterday, 5:15 PM',
      'route': 'TMS(+)',
      'from': 'Kashmere Gate ISBT',
      'to': 'Connaught Place',
      'duration': '22 min',
      'fare': '₹15',
      'rampUsed': true,
      'carbonKg': '2.1 kg CO2 saved',
    },
    {
      'date': '15 Nov 2026',
      'route': '419',
      'from': 'Lajpat Nagar',
      'to': 'India Gate',
      'duration': '26 min',
      'fare': '₹15',
      'rampUsed': false,
      'carbonKg': '1.8 kg CO2 saved',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YatraColors.parchmentBg,
      appBar: AppBar(
        title: Text('Trip History', style: YatraTypography.sectionTitle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          children: [
            // Eco & Accessibility Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: YatraColors.surfaceCream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: YatraColors.softBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '5.3 kg',
                          style: YatraTypography.metricSerif(fontSize: 26, color: YatraColors.heritageGreen),
                        ),
                        Text(
                          'Carbon Saved This Week',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: YatraColors.inkSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 36, width: 1, color: YatraColors.softBorder),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '100%',
                          style: YatraTypography.metricSerif(fontSize: 26, color: YatraColors.terracotta),
                        ),
                        Text(
                          'Step-Free Boarding Rate',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: YatraColors.inkSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Text(
              'Past Journeys',
              style: YatraTypography.sectionTitle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            ..._trips.map((trip) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: YatraColors.navyDeep,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                trip['route'] as String,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              trip['date'] as String,
                              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: YatraColors.inkMuted),
                            ),
                            const Spacer(),
                            Text(
                              trip['fare'] as String,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: YatraColors.inkPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${trip['from']} → ${trip['to']}',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              'Duration: ${trip['duration']}',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: YatraColors.inkSecondary),
                            ),
                            const SizedBox(width: 12),
                            if (trip['rampUsed'] as bool)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: YatraColors.paleGreen,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'RAMP DEPLOYED',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: YatraColors.heritageGreen,
                                  ),
                                ),
                              ),
                            const Spacer(),
                            Text(
                              trip['carbonKg'] as String,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: YatraColors.heritageGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

