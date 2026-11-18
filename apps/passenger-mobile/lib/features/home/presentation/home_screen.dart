import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';
import '../../../core/widgets/asset_placeholder.dart';

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YatraColors.parchmentBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          children: [
            // Header Bar: Brand + City Selector + Notification Bell
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YATRA',
                      style: YatraTypography.displayHeadline(fontSize: 22),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: YatraColors.terracotta),
                        const SizedBox(width: 4),
                        Text(
                          'NEW DELHI · DTC NETWORK',
                          style: YatraTypography.labelCaps(
                            fontSize: 10,
                            color: YatraColors.inkSecondary,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none_outlined, color: YatraColors.inkPrimary),
                      tooltip: 'Notifications & Handshake Updates',
                      onPressed: () => context.push('/notifications'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.history, color: YatraColors.inkPrimary),
                      tooltip: 'Trip History',
                      onPressed: () => context.push('/history'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Personalized Greeting & Skyline Banner
            Container(
              decoration: BoxDecoration(
                color: YatraColors.surfaceCream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: YatraColors.softBorder, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Namaste, Traveler',
                          style: YatraTypography.sectionTitle(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Where would you like to travel comfortably today?',
                          style: YatraTypography.bodySans(fontSize: 13, color: YatraColors.inkSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: YatraAssetPlaceholder(
                      assetId: 'YATRA-ILL-003',
                      aspectRatio: 21 / 8,
                      semanticLabel: 'Delhi skyline silhouette featuring Qutub Minar, Metro, Red Fort domes, and Lotus Temple',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Search Bar
            GestureDetector(
              onTap: () => context.push('/planner'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: YatraColors.surfaceCream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: YatraColors.softBorder, width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: YatraColors.terracotta, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search accessible routes or stops...',
                        style: YatraTypography.bodySans(color: YatraColors.inkMuted),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: YatraColors.paleGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.accessible, size: 14, color: YatraColors.heritageGreen),
                          SizedBox(width: 4),
                          Text(
                            'Step-Free',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: YatraColors.heritageGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4 Distinct Action Grid: Plan Trip, Live Buses, Assistance, Accessible Stops
            Row(
              children: [
                Expanded(
                  child: _ActionTile(
                    icon: Icons.alt_route,
                    title: 'Plan Trip',
                    subtitle: 'Step-free routing',
                    badgeColor: YatraColors.terracotta,
                    onTap: () => context.push('/planner'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionTile(
                    icon: Icons.directions_bus,
                    title: 'Live Buses',
                    subtitle: 'Real-time GPS',
                    badgeColor: YatraColors.navyDeep,
                    onTap: () => context.push('/tracking'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionTile(
                    icon: Icons.sensors,
                    title: 'Assistance',
                    subtitle: 'Driver handshake',
                    badgeColor: YatraColors.accentOrange,
                    onTap: () => context.push('/assistance'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionTile(
                    icon: Icons.accessible_forward,
                    title: 'Accessible Stops',
                    subtitle: 'AccessGraph rated',
                    badgeColor: YatraColors.heritageGreen,
                    onTap: () => context.push('/stops'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Nearest Bus Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Approaching Low-Floor Bus',
                    style: YatraTypography.sectionTitle(fontSize: 18),
                  ),
                ),
                Text(
                  'Central Secretariat',
                  style: YatraTypography.labelCaps(
                    fontSize: 11,
                    color: YatraColors.inkSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Approaching Bus Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kashmere Gate ISBT',
                                style: YatraTypography.sectionTitle(fontSize: 16),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Via Connaught Place & Red Fort',
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
                              style: YatraTypography.metricSerif(fontSize: 22, color: YatraColors.terracotta),
                            ),
                            Text(
                              '600m away',
                              style: YatraTypography.bodySans(fontSize: 11, color: YatraColors.inkMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Bus Illustration Placeholder / Painter
                    const YatraAssetPlaceholder(
                      assetId: 'YATRA-ILL-002',
                      aspectRatio: 16 / 7,
                      semanticLabel: 'Modern DTC electric low-floor bus with deployed ramp',
                    ),
                    const SizedBox(height: 14),

                    // Accessibility & Crowding Chips
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _StatusPill(
                          label: 'RAMP EQUIPPED',
                          icon: Icons.check_circle,
                          bgColor: YatraColors.paleGreen,
                          textColor: YatraColors.heritageGreen,
                        ),
                        _StatusPill(
                          label: 'SEATED CAPACITY',
                          icon: Icons.people_outline,
                          bgColor: YatraColors.parchmentBg,
                          textColor: YatraColors.inkPrimary,
                        ),
                        TextButton(
                          onPressed: () => context.push('/assistance'),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Signal Driver', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color badgeColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: YatraColors.surfaceCream,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: YatraColors.softBorder, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: badgeColor, size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: YatraColors.inkPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: YatraColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color textColor;

  const _StatusPill({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
