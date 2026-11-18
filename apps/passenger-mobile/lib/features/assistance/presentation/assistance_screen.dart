import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';
import '../../../core/widgets/asset_placeholder.dart';

class AssistanceScreen extends StatefulWidget {
  const AssistanceScreen({super.key});

  @override
  State<AssistanceScreen> createState() => _AssistanceScreenState();
}

class _AssistanceScreenState extends State<AssistanceScreen> {
  int _selectedCategoryIndex = 0;
  bool _isRequestSent = false;
  bool _isDriverAcknowledged = false;

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Wheelchair Ramp',
      'description': 'Driver extends ramp & kneels bus upon stopping',
      'icon': Icons.accessible_forward,
      'code': 'WHEELCHAIR_RAMP',
    },
    {
      'title': 'Visual Guidance',
      'description': 'Conductor guides from tactile paving to seat',
      'icon': Icons.visibility,
      'code': 'VISUAL_GUIDANCE',
    },
    {
      'title': 'Hearing / Visual Notice',
      'description': 'High-contrast visual arrival flash & chime',
      'icon': Icons.hearing,
      'code': 'HEARING_ASSIST',
    },
    {
      'title': 'Extra Boarding Time',
      'description': 'Driver holds doors open for measured, safe boarding',
      'icon': Icons.timer,
      'code': 'EXTRA_TIME',
    },
  ];

  void _handleSendRequest() {
    setState(() {
      _isRequestSent = true;
    });

    // Simulate real-time driver acknowledgment via WebSocket after 1.5s
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isDriverAcknowledged = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YatraColors.parchmentBg,
      appBar: AppBar(
        title: Text('Boarding Assistance', style: YatraTypography.sectionTitle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          children: [
            // Narrative Hero Illustration (Boarding Empathy)
            const YatraAssetPlaceholder(
              assetId: 'YATRA-ILL-004',
              aspectRatio: 16 / 9,
              semanticLabel: 'Empathetic illustration showing a wheelchair commuter boarding a DTC bus via ramp with helpful conductor',
            ),
            const SizedBox(height: 16),

            // Section Headline & Explainer
            Text(
              'AccessHandshake Signaling',
              style: YatraTypography.displayHeadline(fontSize: 22),
            ),
            const SizedBox(height: 4),
            Text(
              'Signals the approaching bus crew 5 minutes prior to arrival so the ramp is deployed safely without boarding friction.',
              style: YatraTypography.bodySans(fontSize: 13, color: YatraColors.inkSecondary),
            ),
            const SizedBox(height: 16),

            // Stop & Target Bus Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: YatraColors.surfaceCream,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: YatraColors.softBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: YatraColors.navyDeep,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '502',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Central Secretariat (Bay 2)',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Approaching in 4 min · DL 1PD 8241',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: YatraColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Assistance Type Selector
            Text(
              'Select Required Assistance',
              style: YatraTypography.sectionTitle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            ...List.generate(_categories.length, (index) {
              final cat = _categories[index];
              final isSelected = _selectedCategoryIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Material(
                  color: isSelected ? YatraColors.paleGreen : YatraColors.surfaceCream,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: _isRequestSent ? null : () => setState(() => _selectedCategoryIndex = index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? YatraColors.heritageGreen : YatraColors.softBorder,
                          width: isSelected ? 1.8 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            cat['icon'] as IconData,
                            color: isSelected ? YatraColors.heritageGreen : YatraColors.navyDeep,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat['title'] as String,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? YatraColors.heritageGreen : YatraColors.inkPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  cat['description'] as String,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: YatraColors.inkSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: YatraColors.heritageGreen, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // Request Status / Action Button
            if (!_isRequestSent) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: YatraColors.terracotta,
                ),
                onPressed: _handleSendRequest,
                icon: const Icon(Icons.send),
                label: const Text('Send Boarding Handshake Request'),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isDriverAcknowledged ? YatraColors.paleGreen : YatraColors.paleAmber,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _isDriverAcknowledged ? YatraColors.heritageGreen : YatraColors.amberWarning,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isDriverAcknowledged ? Icons.check_circle : Icons.hourglass_top,
                          color: _isDriverAcknowledged ? YatraColors.heritageGreen : YatraColors.amberWarning,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _isDriverAcknowledged ? 'Driver Acknowledged · Ramp Ready' : 'Transmitting Signal to Bus Cab...',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _isDriverAcknowledged ? YatraColors.heritageGreen : YatraColors.inkPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isDriverAcknowledged
                          ? 'Driver Rajesh Kumar confirmed ramp deployment at Central Secretariat Bay 2. Conductor Sunita Verma notified.'
                          : 'Handshake notification queued on driver terminal. Please wait at the designated yellow boarding tile.',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: YatraColors.inkSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isRequestSent = false;
                    _isDriverAcknowledged = false;
                  });
                },
                child: const Text('Reset or Cancel Request'),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
