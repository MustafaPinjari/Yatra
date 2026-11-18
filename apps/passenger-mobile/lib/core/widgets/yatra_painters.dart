import 'package:flutter/material.dart';
import '../theme/yatra_colors.dart';

/// 1. India Gate Architectural Custom Painter
class IndiaGatePainter extends CustomPainter {
  const IndiaGatePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Background Warm Sun Arch
    final Paint sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          YatraColors.accentOrange.withOpacity(0.35),
          YatraColors.terracotta.withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.5, h * 0.45), radius: w * 0.45));
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.45, sunPaint);

    final Paint sunBorderPaint = Paint()
      ..color = YatraColors.terracotta.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.42, sunBorderPaint);

    // Foliage accents
    final Paint foliagePaint = Paint()
      ..color = YatraColors.heritageGreen.withOpacity(0.35)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.12, h * 0.78), w * 0.12, foliagePaint);
    canvas.drawCircle(Offset(w * 0.88, h * 0.78), w * 0.12, foliagePaint);

    // India Gate Base Plinth
    final Paint stonePaint = Paint()..color = YatraColors.sandstone;
    final Paint inkStroke = Paint()
      ..color = YatraColors.inkPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double plinthW = w * 0.65;
    final double plinthH = h * 0.08;
    final double plinthX = (w - plinthW) / 2;
    final double plinthY = h * 0.72;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(plinthX, plinthY, plinthW, plinthH), const Radius.circular(4)),
      stonePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(plinthX, plinthY, plinthW, plinthH), const Radius.circular(4)),
      inkStroke,
    );

    // Main Columns
    final double colW = plinthW * 0.28;
    final double colH = h * 0.38;
    final double colY = plinthY - colH;
    final double leftColX = plinthX + plinthW * 0.08;
    final double rightColX = plinthX + plinthW - colW - plinthW * 0.08;

    canvas.drawRect(Rect.fromLTWH(leftColX, colY, colW, colH), stonePaint);
    canvas.drawRect(Rect.fromLTWH(leftColX, colY, colW, colH), inkStroke);

    canvas.drawRect(Rect.fromLTWH(rightColX, colY, colW, colH), stonePaint);
    canvas.drawRect(Rect.fromLTWH(rightColX, colY, colW, colH), inkStroke);

    // Central Arch
    final Path archPath = Path()
      ..moveTo(leftColX + colW, plinthY)
      ..lineTo(leftColX + colW, colY + colH * 0.35)
      ..arcToPoint(
        Offset(rightColX, colY + colH * 0.35),
        radius: Radius.circular((rightColX - (leftColX + colW)) / 2),
        clockwise: true,
      )
      ..lineTo(rightColX, plinthY)
      ..close();

    final Paint archBg = Paint()..color = YatraColors.parchmentBg;
    canvas.drawPath(archPath, archBg);
    canvas.drawPath(archPath, inkStroke);

    // Architrave & Cornice
    final double corniceW = plinthW * 1.05;
    final double corniceH = h * 0.05;
    final double corniceX = (w - corniceW) / 2;
    final double corniceY = colY - corniceH;

    canvas.drawRect(Rect.fromLTWH(corniceX, corniceY, corniceW, corniceH), stonePaint);
    canvas.drawRect(Rect.fromLTWH(corniceX, corniceY, corniceW, corniceH), inkStroke);

    // Attic & Inscription Block
    final double atticW = plinthW * 0.85;
    final double atticH = h * 0.12;
    final double atticX = (w - atticW) / 2;
    final double atticY = corniceY - atticH;

    canvas.drawRect(Rect.fromLTWH(atticX, atticY, atticW, atticH), stonePaint);
    canvas.drawRect(Rect.fromLTWH(atticX, atticY, atticW, atticH), inkStroke);

    // Top Inscription Lines
    final Paint linePaint = Paint()
      ..color = YatraColors.inkPrimary
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(atticX + 16, atticY + atticH * 0.4), Offset(atticX + atticW - 16, atticY + atticH * 0.4), linePaint);
    canvas.drawLine(Offset(atticX + 28, atticY + atticH * 0.65), Offset(atticX + atticW - 28, atticY + atticH * 0.65), linePaint);

    // Dome Bowl Top
    final Rect bowlRect = Rect.fromCenter(center: Offset(w * 0.5, atticY - 4), width: atticW * 0.4, height: 12);
    canvas.drawOval(bowlRect, Paint()..color = YatraColors.goldSand);
    canvas.drawOval(bowlRect, inkStroke);

    // Roadway Base
    final Paint roadPaint = Paint()..color = YatraColors.inkPrimary;
    canvas.drawRect(Rect.fromLTWH(0, h * 0.84, w, h * 0.16), roadPaint);

    final Paint roadStripe = Paint()
      ..color = const Color(0xFFFACC15)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (double x = 16; x < w; x += 36) {
      canvas.drawLine(Offset(x, h * 0.92), Offset(x + 20, h * 0.92), roadStripe);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 2. Modern Low-Floor DTC Bus Custom Painter
class LowFloorBusPainter extends CustomPainter {
  const LowFloorBusPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Bus Body Main Shell
    final RRect busBody = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.05, h * 0.12, w * 0.90, h * 0.68),
      const Radius.circular(16),
    );
    final Paint busGreen = Paint()..color = YatraColors.heritageGreen;
    final Paint inkBorder = Paint()
      ..color = YatraColors.inkPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawRRect(busBody, busGreen);
    canvas.drawRRect(busBody, inkBorder);

    // Lower Skirt
    final RRect skirt = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.05, h * 0.55, w * 0.90, h * 0.25),
      const Radius.circular(8),
    );
    canvas.drawRRect(skirt, Paint()..color = const Color(0xFF0E5234));

    // LED Route Destination Sign
    final RRect ledBox = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.03, w * 0.55, h * 0.14),
      const Radius.circular(6),
    );
    canvas.drawRRect(ledBox, Paint()..color = YatraColors.navyDeep);
    canvas.drawRRect(ledBox, inkBorder);

    // Route Text on LED
    final TextPainter routeTp = TextPainter(
      text: const TextSpan(
        text: '502 KASHMERE GATE',
        style: TextStyle(
          color: Color(0xFFFACC15),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    routeTp.paint(canvas, Offset(w * 0.20, h * 0.055));

    // Windows
    final Paint windowPaint = Paint()..color = YatraColors.paleGreen;
    final double winW = w * 0.18;
    final double winH = h * 0.28;
    final double winY = h * 0.22;

    for (int i = 0; i < 3; i++) {
      final double winX = w * 0.10 + (i * (winW + w * 0.04));
      final RRect winRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(winX, winY, winW, winH),
        const Radius.circular(6),
      );
      canvas.drawRRect(winRect, windowPaint);
      canvas.drawRRect(winRect, inkBorder);
    }

    // Front Windshield
    final Path windshield = Path()
      ..moveTo(w * 0.78, winY)
      ..lineTo(w * 0.92, winY)
      ..arcToPoint(Offset(w * 0.94, winY + winH), radius: const Radius.circular(8), clockwise: true)
      ..lineTo(w * 0.78, winY + winH)
      ..close();
    canvas.drawPath(windshield, windowPaint);
    canvas.drawPath(windshield, inkBorder);

    // Deployed Neon Wheelchair Ramp
    final Path ramp = Path()
      ..moveTo(w * 0.38, h * 0.80)
      ..lineTo(w * 0.60, h * 0.80)
      ..lineTo(w * 0.64, h * 0.92)
      ..lineTo(w * 0.34, h * 0.92)
      ..close();
    canvas.drawPath(ramp, Paint()..color = const Color(0xFFFACC15));
    canvas.drawPath(ramp, inkBorder);

    // ISA Wheelchair Decal
    final Paint decalBg = Paint()..color = YatraColors.navyDeep;
    canvas.drawCircle(Offset(w * 0.32, h * 0.66), 11, decalBg);
    final Paint isaWhite = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(w * 0.32, h * 0.63), 2.5, Paint()..color = Colors.white);
    canvas.drawLine(Offset(w * 0.32, h * 0.65), Offset(w * 0.32, h * 0.70), isaWhite);
    canvas.drawLine(Offset(w * 0.32, h * 0.70), Offset(w * 0.35, h * 0.70), isaWhite);

    // Low-Floor Wheels
    final Paint wheelTyre = Paint()..color = YatraColors.inkPrimary;
    final Paint wheelHub = Paint()..color = const Color(0xFFCBD5E1);

    canvas.drawCircle(Offset(w * 0.20, h * 0.82), w * 0.08, wheelTyre);
    canvas.drawCircle(Offset(w * 0.20, h * 0.82), w * 0.035, wheelHub);

    canvas.drawCircle(Offset(w * 0.78, h * 0.82), w * 0.08, wheelTyre);
    canvas.drawCircle(Offset(w * 0.78, h * 0.82), w * 0.035, wheelHub);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3. Delhi Skyline Panoramic Custom Painter
class DelhiSkylinePainter extends CustomPainter {
  const DelhiSkylinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Ground line
    final Paint groundPaint = Paint()
      ..color = YatraColors.inkPrimary
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(0, h * 0.95), Offset(w, h * 0.95), groundPaint);

    final Paint archPaint = Paint()..color = YatraColors.sandstone;
    final Paint terracottaFill = Paint()..color = YatraColors.terracotta;
    final Paint inkLine = Paint()
      ..color = YatraColors.inkPrimary
      ..strokeWidth = 1.5;

    // Qutub Minar (Left)
    final Path minar = Path()
      ..moveTo(w * 0.08, h * 0.95)
      ..lineTo(w * 0.10, h * 0.18)
      ..lineTo(w * 0.13, h * 0.18)
      ..lineTo(w * 0.15, h * 0.95)
      ..close();
    canvas.drawPath(minar, archPaint);
    canvas.drawPath(minar, inkLine);

    // Minar Balconies
    canvas.drawLine(Offset(w * 0.09, h * 0.40), Offset(w * 0.14, h * 0.40), inkLine);
    canvas.drawLine(Offset(w * 0.095, h * 0.60), Offset(w * 0.135, h * 0.60), inkLine);
    canvas.drawLine(Offset(w * 0.10, h * 0.78), Offset(w * 0.13, h * 0.78), inkLine);

    // Metro Viaduct in background
    final Paint metroLine = Paint()
      ..color = YatraColors.navyDeep.withOpacity(0.7)
      ..strokeWidth = 3.5;
    canvas.drawLine(Offset(w * 0.18, h * 0.65), Offset(w * 0.55, h * 0.65), metroLine);
    canvas.drawLine(Offset(w * 0.25, h * 0.65), Offset(w * 0.25, h * 0.95), metroLine);
    canvas.drawLine(Offset(w * 0.38, h * 0.65), Offset(w * 0.38, h * 0.95), metroLine);
    canvas.drawLine(Offset(w * 0.48, h * 0.65), Offset(w * 0.48, h * 0.95), metroLine);

    // Red Fort / Jama Masjid Mughal Dome (Center)
    final double domeX = w * 0.60;
    final double domeY = h * 0.45;
    canvas.drawRect(Rect.fromLTWH(domeX - 25, domeY, 50, h * 0.50), archPaint);
    canvas.drawRect(Rect.fromLTWH(domeX - 25, domeY, 50, h * 0.50), inkLine);

    // Onion dome curve
    final Path onionDome = Path()
      ..moveTo(domeX - 22, domeY)
      ..cubicTo(domeX - 25, domeY - 28, domeX - 10, domeY - 45, domeX, domeY - 50)
      ..cubicTo(domeX + 10, domeY - 45, domeX + 25, domeY - 28, domeX + 22, domeY)
      ..close();
    canvas.drawPath(onionDome, terracottaFill);
    canvas.drawPath(onionDome, inkLine);

    // Lotus Temple Petals (Right)
    final double lotusX = w * 0.85;
    final double lotusY = h * 0.95;
    final Path lotus = Path()
      ..moveTo(lotusX - 30, lotusY)
      ..cubicTo(lotusX - 35, lotusY - 55, lotusX, lotusY - 70, lotusX, lotusY - 70)
      ..cubicTo(lotusX, lotusY - 70, lotusX + 35, lotusY - 55, lotusX + 30, lotusY)
      ..close();
    canvas.drawPath(lotus, Paint()..color = YatraColors.surfaceCream);
    canvas.drawPath(lotus, inkLine);

    // Foliage canopy
    canvas.drawCircle(Offset(w * 0.18, h * 0.90), 16, Paint()..color = YatraColors.heritageGreen.withOpacity(0.3));
    canvas.drawCircle(Offset(w * 0.74, h * 0.90), 20, Paint()..color = YatraColors.heritageGreen.withOpacity(0.3));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 4. Empathetic Boarding Assistance Custom Painter
class BoardingEmpathyPainter extends CustomPainter {
  const BoardingEmpathyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Platform Surface
    final Paint platformPaint = Paint()..color = YatraColors.sandstone;
    canvas.drawRect(Rect.fromLTWH(0, h * 0.78, w, h * 0.22), platformPaint);

    // Tactile Paving Strip
    final Paint tactileStrip = Paint()..color = const Color(0xFFFACC15);
    canvas.drawRect(Rect.fromLTWH(w * 0.05, h * 0.80, w * 0.90, 10), tactileStrip);
    final Paint studPaint = Paint()..color = const Color(0xFFB45309);
    for (double x = w * 0.08; x < w * 0.92; x += 18) {
      canvas.drawCircle(Offset(x, h * 0.80 + 5), 2.5, studPaint);
    }

    // Bus Doorway at right
    final Paint busDoorBg = Paint()..color = YatraColors.paleGreen;
    final Paint busFrame = Paint()
      ..color = YatraColors.heritageGreen
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(w * 0.65, h * 0.15, w * 0.35, h * 0.65), busFrame);
    canvas.drawRect(Rect.fromLTWH(w * 0.68, h * 0.20, w * 0.26, h * 0.58), busDoorBg);

    // Yellow Handrails in bus doorway
    final Paint handrail = Paint()
      ..color = const Color(0xFFFACC15)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.72, h * 0.25), Offset(w * 0.72, h * 0.76), handrail);

    // Conductor Silhouette welcoming passenger
    final Paint crewPaint = Paint()..color = YatraColors.navyDeep;
    canvas.drawCircle(Offset(w * 0.82, h * 0.35), 10, Paint()..color = YatraColors.goldSand);
    canvas.drawRect(Rect.fromLTWH(w * 0.76, h * 0.42, 20, 40), crewPaint);

    // Yellow Boarding Ramp
    final Path ramp = Path()
      ..moveTo(w * 0.50, h * 0.78)
      ..lineTo(w * 0.68, h * 0.76)
      ..lineTo(w * 0.68, h * 0.82)
      ..lineTo(w * 0.50, h * 0.82)
      ..close();
    canvas.drawPath(ramp, Paint()..color = const Color(0xFFFACC15));
    canvas.drawPath(
      ramp,
      Paint()
        ..color = YatraColors.inkPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Commuter in Wheelchair (Facing right toward ramp)
    final double px = w * 0.35;
    final double py = h * 0.50;

    // Head
    canvas.drawCircle(Offset(px, py), 12, Paint()..color = YatraColors.goldSand);
    canvas.drawCircle(
      Offset(px, py),
      12,
      Paint()
        ..color = YatraColors.inkPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Torso (Terracotta shirt)
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(px - 10, py + 14, 22, 32), const Radius.circular(6)),
      Paint()..color = YatraColors.terracotta,
    );

    // Wheelchair Large Wheel
    final Paint wheelStroke = Paint()
      ..color = YatraColors.inkPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(Offset(px - 2, py + 52), 22, wheelStroke);
    canvas.drawCircle(
      Offset(px - 2, py + 52),
      18,
      Paint()
        ..color = YatraColors.terracotta
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Arm pushing rim
    final Paint arm = Paint()
      ..color = YatraColors.inkPrimary
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(px - 4, py + 24), Offset(px + 10, py + 42), arm);
    canvas.drawLine(Offset(px + 10, py + 42), Offset(px - 2, py + 48), arm);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 5. Cartographic Transit Route Map Custom Painter
