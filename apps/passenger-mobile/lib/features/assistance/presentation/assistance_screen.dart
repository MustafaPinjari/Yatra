import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';
import '../../../core/theme/yatra_radii.dart';
import '../../../core/widgets/asset_placeholder.dart';
import '../../../core/widgets/yatra_wave_background.dart';

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
      'description': 'Driver extends low-floor ramp & kneels bus upon stopping',
      'icon': Icons.accessible_forward,
      'code': 'WHEELCHAIR_RAMP',
      'image': 'assets/images/wheelchair-ramp-card.png',
    },
    {
      'title': 'Visual Guidance',
      'description': 'Conductor guides from tactile paving to priority seat',
      'icon': Icons.visibility,
      'code': 'VISUAL_GUIDANCE',
      'image': 'assets/images/vision-support-card.png',
    },
    {
      'title': 'Hearing / Visual Notice',
      'description': 'High-contrast visual arrival beacon & cab chime',
      'icon': Icons.hearing,
      'code': 'HEARING_ASSIST',
      'image': 'assets/brand/yatra-brand-symbol.png',
    },
    {
      'title': 'Extra Boarding Time',
      'description': 'Driver holds doors open for measured, safe boarding',
      'icon': Icons.timer,
      'code': 'EXTRA_TIME',
      'image': 'assets/images/elderly-mobility-card.png',
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
      body: YatraWaveBackground(
        variant: YatraWaveVariant.subtle,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            children: [
              // Narrative Hero Illustration (Boarding Empathy)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(YatraRadii.hero),
                  border: Border.all(color: YatraColors.softBorder, width: 1.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A101B3A),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(YatraRadii.hero),
                  child: const YatraAssetPlaceholder(
                    assetId: 'YATRA-ILL-004',
                    aspectRatio: 16 / 9,
                    semanticLabel: 'Empathetic illustration showing a wheelchair commuter boarding a DTC bus via ramp with helpful conductor',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Section Headline & Explainer
              Text(
                'Boarding assistance handshake',
                style: YatraTypography.displayHeadline(fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                'Alerts the approaching crew five minutes before arrival so the ramp or space is prepared before the stop.',
                style: YatraTypography.bodySans(fontSize: 13, color: YatraColors.inkSecondary),
              ),
              const SizedBox(height: 16),

              // Stop & Target Bus Info Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: YatraColors.surfaceCream,
                  borderRadius: BorderRadius.circular(YatraRadii.card),
                  border: Border.all(color: YatraColors.softBorder, width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: YatraColors.navyDeep,
                        borderRadius: BorderRadius.circular(YatraRadii.sm),
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
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Material(
                    color: isSelected ? YatraColors.paleGreen : YatraColors.surfaceCream,
                    borderRadius: BorderRadius.circular(YatraRadii.card),
                    child: InkWell(
                      onTap: _isRequestSent ? null : () => setState(() => _selectedCategoryIndex = index),
                      borderRadius: BorderRadius.circular(YatraRadii.card),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(YatraRadii.card),
                          border: Border.all(
                            color: isSelected ? YatraColors.heritageGreen : YatraColors.softBorder,
                            width: isSelected ? 1.8 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Miniature visual asset thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(YatraRadii.iconContainer),
                              child: Image.asset(
                                cat['image'] as String,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: YatraColors.navyDeep.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(YatraRadii.iconContainer),
                                  ),
                                  child: Icon(
                                    cat['icon'] as IconData,
                                    color: isSelected ? YatraColors.heritageGreen : YatraColors.navyDeep,
                                    size: 22,
                                  ),
                                ),
                              ),
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
                              const Icon(Icons.check_circle, color: YatraColors.heritageGreen, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 18),

              // Request Status / Action Button
              if (!_isRequestSent) ...[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: YatraColors.terracotta,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(YatraRadii.button),
                    ),
                  ),
                  onPressed: _handleSendRequest,
                  icon: const Icon(Icons.send),
                  label: const Text('Send boarding assistance request'),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isDriverAcknowledged ? YatraColors.paleGreen : YatraColors.paleAmber,
                    borderRadius: BorderRadius.circular(YatraRadii.card),
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
                              _isDriverAcknowledged ? 'Driver Acknowledged · Ramp Ready' : 'Transmitting signal to driver console...',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _isDriverAcknowledged ? YatraColors.heritageGreen : YatraColors.amberWarning,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isDriverAcknowledged
                            ? 'Driver R. Kumar (ID: 8821) confirmed ramp deployment at Stop Bay 2.'
                            : 'Beacon packet broadcast via MQTT / WebSocket to Delhi Transit Dispatch.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: YatraColors.inkSecondary,
                        ),
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
                  child: const Text('Cancel request'),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
