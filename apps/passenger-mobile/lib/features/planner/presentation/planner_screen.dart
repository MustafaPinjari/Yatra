import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';

class JourneyPlannerScreen extends StatefulWidget {
  const JourneyPlannerScreen({super.key});

  @override
  State<JourneyPlannerScreen> createState() => _JourneyPlannerScreenState();
}

class _JourneyPlannerScreenState extends State<JourneyPlannerScreen> {
  int _selectedModeIndex = 0;
  bool _stepFreeOnly = true;
  bool _rampRequired = true;
  bool _preferLowCrowding = false;

  final TextEditingEscort _originController = TextEditingEscort('Central Secretariat');
  final TextEditingEscort _destinationController = TextEditingEscort('Kashmere Gate ISBT');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YatraColors.parchmentBg,
      appBar: AppBar(
        title: Text('Journey Planner', style: YatraTypography.sectionTitle(fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          children: [
            // Mode Selectors: Bus, Metro, Multimodal
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: YatraColors.surfaceCream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: YatraColors.softBorder),
              ),
              child: Row(
                children: [
                  _buildModeButton(0, 'Bus Only', Icons.directions_bus),
                  _buildModeButton(1, 'Metro', Icons.train),
                  _buildModeButton(2, 'Multimodal', Icons.alt_route),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Origin & Destination Inputs with Swap Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: YatraColors.surfaceCream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: YatraColors.softBorder, width: 1.2),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.my_location, color: YatraColors.terracotta, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _originController.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: YatraColors.softBorder),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: YatraColors.heritageGreen, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _destinationController.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_vert, color: YatraColors.inkPrimary),
                        onPressed: () {
                          setState(() {
                            final temp = _originController.text;
                            _originController.text = _destinationController.text;
                            _destinationController.text = temp;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Accessibility Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    selected: _stepFreeOnly,
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.accessible, size: 14),
                        SizedBox(width: 4),
                        Text('100% Step-Free'),
                      ],
                    ),
                    selectedColor: YatraColors.paleGreen,
                    checkmarkColor: YatraColors.heritageGreen,
                    onSelected: (val) => setState(() => _stepFreeOnly = val),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    selected: _rampRequired,
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.ramp_right, size: 14),
                        SizedBox(width: 4),
                        Text('Ramp Required'),
                      ],
                    ),
                    selectedColor: YatraColors.paleGreen,
                    checkmarkColor: YatraColors.heritageGreen,
                    onSelected: (val) => setState(() => _rampRequired = val),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    selected: _preferLowCrowding,
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline, size: 14),
                        SizedBox(width: 4),
                        Text('Low Crowding'),
                      ],
                    ),
                    selectedColor: YatraColors.paleAmber,
                    checkmarkColor: YatraColors.amberWarning,
                    onSelected: (val) => setState(() => _preferLowCrowding = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Route Recommendations Section
            Text(
              'Recommended Accessible Routes',
              style: YatraTypography.sectionTitle(fontSize: 18),
            ),
            const SizedBox(height: 12),

            // Itinerary Card 1 (Direct Bus - Recommended)
            _ItineraryCard(
              routeNumber: '502',
              routeName: 'Direct Electric Low-Floor Bus',
              durationMinutes: 28,
              departureTime: '10:35 AM',
              arrivalTime: '11:03 AM',
              fareInr: 15,
              accessScore: 94,
              crowdingLabel: 'SEATED AVAILABLE',
              isRecommended: true,
              onSelect: () => context.push('/tracking'),
            ),
            const SizedBox(height: 14),

            // Itinerary Card 2 (Multimodal Metro + Feeder)
            _ItineraryCard(
              routeNumber: 'Y-LINE + 419',
              routeName: 'Yellow Line Metro to Kashmere Gate',
              durationMinutes: 22,
              departureTime: '10:38 AM',
              arrivalTime: '11:00 AM',
              fareInr: 30,
              accessScore: 88,
              crowdingLabel: 'MODERATE CROWD',
              isRecommended: false,
              onSelect: () => context.push('/tracking'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(int index, String label, IconData icon) {
    final isSelected = _selectedModeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedModeIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? YatraColors.navyDeep : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : YatraColors.inkSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : YatraColors.inkSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextEditingEscort {
  String text;
  TextEditingEscort(this.text);
}

class _ItineraryCard extends StatelessWidget {
  final String routeNumber;
  final String routeName;
  final int durationMinutes;
  final String departureTime;
  final String arrivalTime;
  final int fareInr;
  final int accessScore;
  final String crowdingLabel;
  final bool isRecommended;
  final VoidCallback onSelect;

  const _ItineraryCard({
    required this.routeNumber,
    required this.routeName,
    required this.durationMinutes,
    required this.departureTime,
    required this.arrivalTime,
    required this.fareInr,
    required this.accessScore,
    required this.crowdingLabel,
    required this.isRecommended,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isRecommended) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: YatraColors.paleGreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '★ RECOMMENDED STEP-FREE ROUTE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: YatraColors.heritageGreen,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹$fareInr',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: YatraColors.inkPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$durationMinutes',
                    style: YatraTypography.metricSerif(fontSize: 34, color: YatraColors.terracotta),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'min',
                    style: YatraTypography.sectionTitle(fontSize: 16, color: YatraColors.inkPrimary),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: YatraColors.navyDeep,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      routeNumber,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                routeName,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: YatraColors.inkSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Leaves $departureTime · Arrives $arrivalTime',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: YatraColors.inkMuted),
              ),
              const Divider(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: YatraColors.parchmentBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'AccessScore: $accessScore/100',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: YatraColors.heritageGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    crowdingLabel,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: YatraColors.inkSecondary,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward, size: 16, color: YatraColors.terracotta),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

