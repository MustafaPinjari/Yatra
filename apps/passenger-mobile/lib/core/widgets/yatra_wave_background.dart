import 'package:flutter/material.dart';
import '../theme/yatra_colors.dart';
import 'yatra_wave_painter.dart';

export 'yatra_wave_painter.dart';

/// Full-screen or container-relative responsive wave backdrop
class YatraWaveBackground extends StatelessWidget {
  final Widget child;
  final YatraWaveVariant variant;
  final Color backgroundColor;

  const YatraWaveBackground({
    super.key,
    required this.child,
    this.variant = YatraWaveVariant.subtle,
    this.backgroundColor = YatraColors.parchmentBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background CustomPaint Wave Layer
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: YatraWavePainter(variant: variant),
              ),
            ),
          ),

          // Main Foreground Content
          child,
        ],
      ),
    );
  }
}
