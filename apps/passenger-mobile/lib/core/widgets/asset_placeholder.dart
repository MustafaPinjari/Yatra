import 'package:flutter/material.dart';
import '../theme/yatra_colors.dart';
import 'yatra_painters.dart';

/// Asset Inventory mapping directly to `docs/design/IMAGE_PLACEMENT_MAP.md`
class YatraAssetPlaceholder extends StatelessWidget {
  final String assetId;
  final double aspectRatio;
  final String semanticLabel;
  final Widget? fallbackChild;

  const YatraAssetPlaceholder({
    super.key,
    required this.assetId,
    this.aspectRatio = 16 / 9,
    this.semanticLabel = 'YATRA Living Atlas Illustration',
    this.fallbackChild,
  });

  static const Map<String, String> _assetFilenames = {
    'YATRA-ILL-001': 'assets/images/india-gate-hero.webp',
    'YATRA-ILL-002': 'assets/images/delhi-bus-isometric.webp',
    'YATRA-ILL-003': 'assets/images/delhi-skyline-arch.webp',
    'YATRA-ILL-004': 'assets/images/boarding-assistance-empathy.webp',
    'YATRA-BRAND-001': 'assets/brand/yatra-brand-masthead.png',
    'YATRA-BRAND-002': 'assets/brand/yatra-wordmark.png',
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: YatraColors.surfaceCream,
            border: Border.all(color: YatraColors.softBorder, width: 1.2),
            borderRadius: BorderRadius.circular(16),
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
                      borderRadius: BorderRadius.circular(6),
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
