import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/yatra_colors.dart';
import '../../../../core/theme/yatra_radii.dart';
import '../../../../core/theme/yatra_typography.dart';
import '../../models/transit_stop.dart';
import '../../services/journey_planner_service.dart';

class StopAutocompleteField extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final Color iconColor;
  final TransitStop? initialStop;
  final ValueChanged<TransitStop?> onStopSelected;
  final JourneyPlannerService service;

  const StopAutocompleteField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.iconColor,
    this.initialStop,
    required this.onStopSelected,
    required this.service,
  });

  @override
  State<StopAutocompleteField> createState() => StopAutocompleteFieldState();
}

class StopAutocompleteFieldState extends State<StopAutocompleteField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  Timer? _debounce;
  CancelToken? _cancelToken;

  bool _isLoading = false;
  List<TransitStop> _suggestions = [];
  TransitStop? _selectedStop;
  int _searchSequence = 0;

  TransitStop? get selectedStop => _selectedStop;

  @override
  void initState() {
    super.initState();
    if (widget.initialStop != null) {
      _selectedStop = widget.initialStop;
      _controller.text = widget.initialStop!.stopName;
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        if (_controller.text.isNotEmpty && _suggestions.isNotEmpty) {
          _showOverlay();
        }
      } else {
        _hideOverlay();
      }
    });
  }

  @override
  void didUpdateWidget(covariant StopAutocompleteField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialStop != oldWidget.initialStop) {
      _selectedStop = widget.initialStop;
      _controller.text = widget.initialStop?.stopName ?? '';
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cancelToken?.cancel();
    _hideOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void setStop(TransitStop? stop) {
    setState(() {
      _selectedStop = stop;
      _controller.text = stop?.stopName ?? '';
      _suggestions = [];
    });
    _hideOverlay();
    widget.onStopSelected(stop);
  }

  void _onTextChanged(String value) {
    // Editing text invalidates previous stop selection
    if (_selectedStop != null && _selectedStop!.stopName != value) {
      setState(() {
        _selectedStop = null;
      });
      widget.onStopSelected(null);
    }

    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
      });
      _hideOverlay();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(value.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    final currentSeq = ++_searchSequence;
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    setState(() {
      _isLoading = true;
    });
    _showOverlay();

    try {
      final results = await widget.service.searchStops(query, cancelToken: _cancelToken);
      // Ignore outdated responses
      if (!mounted || currentSeq != _searchSequence) return;

      setState(() {
        _isLoading = false;
        _suggestions = results;
      });
      _updateOverlay();
    } catch (e) {
      if (!mounted || currentSeq != _searchSequence) return;
      setState(() {
        _isLoading = false;
        _suggestions = [];
      });
      _updateOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 8,
            shadowColor: const Color(0x1F101B3A),
            borderRadius: BorderRadius.circular(YatraRadii.card),
            color: YatraColors.surfaceCream,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 240),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(YatraRadii.card),
                border: Border.all(color: YatraColors.softBorder),
              ),
              child: _buildOverlayContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: YatraColors.terracotta),
            ),
            SizedBox(width: 12),
            Text(
              'Searching stops across Delhi...',
              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: YatraColors.inkSecondary),
            ),
          ],
        ),
      );
    }

    if (_suggestions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: YatraColors.inkMuted),
            SizedBox(width: 8),
            Text(
              'No matching stops found',
              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: YatraColors.inkMuted),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      shrinkWrap: true,
      itemCount: _suggestions.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: YatraColors.softBorder),
      itemBuilder: (context, index) {
        final stop = _suggestions[index];
        final isSelected = _selectedStop?.stopId == stop.stopId;

        return InkWell(
          onTap: () {
            setStop(stop);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: stop.isMetroStation
                        ? const Color(0xFF1E3A8A).withOpacity(0.12)
                        : YatraColors.navyDeep.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    stop.isMetroStation ? Icons.subway : Icons.directions_bus,
                    size: 16,
                    color: stop.isMetroStation ? const Color(0xFF1E3A8A) : YatraColors.navyDeep,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop.stopName,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: YatraColors.inkPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: stop.isMetroStation ? const Color(0xFFDBEAFE) : YatraColors.parchmentBg,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              stop.typeLabel,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: stop.isMetroStation ? const Color(0xFF1E40AF) : YatraColors.inkSecondary,
                              ),
                            ),
                          ),
                          if (stop.stopDesc != null && stop.stopDesc!.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                stop.stopDesc!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  color: YatraColors.inkMuted,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (stop.hasWheelchairRamp) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.accessible, size: 14, color: YatraColors.heritageGreen),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Row(
        children: [
          Icon(widget.prefixIcon, color: widget.iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onTextChanged,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: YatraColors.inkPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: YatraTypography.bodySans(color: YatraColors.inkMuted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: YatraColors.terracotta),
            )
          else if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, size: 16, color: YatraColors.inkMuted),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                setStop(null);
              },
            ),
        ],
      ),
    );
  }
}
