import 'package:flutter/material.dart';

import 'package:interval_insights_app/common/models/proposed_pace_group.dart';

class PaceSelectorView extends StatefulWidget {
  final List<WorkoutBlock> structure;
  final Map<String, double>? proposedPaces; // from your API
  final Function(Map<int, double>)
  onSave; // Returns Map<SegmentIndex, PaceInMetersPerSecond>

  const PaceSelectorView({
    super.key,
    required this.structure,
    this.proposedPaces,
    required this.onSave,
  });

  @override
  _PaceSelectorViewState createState() => _PaceSelectorViewState();
}

class _PaceSelectorViewState extends State<PaceSelectorView> {
  late List<PaceGroup> _groups;
  bool _isSpeedMode = false; // false = min/km, true = km/h

  @override
  void initState() {
    super.initState();
    // Initialize groups using our logic class
    _groups = IntervalGrouper.groupIntervals(
      widget.structure,
      widget.proposedPaces,
    );
  }

  // --- Conversion Helpers ---

  String _formatPace(double mps) {
    if (_isSpeedMode) {
      // m/s to km/h
      double kmh = mps * 3.6;
      return "${kmh.toStringAsFixed(1)} km/h";
    } else {
      // m/s to min/km
      if (mps == 0) return "-:--";
      double minPerKm = (1000 / mps) / 60;
      int mins = minPerKm.floor();
      int secs = ((minPerKm - mins) * 60).round();
      return "$mins:${secs.toString().padLeft(2, '0')} /km";
    }
  }

  void _adjustPace(PaceGroup group, int direction) {
    setState(() {
      // If no pace selected yet, start at reasonable defaults
      double currentMps = group.selectedPaceSeconds ?? 3.33; // ~5:00/km default

      if (_isSpeedMode) {
        // Adjust by 0.1 km/h
        double currentKmh = currentMps * 3.6;
        double newKmh = currentKmh + (direction * 0.1);
        group.selectedPaceSeconds = newKmh / 3.6;
      } else {
        // Adjust by 5 seconds per km
        // Convert to seconds per km
        double currentSecPerKm = 1000 / currentMps;
        double newSecPerKm =
            currentSecPerKm -
            (direction * 5); // Minus direction means faster (less time)
        if (newSecPerKm < 60) newSecPerKm = 60; // Cap at 1 min/km
        group.selectedPaceSeconds = 1000 / newSecPerKm;
      }
    });
  }

  void _submit() {
    Map<int, double> result = {};
    for (var group in _groups) {
      if (group.selectedPaceSeconds != null) {
        for (var idx in group.originalIndices) {
          result[idx] = group.selectedPaceSeconds!;
        }
      }
    }
    widget.onSave(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ToggleButtons(
              isSelected: [!_isSpeedMode, _isSpeedMode],
              onPressed: (index) {
                setState(() {
                  _isSpeedMode = index == 1;
                });
              },
              borderRadius: BorderRadius.circular(8),
              constraints: const BoxConstraints(minHeight: 30, minWidth: 60),
              children: const [Text("Pace"), Text("Speed")],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16), // Padding moved here
          child: Column(
            // Ensure items stretch or start correctly based on your design
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < _groups.length; i++) ...[
                _buildGroupCard(_groups[i]),
                // Only add the separator if this is NOT the last item
                if (i < _groups.length - 1) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildGroupCard(PaceGroup group) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (group.proposedPaceSeconds != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Suggested: ${_formatPace(group.proposedPaceSeconds!)}",
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleButton(
                icon: Icons.remove,
                onTap: () => _adjustPace(group, -1),
              ),
              Container(
                width: 140,
                alignment: Alignment.center,
                child: Text(
                  group.selectedPaceSeconds != null
                      ? _formatPace(group.selectedPaceSeconds!)
                      : "Select",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Monospace', // Helps digits align
                  ),
                ),
              ),
              _circleButton(
                icon: Icons.add,
                onTap: () => _adjustPace(group, 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.grey.shade100,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Save Analysis",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
