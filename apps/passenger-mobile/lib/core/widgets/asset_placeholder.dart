import 'package:flutter/material.dart';
import '../theme/yatra_colors.dart';
import 'yatra_painters.dart';

/// Asset Inventory mapping directly to `docs/design/YATRA_IMAGE_ASSET_REQUIREMENTS.md`
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
                // Render Corresponding Native Painter based on Asset Catalog
                _buildPainterForAsset(assetId),

                // Subtle Asset Catalog Tag Badge (Bottom-Right)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: YatraColors.inkPrimary.withOpacity(0.85),
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

  Widget _buildPainterForAsset(String id) {
    if (fallbackChild != null) return fallbackChild!;

    switch (id) {
      case 'YATRA-ILL-001':
        return const CustomPaint(painter: IndiaGatePainter());
      case 'YATRA-ILL-002':
        return const CustomPaint(painter: LowFloorBusPainter());
      case 'YATRA-ILL-003':
        return const CustomPaint(painter: DelhiSkylinePainter());
      case 'YATRA-ILL-004':
        return const CustomPaint(painter: BoardingEmpathyPainter());
      case 'YATRA-ILL-006':
        return const CustomPaint(painter: RouteMapPainter());
      default:
        return const CustomPaint(painter: LowFloorBusPainter());
    }
  }
}

