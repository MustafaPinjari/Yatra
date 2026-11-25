import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/api_config.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';
import '../../../core/theme/yatra_radii.dart';
import '../../../core/widgets/yatra_wave_background.dart';
import '../models/transit_stop.dart';
import '../models/journey_result.dart';
import '../services/journey_planner_service.dart';
import 'widgets/stop_autocomplete_field.dart';

class JourneyPlannerScreen extends StatefulWidget {
  const JourneyPlannerScreen({super.key});

  @override
  State<JourneyPlannerScreen> createState() => _JourneyPlannerScreenState();
}

class _JourneyPlannerScreenState extends State<JourneyPlannerScreen> {
  final JourneyPlannerService _plannerService = JourneyPlannerService();

  final GlobalKey<StopAutocompleteFieldState> _originKey = GlobalKey<StopAutocompleteFieldState>();
  final GlobalKey<StopAutocompleteFieldState> _destKey = GlobalKey<StopAutocompleteFieldState>();

  int _selectedModeIndex = 0; // 0: Bus only, 1: Metro, 2: Multimodal
  bool _stepFreeOnly = true;
  bool _preferLowCrowding = false;
  bool _isSearching = false;
  String? _errorMessage;

  TransitStop? _originStop = const TransitStop(
    stopId: 'stop_delhi_502_01',
    stopName: 'Kashmere Gate ISBT',
    latitude: 28.6675,
    longitude: 77.2285,
    locationType: 0,
    accessibilityScore: 92.5,
    hasWheelchairRamp: true,
    hasTactilePaving: true,
  );

  TransitStop? _destStop = const TransitStop(
    stopId: 'stop_delhi_502_04',
    stopName: 'AIIMS Metro Station',
    latitude: 28.5684,
    longitude: 77.2078,
    locationType: 1,
    accessibilityScore: 96.0,
    hasWheelchairRamp: true,
    hasTactilePaving: true,
  );

  List<JourneyItinerary> _itineraries = [];

  final List<TransitStop> _quickStops = const [
    TransitStop(stopId: 'stop_delhi_502_01', stopName: 'Kashmere Gate ISBT', latitude: 28.6675, longitude: 77.2285, hasWheelchairRamp: true),
    TransitStop(stopId: 'stop_delhi_502_04', stopName: 'AIIMS Metro Station', latitude: 28.5684, longitude: 77.2078, locationType: 1, hasWheelchairRamp: true),
    TransitStop(stopId: 'stop_delhi_502_02', stopName: 'Red Fort (Lal Qila)', latitude: 28.6562, longitude: 77.2410, hasWheelchairRamp: true),
    TransitStop(stopId: 'stop_delhi_502_03', stopName: 'Delhi Gate', latitude: 28.6415, longitude: 77.2405, hasWheelchairRamp: false),
    TransitStop(stopId: 'stop_delhi_502_05', stopName: 'Mehrauli Terminal', latitude: 28.5175, longitude: 77.1820, hasWheelchairRamp: true),
  ];

