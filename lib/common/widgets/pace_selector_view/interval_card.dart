import 'package:flutter/material.dart';
import 'package:interval_insights_app/common/models/proposed_interval_segment.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/widgets/activities_filter.dart';
import 'package:interval_insights_app/common/widgets/build_stats_badge.dart';
import 'package:toastification/toastification.dart';

class IntervalCard extends StatelessWidget {
  final String rangeText;
  final ProposedIntervalSegment interval;
  final num? restValue;
  final double currentMps;
  final bool isSpeedMode;
  final ValueChanged<double> onPaceChanged;
  final bool isRange;
  final double? minPace;
  final double? maxPace;
  final VoidCallback? onRangeTap;

  const IntervalCard({
    super.key,
    required this.rangeText,
    required this.restValue,
    required this.interval,
    required this.currentMps,
    required this.isSpeedMode,
    required this.onPaceChanged,
    this.isRange = false,
    this.minPace,
    this.maxPace,
    this.onRangeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: 4,
            children: [
              BuildStatsBadge(
                icon: Icons.tag,
                spacing: 2,
                text: rangeText,
                bgColor: AppColors.accentStrong.toMaterialColor,
                iconColor: AppColors.accentStrong,
              ),
              BuildStatsBadge(
                icon: Icons.directions_run,
                spacing: 2,
                text:
                    "${interval.targetValue.toInt()} ${interval.unit.name.capitalize()}",
                color: Colors.green[900] ?? Colors.green,
                bgColor: Colors.green,
                iconColor: Colors.green,
              ),
              BuildStatsBadge(
                icon: Icons.hourglass_bottom_rounded,
                spacing: 2,
                text:
                    "${restValue?.toInt() ?? "-"} ${interval.unit.name.capitalize()}",
                color: AppColors.secondary,
                bgColor: AppColors.secondary.toMaterialColor,
                iconColor: AppColors.secondary,
              ),
            ],
          ),
          Row(
            children: [
              ControlButton(
                icon: Icons.remove,
                color: Colors.red,
                onTap: () => _adjustByStep(-0.1),
              ),
              Expanded(
                child: isRange
                    ? RangePaceDisplay(
                        minPace: minPace ?? currentMps,
                        maxPace: maxPace ?? currentMps,
                        isSpeedMode: isSpeedMode,
                        onTap: onRangeTap,
                      )
                    : PaceInputField(
                        mps: currentMps,
                        isSpeedMode: isSpeedMode,
                        onChanged: onPaceChanged,
                      ),
              ),
              ControlButton(
                icon: Icons.add,
                color: Colors.blue,
                onTap: () => _adjustByStep(0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _adjustByStep(double kmhDelta) {
    double currentKmh = currentMps * 3.6;
    onPaceChanged((currentKmh + kmhDelta) / 3.6);
  }
}

class RangePaceDisplay extends StatelessWidget {
  final double minPace;
  final double maxPace;
  final bool isSpeedMode;
  final VoidCallback? onTap;

  const RangePaceDisplay({
    super.key,
    required this.minPace,
    required this.maxPace,
    required this.isSpeedMode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final minDisplay = isSpeedMode
        ? "${(minPace * 3.6).toStringAsFixed(1)} km/h"
        : "${PaceFormatter.formatRawPace(minPace)} /km";
    final maxDisplay = isSpeedMode
        ? "${(maxPace * 3.6).toStringAsFixed(1)} km/h"
        : "${PaceFormatter.formatRawPace(maxPace)} /km";

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              minDisplay,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Monospace',
              ),
            ),
            const Text(
              " - ",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              maxDisplay,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Monospace',
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.expand_more, size: 16, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}

class PaceInputField extends StatefulWidget {
  final double mps;
  final bool isSpeedMode;
  final ValueChanged<double> onChanged;

  const PaceInputField({
    super.key,
    required this.mps,
    required this.isSpeedMode,
    required this.onChanged,
  });

  @override
  State<PaceInputField> createState() => _PaceInputFieldState();
}

class _PaceInputFieldState extends State<PaceInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _displayValue);
  }

  String get _displayValue => widget.isSpeedMode
      ? (widget.mps * 3.6).toStringAsFixed(1)
      : PaceFormatter.formatRawPace(widget.mps);

  @override
  void didUpdateWidget(PaceInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mps != widget.mps ||
        oldWidget.isSpeedMode != widget.isSpeedMode) {
      _controller.text = _displayValue;
    }
  }

  void _handleSubmitted(String val) {
    if (widget.isSpeedMode) {
      final kmh = double.tryParse(val) ?? (widget.mps * 3.6);
      widget.onChanged(kmh / 3.6);
    } else {
      // Optional: Add MM:SS parsing here
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        fontFamily: 'Monospace',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        border: InputBorder.none,
        suffixText: widget.isSpeedMode ? " km/h" : " /km",
        suffixStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.normal,
        ),
      ),
      onSubmitted: _handleSubmitted,
    );
  }
}

class ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ControlButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

class PaceFormatter {
  static String format(double mps, bool isSpeedMode) {
    if (isSpeedMode) return "${(mps * 3.6).toStringAsFixed(1)} km/h";
    return "${formatRawPace(mps)} /km";
  }

  static String formatRawPace(double mps) {
    if (mps <= 0) return "-:--";
    double minPerKm = (1000 / mps) / 60;
    int mins = minPerKm.floor();
    int secs = ((minPerKm - mins) * 60).round();
    if (secs == 60) {
      mins++;
      secs = 0;
    }
    return "$mins:${secs.toString().padLeft(2, '0')}";
  }
}
