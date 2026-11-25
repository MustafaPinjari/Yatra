import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/yatra_colors.dart';
import '../../../../core/theme/yatra_radii.dart';
import '../../../planner/models/transit_stop.dart';
import '../../models/live_vehicle.dart';

class GeographicMapView extends StatefulWidget {
  final double centerLat;
  final double centerLon;
  final double initialZoom;
  final List<Map<String, double>> routeShape;
  final List<TransitStop> stops;
  final LiveVehicle? vehicle;
  final String? selectedStopId;
  final ValueChanged<TransitStop>? onStopTapped;

  const GeographicMapView({
    super.key,
    required this.centerLat,
    required this.centerLon,
    this.initialZoom = 13.5,
    this.routeShape = const [],
    this.stops = const [],
    this.vehicle,
    this.selectedStopId,
    this.onStopTapped,
  });

  @override
  State<GeographicMapView> createState() => _GeographicMapViewState();
}

class _GeographicMapViewState extends State<GeographicMapView> {
  late double _currentLat;
  late double _currentLon;
  late double _zoom;

  Offset _panOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _currentLat = widget.centerLat;
    _currentLon = widget.centerLon;
    _zoom = widget.initialZoom;
  }

  @override
  void didUpdateWidget(covariant GeographicMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If vehicle updated or center changed and user hasn't panned, update center
    if (_panOffset == Offset.zero) {
      _currentLat = widget.centerLat;
      _currentLon = widget.centerLon;
    }
  }

  void _recenter() {
    setState(() {
      _currentLat = widget.vehicle?.latitude ?? widget.centerLat;
      _currentLon = widget.vehicle?.longitude ?? widget.centerLon;
      _zoom = widget.initialZoom;
      _panOffset = Offset.zero;
    });
  }

  void _zoomIn() {
    setState(() {
      if (_zoom < 18.0) _zoom += 0.5;
    });
  }

  void _zoomOut() {
    setState(() {
      if (_zoom > 10.0) _zoom -= 0.5;
    });
  }

  /// Web Mercator (EPSG:3857) projection formulas
  static double lonToTileX(double lon, double zoom) {
    final n = math.pow(2.0, zoom);
    return ((lon + 180.0) / 360.0) * n;
  }

  static double latToTileY(double lat, double zoom) {
    final latRad = lat * (math.pi / 180.0);
    final n = math.pow(2.0, zoom);
    return (1.0 - math.log(math.tan(latRad) + 1.0 / math.cos(latRad)) / math.pi) / 2.0 * n;
  }

  Offset projectGps(double lat, double lon, Size viewport) {
    final centerX = lonToTileX(_currentLon, _zoom);
    final centerY = latToTileY(_currentLat, _zoom);

    final ptX = lonToTileX(lon, _zoom);
    final ptY = latToTileY(lat, _zoom);

    final px = (ptX - centerX) * 256.0 + (viewport.width / 2.0) + _panOffset.dx;
    final py = (ptY - centerY) * 256.0 + (viewport.height / 2.0) + _panOffset.dy;

    return Offset(px, py);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = Size(constraints.maxWidth, constraints.maxHeight);

        return GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _panOffset += details.delta;
            });
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Geographic Slippy Map Tiles Layer
              _buildTileLayer(viewport),

              // 2. Custom Painter for Route Polyline & Stops
              CustomPaint(
                size: viewport,
                painter: _MapPolylinePainter(
                  routeShape: widget.routeShape,
                  stops: widget.stops,
                  selectedStopId: widget.selectedStopId,
                  projectGps: (lat, lon) => projectGps(lat, lon, viewport),
                ),
              ),

              // 3. Interactive Stop Tap Targets
              ...widget.stops.map((stop) {
                final pos = projectGps(stop.latitude, stop.longitude, viewport);
                final isVisible = pos.dx >= -40 && pos.dx <= viewport.width + 40 &&
                                  pos.dy >= -40 && pos.dy <= viewport.height + 40;
                if (!isVisible) return const SizedBox.shrink();

                final isSelected = widget.selectedStopId == stop.stopId;

                return Positioned(
                  left: pos.dx - 18,
                  top: pos.dy - 18,
                  child: GestureDetector(
                    onTap: () => widget.onStopTapped?.call(stop),
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      child: Container(
                        width: isSelected ? 18 : 14,
                        height: isSelected ? 18 : 14,
                        decoration: BoxDecoration(
                          color: isSelected ? YatraColors.terracotta : YatraColors.surfaceCream,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : YatraColors.navyDeep,
                            width: 2.5,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // 4. Live Vehicle Marker (using real coordinates from GTFS-RT)
              if (widget.vehicle != null) _buildVehicleMarker(viewport),

              // 5. Map Control Overlays: Recenter, Zoom In, Zoom Out, Attribution
              Positioned(
                bottom: 12,
                right: 12,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMapButton(
                      icon: Icons.my_location,
                      tooltip: 'Center on bus',
                      onPressed: _recenter,
                    ),
                    const SizedBox(height: 6),
                    _buildMapButton(
                      icon: Icons.add,
                      tooltip: 'Zoom in',
                      onPressed: _zoomIn,
                    ),
                    const SizedBox(height: 6),
                    _buildMapButton(
                      icon: Icons.remove,
                      tooltip: 'Zoom out',
                      onPressed: _zoomOut,
                    ),
                  ],
                ),
              ),

              // Attribution pill (OpenStreetMap & Delhi Transport Stack)
              Positioned(
                bottom: 6,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '© OpenStreetMap contributors · DTS GTFS',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTileLayer(Size viewport) {
    final int tileZoom = _zoom.floor();
    final double scale = math.pow(2.0, _zoom - tileZoom).toDouble();

    final centerX = lonToTileX(_currentLon, tileZoom.toDouble());
    final centerY = latToTileY(_currentLat, tileZoom.toDouble());

    final tilesX = (viewport.width / (256 * scale)).ceil() + 2;
    final tilesY = (viewport.height / (256 * scale)).ceil() + 2;

    final startX = (centerX - tilesX / 2).floor();
    final startY = (centerY - tilesY / 2).floor();

    final maxTile = (math.pow(2, tileZoom) - 1).toInt();

    final List<Widget> tileWidgets = [];

    for (int x = startX; x <= startX + tilesX; x++) {
      for (int y = startY; y <= startY + tilesY; y++) {
        if (x < 0 || x > maxTile || y < 0 || y > maxTile) continue;

        final double tileScreenX = ((x - centerX) * 256.0 * scale) + (viewport.width / 2.0) + _panOffset.dx;
        final double tileScreenY = ((y - centerY) * 256.0 * scale) + (viewport.height / 2.0) + _panOffset.dy;

        // OpenStreetMap standard tile URL
        final url = 'https://tile.openstreetmap.org/$tileZoom/$x/$y.png';

        tileWidgets.add(
          Positioned(
            left: tileScreenX,
            top: tileScreenY,
            width: 256.0 * scale,
            height: 256.0 * scale,
            child: Image.network(
              url,
              fit: BoxFit.cover,
              headers: const {'User-Agent': 'YatraDelhiTransit/1.0 (Delhi Transport Intelligence)'},
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFFE2E8F0),
                child: const Center(
                  child: Icon(Icons.map_outlined, size: 24, color: Color(0xFF94A3B8)),
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: const Color(0xFFF1F5F9));
              },
            ),
          ),
        );
      }
    }

    return Stack(children: tileWidgets);
  }

  Widget _buildVehicleMarker(Size viewport) {
    final v = widget.vehicle!;
    final pos = projectGps(v.latitude, v.longitude, viewport);

    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 34,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Vehicle Info Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: v.isStale ? const Color(0xFF991B1B) : YatraColors.navyDeep,
              borderRadius: BorderRadius.circular(YatraRadii.sm),
              boxShadow: const [
                BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${v.routeShortName} · ${v.vehicleId}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (v.speedKmh > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    '${v.speedKmh.toInt()} km/h',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontFeatures: [FontFeature.tabularFigures()],
                      fontSize: 8,
                      color: Color(0xFFFACC15),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 2),

          // Bus Glyph with Bearing
          Transform.rotate(
            angle: (v.bearing * (math.pi / 180.0)),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: v.isStale ? const Color(0xFFEF4444) : YatraColors.terracotta,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: const Icon(
                Icons.navigation,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: YatraColors.surfaceCream,
        borderRadius: BorderRadius.circular(YatraRadii.sm),
        border: Border.all(color: YatraColors.softBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x1F000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: YatraColors.inkPrimary),
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }
}

class _MapPolylinePainter extends CustomPainter {
  final List<Map<String, double>> routeShape;
  final List<TransitStop> stops;
  final String? selectedStopId;
  final Offset Function(double lat, double lon) projectGps;

  _MapPolylinePainter({
    required this.routeShape,
    required this.stops,
    this.selectedStopId,
    required this.projectGps,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Route Polyline from Shape Points or Stops Sequence
    final points = routeShape.isNotEmpty
        ? routeShape.map((p) => projectGps(p['lat']!, p['lon']!)).toList()
        : stops.map((s) => projectGps(s.latitude, s.longitude)).toList();

    if (points.length >= 2) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      // Outer outline casing
      final casingPaint = Paint()
        ..color = Colors.white.withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      // Inner corridor color
      final linePaint = Paint()
        ..color = const Color(0xFF1E3A8A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(path, casingPaint);
      canvas.drawPath(path, linePaint);
    }

    // 2. Stop Names Text Labels for Nearby Visible Stops
    for (final stop in stops) {
      final pos = projectGps(stop.latitude, stop.longitude);
      if (pos.dx >= 0 && pos.dx <= size.width && pos.dy >= 0 && pos.dy <= size.height) {
        final textSpan = TextSpan(
          text: stop.stopName,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 9.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
            shadows: [
              Shadow(color: Colors.white, blurRadius: 4, offset: Offset(0, 1)),
              Shadow(color: Colors.white, blurRadius: 4, offset: Offset(0, -1)),
            ],
          ),
        );
        final tp = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout(maxWidth: 120);

        tp.paint(canvas, Offset(pos.dx + 12, pos.dy - 6));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapPolylinePainter oldDelegate) => true;
}