  @override
  void initState() {
    super.initState();
    // Run an initial search with the default valid Delhi endpoints
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _executeSearch();
    });
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  void _swapStops() {
    setState(() {
      final temp = _originStop;
      _originStop = _destStop;
      _destStop = temp;
    });

    _originKey.currentState?.setStop(_originStop);
    _destKey.currentState?.setStop(_destStop);
  }

  void _executeSearch() async {
    if (_originStop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a valid origin stop from suggestions'),
          backgroundColor: YatraColors.terracotta,
        ),
      );
      return;
    }

    if (_destStop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a valid destination stop from suggestions'),
          backgroundColor: YatraColors.terracotta,
        ),
      );
      return;
    }

    if (_originStop!.stopId == _destStop!.stopId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Origin and destination cannot be the same stop'),
          backgroundColor: YatraColors.terracotta,
        ),
      );
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final objective = _preferLowCrowding
          ? 'LEAST_CROWDED'
          : (_stepFreeOnly ? 'MOST_ACCESSIBLE' : 'FASTEST');

      final results = await _plannerService.planJourney(
        originLat: _originStop!.latitude,
        originLon: _originStop!.longitude,
        destLat: _destStop!.latitude,
        destLon: _destStop!.longitude,
        departureHour: 9.0,
        wheelchairAccessibleOnly: _stepFreeOnly,
        objective: objective,
      );

      // Filter by mode if bus-only requested
      List<JourneyItinerary> filtered = results;
      if (_selectedModeIndex == 0) {
        // Bus only
        filtered = results.where((itin) => itin.legs.every((l) => l.mode != 'METRO')).toList();
        if (filtered.isEmpty) filtered = results;
      }

      if (mounted) {
        setState(() {
          _isSearching = false;
          _itineraries = filtered;
        });
      }
    } catch (e) {
      if (mounted) {
        String detail = 'Could not compute transit routes. Please retry.';
        if (e is DioException) {
          if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
            detail = 'Connection timed out. Verify backend is running at ${ApiConfig.baseUrl}.';
          } else if (e.response != null) {
            detail = 'Backend returned HTTP ${e.response?.statusCode}. Please retry.';
          } else {
            detail = 'Cannot connect to API at ${ApiConfig.baseUrl}. Verify backend service is active.';
          }
        }
        setState(() {
          _isSearching = false;
          _errorMessage = detail;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YatraColors.parchmentBg,
      appBar: AppBar(
        title: Text('Journey planner', style: YatraTypography.sectionTitle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: _handleBack,
        ),
      ),
      body: YatraWaveBackground(
        variant: YatraWaveVariant.subtle,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            children: [
              // Mode Selectors: Bus only, Metro, Multimodal
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: YatraColors.surfaceCream,
                  borderRadius: BorderRadius.circular(YatraRadii.input),
                  border: Border.all(color: YatraColors.softBorder),
                ),
                child: Row(
                  children: [
                    _buildModeButton(0, 'Bus only', Icons.directions_bus),
                    _buildModeButton(1, 'Metro', Icons.train),
                    _buildModeButton(2, 'Multimodal', Icons.alt_route),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Origin & Destination Autocomplete Inputs with Swap Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: YatraColors.surfaceCream,
                  borderRadius: BorderRadius.circular(YatraRadii.card),
                  border: Border.all(color: YatraColors.softBorder, width: 1.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x06101B3A),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    StopAutocompleteField(
                      key: _originKey,
                      label: 'Origin',
                      hintText: 'Enter origin stop or station',
                      prefixIcon: Icons.my_location,
                      iconColor: YatraColors.terracotta,
                      initialStop: _originStop,
                      service: _plannerService,
                      onStopSelected: (stop) {
                        setState(() {
                          _originStop = stop;
                        });
                      },
                    ),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: YatraColors.softBorder)),
                        IconButton(
                          icon: const Icon(Icons.swap_vert, color: YatraColors.inkPrimary, size: 20),
                          tooltip: 'Swap origin and destination',
                          onPressed: _swapStops,
                        ),
                        const Expanded(child: Divider(color: YatraColors.softBorder)),
                      ],
                    ),
                    StopAutocompleteField(
                      key: _destKey,
                      label: 'Destination',
                      hintText: 'Enter destination stop or station',
                      prefixIcon: Icons.location_on,
                      iconColor: YatraColors.heritageGreen,
                      initialStop: _destStop,
                      service: _plannerService,
                      onStopSelected: (stop) {
                        setState(() {
                          _destStop = stop;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Quick Stop Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickStops.map((stop) {
                    final isOrigin = _originStop?.stopId == stop.stopId;
                    final isDest = _destStop?.stopId == stop.stopId;

                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: ActionChip(
                        avatar: Icon(
                          stop.isMetroStation ? Icons.subway : Icons.directions_bus,
                          size: 14,
                          color: isOrigin
                              ? YatraColors.terracotta
                              : (isDest ? YatraColors.heritageGreen : YatraColors.inkSecondary),
                        ),
                        label: Text(
                          stop.stopName,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: (isOrigin || isDest) ? FontWeight.bold : FontWeight.w500,
                            color: YatraColors.inkSecondary,
                          ),
                        ),
                        backgroundColor: (isOrigin || isDest)
                            ? YatraColors.parchmentBg
                            : YatraColors.surfaceCream,
                        side: BorderSide(
                          color: isOrigin
                              ? YatraColors.terracotta
                              : (isDest ? YatraColors.heritageGreen : YatraColors.softBorder),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        onPressed: () {
                          if (_originStop == null) {
                            setState(() => _originStop = stop);
                            _originKey.currentState?.setStop(stop);
                          } else {
                            setState(() => _destStop = stop);
                            _destKey.currentState?.setStop(stop);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // Accessibility Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      selected: _stepFreeOnly,
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.accessible, size: 14),
                          SizedBox(width: 4),
                          Text('Step-free access'),
                        ],
                      ),
                      selectedColor: YatraColors.paleGreen,
                      checkmarkColor: YatraColors.heritageGreen,
                      onSelected: (val) {
                        setState(() => _stepFreeOnly = val);
                        if (_originStop != null && _destStop != null) {
                          _executeSearch();
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _preferLowCrowding,
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_outline, size: 14),
                          SizedBox(width: 4),
                          Text('Low crowding'),
                        ],
                      ),
                      selectedColor: YatraColors.paleAmber,
                      checkmarkColor: YatraColors.amberWarning,
                      onSelected: (val) {
                        setState(() => _preferLowCrowding = val);
                        if (_originStop != null && _destStop != null) {
                          _executeSearch();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: YatraColors.navyDeep,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(YatraRadii.button),
                    ),
                  ),
                  onPressed: _isSearching ? null : _executeSearch,
                  icon: _isSearching
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.search, size: 18),
                  label: Text(_isSearching ? 'Finding accessible connections' : 'Search accessible routes'),
                ),
              ),
              const SizedBox(height: 20),

              // Results Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended accessible routes',
                    style: YatraTypography.sectionTitle(fontSize: 18),
                  ),
                  if (_itineraries.isNotEmpty)
                    Text(
                      '${_itineraries.length} found',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontFeatures: [FontFeature.tabularFigures()],
                        fontSize: 12,
                        color: YatraColors.inkMuted,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Error State
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(YatraRadii.card),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Color(0xFF991B1B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: _executeSearch,
                        icon: const Icon(Icons.refresh, size: 14),
                        label: const Text('Retry search'),
                      ),
                    ],
                  ),
                ),

              // Empty State
              if (!_isSearching && _itineraries.isEmpty && _errorMessage == null)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: YatraColors.surfaceCream,
                    borderRadius: BorderRadius.circular(YatraRadii.card),
                    border: Border.all(color: YatraColors.softBorder),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(Icons.directions_bus_outlined, size: 36, color: YatraColors.inkMuted),
                        SizedBox(height: 8),
                        Text(
                          'No direct transit connections found',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: YatraColors.inkPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Try expanding search radius or choosing another destination stop',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: YatraColors.inkMuted),
                        ),
                      ],
                    ),
                  ),
                ),

              // Real Itinerary Cards
              ..._itineraries.asMap().entries.map((entry) {
                final index = entry.key;
                final itin = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: _RealItineraryCard(
                    itinerary: itin,
                    isRecommended: index == 0,
                    onSelect: () => context.go('/tracking'),
                  ),
                );
              }),

              // Bottom safe scrolling padding (prevents bottom nav bar clipping)
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(int index, String label, IconData icon) {
    final isSelected = _selectedModeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedModeIndex = index);
          if (_originStop != null && _destStop != null) {
            _executeSearch();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? YatraColors.navyDeep : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : YatraColors.inkSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : YatraColors.inkSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RealItineraryCard extends StatefulWidget {
  final JourneyItinerary itinerary;
  final bool isRecommended;
  final VoidCallback onSelect;

  const _RealItineraryCard({
    required this.itinerary,
    required this.isRecommended,
    required this.onSelect,
  });

  @override
  State<_RealItineraryCard> createState() => _RealItineraryCardState();
}

class _RealItineraryCardState extends State<_RealItineraryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final itin = widget.itinerary;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: YatraColors.softBorder, width: 1.2),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _expanded = !_expanded;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isRecommended) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: YatraColors.paleGreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        itin.isStepFreeAccessible
                            ? 'Recommended step-free route'
                            : 'Fastest recommended route',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: YatraColors.heritageGreen,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹${itin.estimatedFareInr}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontFeatures: [FontFeature.tabularFigures()],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: YatraColors.inkPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${itin.totalDurationMinutes.toInt()}',
                    style: YatraTypography.metricSerif(fontSize: 34, color: YatraColors.terracotta),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'min',
                    style: YatraTypography.sectionTitle(fontSize: 16, color: YatraColors.inkPrimary),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: YatraColors.navyDeep,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      itin.primaryRouteShortName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                itin.summary,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: YatraColors.inkSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Departs ${itin.departureTime} · Arrives ${itin.arrivalTime}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontFeatures: [FontFeature.tabularFigures()],
                  fontSize: 12,
                  color: YatraColors.inkMuted,
                ),
              ),
              const Divider(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: YatraColors.parchmentBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Access score ${itin.accessibilityScore.toInt()}/100',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontFeatures: [FontFeature.tabularFigures()],
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: YatraColors.heritageGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    itin.crowdingLevel == 'LOW' ? 'Seats available' : '${itin.crowdingLevel.toLowerCase()} crowding',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: YatraColors.inkSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    itin.transfers == 0 ? 'Direct' : '${itin.transfers} transfer',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: YatraColors.inkMuted,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: widget.onSelect,
                    icon: const Text(
                      'Track',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: YatraColors.terracotta,
                      ),
                    ),
                    label: const Icon(Icons.arrow_forward, size: 14, color: YatraColors.terracotta),
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                const Text(
                  'Route itinerary legs',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: YatraColors.inkPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...itin.legs.map((leg) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        leg.mode == 'BUS' ? Icons.directions_bus : Icons.directions_walk,
                        size: 16,
                        color: leg.mode == 'BUS' ? YatraColors.navyDeep : YatraColors.inkMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${leg.fromName} → ${leg.toName}',
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${leg.durationMinutes.toInt()} min (${leg.distanceKm > 0 ? '${leg.distanceKm} km' : '${leg.walkingMeters.toInt()} m'})',
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: YatraColors.inkMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
