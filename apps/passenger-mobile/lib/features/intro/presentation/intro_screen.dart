import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';
import '../../../core/widgets/asset_placeholder.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YatraColors.parchmentBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Brand Wordmark & Tagline
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YATRA',
                          style: YatraTypography.displayHeadline(
                            fontSize: 24,
                            color: YatraColors.inkPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'DELHI TRANSIT ATLAS',
                          style: YatraTypography.labelCaps(
                            fontSize: 10,
                            color: YatraColors.heritageGreen,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: YatraColors.paleGreen,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: YatraColors.heritageGreen.withOpacity(0.3)),
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
              const SizedBox(height: 20),

              // Hero Visual: India Gate Monument with Rajpath & Low-floor bus
              const Expanded(
                flex: 5,
                child: YatraAssetPlaceholder(
                  assetId: 'YATRA-ILL-001',
                  aspectRatio: 4 / 3,
                  semanticLabel: 'Architectural illustration of India Gate with a low-floor DTC bus traveling in the foreground',
                ),
              ),
              const SizedBox(height: 24),

              // Editorial Display Headline & Narrative
              Text(
                'Move Delhi\nTogether.',
                style: YatraTypography.displayHeadline(
                  fontSize: 34,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Accessible · Inclusive · Reliable',
                style: YatraTypography.labelCaps(
                  fontSize: 12,
                  color: YatraColors.terracotta,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Every bus, every stop, every journey designed for effortless transit across the National Capital Territory.',
                style: YatraTypography.bodySans(
                  fontSize: 14,
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
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.push('/profile'),
                child: const Text('Configure Accessibility Needs'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
