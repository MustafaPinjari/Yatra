import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';
import '../../../core/theme/yatra_radii.dart';
import '../../../core/widgets/asset_placeholder.dart';
import '../../../core/widgets/yatra_wave_background.dart';

class AccessibleStopsScreen extends StatefulWidget {
  const AccessibleStopsScreen({super.key});

  @override
  State<AccessibleStopsScreen> createState() => _AccessibleStopsScreenState();
}

class _AccessibleStopsScreenState extends State<AccessibleStopsScreen> {
  bool _filterRamp = true;
  bool _filterTactile = false;
  bool _filterAudio = false;

  final List<Map<String, dynamic>> _stops = [
    {
      'name': 'Central Secretariat (ISBT Bay 1 & 2)',
      'distance': '180m away',
      'score': 96,
      'hasRamp': true,
      'hasTactile': true,
      'hasAudio': true,
      'curbHeight': '14 cm (Level Boarding)',
      'routes': ['502', 'TMS(+)', '419'],
      'txHash': '0x7a3...e91',
    },
    {
      'name': 'Kashmere Gate Metro Gate 4 Interchange',
      'distance': '1.2 km away',
      'score': 92,
      'hasRamp': true,
      'hasTactile': true,
      'hasAudio': true,
      'curbHeight': '15 cm (Step-Free)',
      'routes': ['108', '502', 'Airport Feeder'],
      'txHash': '0x4b1...8c2',
    },
    {
      'name': 'Connaught Place Super Bazar',
      'distance': '1.8 km away',
      'score': 84,
      'hasRamp': true,
      'hasTactile': false,
      'hasAudio': true,
      'curbHeight': '18 cm (Ramp Required)',
      'routes': ['419', '505', 'TMS(-)'],
      'txHash': '0x8d2...3f0',
    },
    {
      'name': 'AIIMS Metro & Safdarjung Gate 2',
      'distance': '2.6 km away',
      'score': 95,
      'hasRamp': true,
      'hasTactile': true,
      'hasAudio': true,
      'curbHeight': '14 cm (Level Boarding)',
      'routes': ['502', '522', '419'],
      'txHash': '0x1c9...7a4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YatraColors.parchmentBg,
      appBar: AppBar(
        title: Text('Accessible Stops', style: YatraTypography.sectionTitle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: YatraWaveBackground(
        variant: YatraWaveVariant.subtle,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            children: [
              // Explainer Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: YatraColors.surfaceCream,
                  borderRadius: BorderRadius.circular(YatraRadii.card),
                  border: Border.all(color: YatraColors.softBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x06101B3A),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: YatraColors.paleGreen,
                        borderRadius: BorderRadius.circular(YatraRadii.iconContainer),
                      ),
                      child: const Icon(Icons.verified_outlined, color: YatraColors.heritageGreen, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AccessGraph stop rating',
                            style: YatraTypography.sectionTitle(fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Stop ratings based on curb height, tactile paving, and audio announcements.',
                            style: YatraTypography.bodySans(fontSize: 11, color: YatraColors.inkSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Stop Inspection Spotlight Photo Card (`YATRA-ILL-008`)
              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(YatraRadii.featureCard),
                  border: Border.all(color: YatraColors.softBorder, width: 1.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08101B3A),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(YatraRadii.featureCard),
                  child: const YatraAssetPlaceholder(
                    assetId: 'YATRA-ILL-008',
                    aspectRatio: 16 / 9,
                    semanticLabel: 'Physical bus stop with tactile paving, ramp boarding curb, and digital arrival shelter',
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      selected: _filterRamp,
                      label: const Text('Ramp boarding'),
                      selectedColor: YatraColors.paleGreen,
                      checkmarkColor: YatraColors.heritageGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(YatraRadii.button)),
                      onSelected: (val) => setState(() => _filterRamp = val),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _filterTactile,
                      label: const Text('Tactile paving'),
                      selectedColor: YatraColors.paleAmber,
                      checkmarkColor: YatraColors.amberWarning,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(YatraRadii.button)),
                      onSelected: (val) => setState(() => _filterTactile = val),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _filterAudio,
                      label: const Text('Audio alerts'),
                      selectedColor: YatraColors.paleGreen,
                      checkmarkColor: YatraColors.heritageGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(YatraRadii.button)),
                      onSelected: (val) => setState(() => _filterAudio = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Stop Cards
              ..._stops.map((stop) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(YatraRadii.card),
                      side: const BorderSide(color: YatraColors.softBorder, width: 1.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stop['name'] as String,
                                      style: YatraTypography.sectionTitle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      stop['distance'] as String,
                                      style: YatraTypography.bodySans(fontSize: 12, color: YatraColors.inkMuted),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: (stop['score'] as int) >= 90 ? YatraColors.paleGreen : YatraColors.paleAmber,
                                  borderRadius: BorderRadius.circular(YatraRadii.sm),
                                  border: Border.all(
                                    color: (stop['score'] as int) >= 90 ? YatraColors.heritageGreen : YatraColors.amberWarning,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${stop['score']}',
                                      style: TextStyle(
                                        fontFamily: 'Playfair Display',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: (stop['score'] as int) >= 90 ? YatraColors.heritageGreen : YatraColors.amberWarning,
                                      ),
                                    ),
                                    Text(
                                      '/ 100',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: (stop['score'] as int) >= 90 ? YatraColors.heritageGreen : YatraColors.amberWarning,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Accessibility Feature Badges
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              if (stop['hasRamp'] as bool)
                                _FeatureBadge(label: 'Ramp accessible', icon: Icons.accessible, color: YatraColors.heritageGreen),
                              if (stop['hasTactile'] as bool)
                                _FeatureBadge(label: 'Tactile paving', icon: Icons.straighten, color: YatraColors.amberWarning),
                              if (stop['hasAudio'] as bool)
                                _FeatureBadge(label: 'Audio beacon', icon: Icons.volume_up, color: YatraColors.navyDeep),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Text(
                            'Curb: ${stop['curbHeight']}',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: YatraColors.inkSecondary),
                          ),
                          const Divider(height: 20),

                          // Routes Serving & Blockchain Hash
                          Row(
                            children: [
                              const Text(
                                'Routes: ',
                                style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              ...(stop['routes'] as List<String>).map((r) => Container(
                                    margin: const EdgeInsets.only(right: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: YatraColors.parchmentBg,
                                      borderRadius: BorderRadius.circular(YatraRadii.sm / 2),
                                    ),
                                    child: Text(
                                      r,
                                      style: const TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              const Spacer(),
                              Row(
                                children: [
                                  const Icon(Icons.link, size: 12, color: YatraColors.inkMuted),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Ledger ${stop['txHash']}',
                                    style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: YatraColors.inkMuted),
                                  ),
                                ],
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
      ),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _FeatureBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(YatraRadii.sm),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
