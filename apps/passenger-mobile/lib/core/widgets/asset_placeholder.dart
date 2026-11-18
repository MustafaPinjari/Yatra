import 'package:flutter/material.dart';
import '../theme/yatra_colors.dart';
import '../theme/yatra_radii.dart';
import 'yatra_painters.dart';

/// Asset Inventory mapping directly to `docs/design/IMAGE_PLACEMENT_MAP.md`
class YatraAssetPlaceholder extends StatelessWidget {
  final String assetId;
  final double aspectRatio;
  final String semanticLabel;
  final Widget? fallbackChild;
  final BorderRadius borderRadius;

  const YatraAssetPlaceholder({
    super.key,
    required this.assetId,
    this.aspectRatio = 16 / 9,
    this.semanticLabel = 'YATRA Living Atlas Illustration',
    this.fallbackChild,
    this.borderRadius = YatraRadii.radiusCard,
  });

  static const Map<String, String> _assetFilenames = {
    'YATRA-ILL-001': 'assets/images/india-gate-hero.webp',
    'YATRA-ILL-002': 'assets/images/delhi-bus-isometric.png',
    'YATRA-ILL-003': 'assets/images/delhi-skyline-arch.png',
    'YATRA-ILL-004': 'assets/images/boarding-assistance-empathy.png',
    'YATRA-ILL-005': 'assets/images/wheelchair-ramp-card.png',
    'YATRA-ILL-006': 'assets/images/vision-support-card.png',
    'YATRA-ILL-007': 'assets/images/elderly-mobility-card.png',
    'YATRA-ILL-008': 'assets/images/accessible-stop-photo.png',
    'YATRA-ILL-009': 'assets/images/delhi-dark-map-texture.png',
    'YATRA-ILL-010': 'assets/images/govt-india-gate-engraving.png',
    'YATRA-BRAND-001': 'assets/brand/yatra-brand-symbol.png',
    'YATRA-BRAND-002': 'assets/brand/DelhiTransitYatraLogo.png',
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: YatraColors.surfaceCream,
            border: Border.all(color: YatraColors.softBorder, width: 1.2),
            borderRadius: borderRadius,
          ),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Render Real Asset if available with fallback to Native Painter
                _buildContentForAsset(assetId),

                // Subtle Asset Catalog Tag Badge (Bottom-Right)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: YatraColors.inkPrimary.withValues(alpha: 0.85),
                      borderRadius: YatraRadii.radiusSm,
                    ),
                    child: Text(
                      assetId,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentForAsset(String id) {
    if (fallbackChild != null) return fallbackChild!;

    final assetPath = _assetFilenames[id];
    final fallbackPainter = _getFallbackPainter(id);

    if (assetPath != null) {
      return Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => CustomPaint(painter: fallbackPainter),
      );
    }

    return CustomPaint(painter: fallbackPainter);
  }

  CustomPainter _getFallbackPainter(String id) {
    switch (id) {
      case 'YATRA-ILL-001':
        return const IndiaGatePainter();
      case 'YATRA-ILL-002':
        return const LowFloorBusPainter();
      case 'YATRA-ILL-003':
        return const DelhiSkylinePainter();
      case 'YATRA-ILL-004':
        return const BoardingEmpathyPainter();
      case 'YATRA-ILL-006':
        return const RouteMapPainter();
      default:
        return const LowFloorBusPainter();
    }
  }
}
