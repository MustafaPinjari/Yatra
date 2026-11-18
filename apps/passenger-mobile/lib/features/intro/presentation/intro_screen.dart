import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';
import '../../../core/theme/yatra_radii.dart';
import '../../../core/widgets/asset_placeholder.dart';
import '../../../core/widgets/yatra_wave_background.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YatraColors.parchmentBg,
      body: YatraWaveBackground(
        variant: YatraWaveVariant.hero,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Brand Masthead & Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(YatraRadii.iconContainer),
                          child: Image.asset(
                            'assets/brand/yatra-brand-symbol.png',
                            height: 38,
                            width: 38,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                color: YatraColors.navyDeep,
                                borderRadius: BorderRadius.circular(YatraRadii.iconContainer),
                              ),
                              child: const Icon(Icons.directions_bus, color: YatraColors.accentOrange, size: 22),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YATRA',
                              style: YatraTypography.displayHeadline(
                                fontSize: 24,
                                color: YatraColors.inkPrimary,
                              ),
                            ),
                            Text(
                              'DELHI TRANSIT ATLAS',
                              style: YatraTypography.labelCaps(
                                fontSize: 9,
                                color: YatraColors.heritageGreen,
                                letterSpacing: 1.8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: YatraColors.paleGreen,
                        borderRadius: BorderRadius.circular(YatraRadii.button),
                        border: Border.all(color: YatraColors.heritageGreen.withOpacity(0.35)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.accessible_forward, size: 14, color: YatraColors.heritageGreen),
                          const SizedBox(width: 4),
                          Text(
                            'ACCESSIBLE',
                            style: YatraTypography.labelCaps(fontSize: 10, color: YatraColors.heritageGreen),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Hero Visual: India Gate Monument with Rajpath & Low-floor bus
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(YatraRadii.hero),
                      border: Border.all(color: YatraColors.softBorder, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C101B3A),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(YatraRadii.hero),
                      child: const YatraAssetPlaceholder(
                        assetId: 'YATRA-ILL-001',
                        aspectRatio: 4 / 3,
                        semanticLabel: 'Architectural illustration of India Gate with a low-floor DTC bus traveling in the foreground',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Editorial Display Headline & Narrative
                Text(
                  'Move Delhi\nTogether.',
                  style: YatraTypography.displayHeadline(
                    fontSize: 32,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Accessible · Inclusive · Reliable',
                  style: YatraTypography.labelCaps(
                    fontSize: 11,
                    color: YatraColors.terracotta,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Every bus, every stop, every journey designed for effortless transit across the National Capital Territory.',
                  style: YatraTypography.bodySans(
                    fontSize: 13,
                    color: YatraColors.inkSecondary,
                  ),
                ),
                const Spacer(),

                // Primary Actions
                ElevatedButton(
                  onPressed: () => context.go('/home'),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Start Your Journey'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => context.push('/profile'),
                  child: const Text('Configure Accessibility Needs'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