class RouteMapPainter extends CustomPainter {
  final double animationProgress;

  const RouteMapPainter({this.animationProgress = 0.5});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Warm Ivory Grid Background
    final Paint gridPaint = Paint()
      ..color = YatraColors.softBorder.withOpacity(0.6)
      ..strokeWidth = 0.8;
    for (double x = 0; x < w; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    for (double y = 0; y < h; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // River Ribbon (Yamuna)
    final Path river = Path()
      ..moveTo(w * 0.85, 0)
      ..cubicTo(w * 0.75, h * 0.3, w * 0.90, h * 0.7, w * 0.80, h);
    final Paint riverPaint = Paint()
      ..color = const Color(0xFFBFDBFE).withOpacity(0.5)
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(river, riverPaint);

    // Primary Route Line (Terracotta Transit Corridor)
    final Path route = Path()
      ..moveTo(w * 0.25, h * 0.15)
      ..lineTo(w * 0.40, h * 0.35)
      ..lineTo(w * 0.50, h * 0.65)
      ..lineTo(w * 0.65, h * 0.85);

    final Paint routeHalo = Paint()
      ..color = YatraColors.terracotta.withOpacity(0.2)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(route, routeHalo);

    final Paint routeCore = Paint()
      ..color = YatraColors.terracotta
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(route, routeCore);

    // Stop Nodes
    final List<Offset> stops = [
      Offset(w * 0.25, h * 0.15),
      Offset(w * 0.40, h * 0.35),
      Offset(w * 0.50, h * 0.65),
      Offset(w * 0.65, h * 0.85),
    ];

    for (int i = 0; i < stops.length; i++) {
      final Offset stop = stops[i];
      canvas.drawCircle(stop, 7, Paint()..color = YatraColors.navyDeep);
      canvas.drawCircle(
        stop,
        7,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }

    // Live Bus Marker Beacon (Interpolated position between stop 1 and stop 2)
    final Offset busPos = Offset.lerp(stops[1], stops[2], animationProgress.clamp(0.0, 1.0))!;
    
    // Pulse Halo
    canvas.drawCircle(busPos, 16, Paint()..color = YatraColors.heritageGreen.withOpacity(0.25));
    canvas.drawCircle(busPos, 10, Paint()..color = YatraColors.heritageGreen);
    canvas.drawCircle(
      busPos,
      10,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant RouteMapPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress;
}
