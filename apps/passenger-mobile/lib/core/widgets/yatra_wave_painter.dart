import 'package:flutter/material.dart';
import '../theme/yatra_colors.dart';

enum YatraWaveVariant {
  hero,
  topLeft,
  bottom,
  subtle,
}

/// CustomPainter for YATRA Dynamic Flowing Waves
class YatraWavePainter extends CustomPainter {
  final YatraWaveVariant variant;

  const YatraWavePainter({this.variant = YatraWaveVariant.subtle});

  @override
  void paint(Canvas canvas, Size size) {
    switch (variant) {
      case YatraWaveVariant.hero:
        _paintHeroWaves(canvas, size);
        break;
      case YatraWaveVariant.topLeft:
        _paintTopLeftWaves(canvas, size);
        break;
      case YatraWaveVariant.bottom:
        _paintBottomWaves(canvas, size);
        break;
      case YatraWaveVariant.subtle:
        _paintSubtleWaves(canvas, size);
        break;
    }
  }

  void _paintHeroWaves(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Layer 1: Soft Peach Flowing Swell
    final Path peachPath = Path()
      ..moveTo(0, h * 0.35)
      ..cubicTo(w * 0.25, h * 0.20, w * 0.55, h * 0.45, w * 0.85, h * 0.32)
      ..cubicTo(w * 0.95, h * 0.28, w, h * 0.30, w, h * 0.28)
      ..lineTo(w, 0)
      ..lineTo(0, 0)
      ..close();

    final Paint peachPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFFFCECDD).withValues(alpha: 0.60),
          YatraColors.parchmentBg.withValues(alpha: 0.10),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.45));
    canvas.drawPath(peachPath, peachPaint);

    // Layer 2: Terracotta Warm Flowing Band
    final Path terracottaPath = Path()
      ..moveTo(0, h * 0.48)
      ..cubicTo(w * 0.30, h * 0.40, w * 0.65, h * 0.58, w, h * 0.46)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final Paint terracottaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          YatraColors.terracotta.withValues(alpha: 0.08),
          YatraColors.accentOrange.withValues(alpha: 0.04),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.40, w, h * 0.60));
    canvas.drawPath(terracottaPath, terracottaPaint);

    // Layer 3: Delicate Accent Stroke
    final Path strokePath1 = Path()
      ..moveTo(0, h * 0.38)
      ..cubicTo(w * 0.30, h * 0.25, w * 0.60, h * 0.48, w, h * 0.35);

    final Paint strokePaint1 = Paint()
      ..color = YatraColors.terracotta.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawPath(strokePath1, strokePaint1);

    // Layer 4: Deep Navy Wave Accent
    final Path strokePath2 = Path()
      ..moveTo(0, h * 0.42)
      ..cubicTo(w * 0.35, h * 0.30, w * 0.65, h * 0.52, w, h * 0.39);

    final Paint strokePaint2 = Paint()
      ..color = YatraColors.navyDeep.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(strokePath2, strokePaint2);
  }

  void _paintTopLeftWaves(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Path wavePath = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.70, 0)
      ..cubicTo(w * 0.50, h * 0.20, w * 0.20, h * 0.32, 0, h * 0.45)
      ..close();

    final Paint gradPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topLeft,
        radius: 0.85,
        colors: [
          YatraColors.terracotta.withValues(alpha: 0.12),
          const Color(0xFFFCECDD).withValues(alpha: 0.25),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(wavePath, gradPaint);

    // Accent Line
    final Path accentLine = Path()
      ..moveTo(0, h * 0.18)
      ..cubicTo(w * 0.30, h * 0.15, w * 0.45, h * 0.28, w * 0.52, h * 0.42);

    final Paint accentPaint = Paint()
      ..color = YatraColors.terracotta.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(accentLine, accentPaint);
  }

  void _paintBottomWaves(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Path bottomPath = Path()
      ..moveTo(0, h * 0.85)
      ..cubicTo(w * 0.28, h * 0.78, w * 0.60, h * 0.90, w * 0.85, h * 0.82)
      ..cubicTo(w * 0.94, h * 0.79, w * 0.98, h * 0.81, w, h * 0.80)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final Paint bottomPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFFFCECDD).withValues(alpha: 0.35),
          YatraColors.terracotta.withValues(alpha: 0.10),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.75, w, h * 0.25));
    canvas.drawPath(bottomPath, bottomPaint);

    final Path accentLine = Path()
      ..moveTo(0, h * 0.83)
      ..cubicTo(w * 0.28, h * 0.75, w * 0.60, h * 0.88, w, h * 0.78);

    final Paint accentPaint = Paint()
      ..color = YatraColors.terracotta.withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(accentLine, accentPaint);
  }

  void _paintSubtleWaves(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Path wave = Path()
      ..moveTo(0, h * 0.15)
      ..cubicTo(w * 0.30, h * 0.08, w * 0.65, h * 0.22, w, h * 0.12)
      ..lineTo(w, 0)
      ..lineTo(0, 0)
      ..close();

    final Paint wavePaint = Paint()
      ..color = const Color(0xFFFCECDD).withValues(alpha: 0.22);
    canvas.drawPath(wave, wavePaint);

    final Path line = Path()
      ..moveTo(0, h * 0.18)
      ..cubicTo(w * 0.30, h * 0.11, w * 0.65, h * 0.25, w, h * 0.15);

    final Paint linePaint = Paint()
      ..color = YatraColors.terracotta.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(line, linePaint);
  }

  @override
  bool shouldRepaint(covariant YatraWavePainter oldDelegate) =>
      oldDelegate.variant != variant;
}
