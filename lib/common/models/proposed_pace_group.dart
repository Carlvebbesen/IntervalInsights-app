// ignore: constant_identifier_names
enum WorkType { DISTANCE, TIME }

class WorkoutBlock {
  final int reps;
  final WorkType workType;
  final double workValue;

  WorkoutBlock({
    required this.reps,
    required this.workType,
    required this.workValue,
  });
}

class PaceGroup {
  final String title;
  final List<int> originalIndices;
  double? proposedPaceSeconds;
  double? selectedPaceSeconds;

  PaceGroup({
    required this.title,
    required this.originalIndices,
    this.proposedPaceSeconds,
    this.selectedPaceSeconds,
  });
}

class IntervalGrouper {
  static List<PaceGroup> groupIntervals(
    List<WorkoutBlock> blocks,
    Map<String, double>? proposedPaces,
  ) {
    List<PaceGroup> groups = [];
    int globalIndex = 0;
    List<_TempSegment> flatSegments = [];
    for (var block in blocks) {
      for (var i = 0; i < block.reps; i++) {
        flatSegments.add(
          _TempSegment(
            originalIndex: globalIndex++,
            val: block.workValue,
            type: block.workType,
          ),
        );
      }
    }
    Map<String, List<_TempSegment>> buckets = {};

    for (var seg in flatSegments) {
      String key = _generateKey(seg);
      buckets.putIfAbsent(key, () => []).add(seg);
    }

    buckets.forEach((key, segments) {
      double? proposed = proposedPaces?[key];

      if (segments.length <= 10) {
        groups.add(
          PaceGroup(
            title: "${segments.length} x $key",
            originalIndices: segments.map((s) => s.originalIndex).toList(),
            proposedPaceSeconds: proposed,
            selectedPaceSeconds: proposed,
          ),
        );
      } else {
        int chunkSize = 5;
        for (var i = 0; i < segments.length; i += chunkSize) {
          int end = (i + chunkSize < segments.length)
              ? i + chunkSize
              : segments.length;
          var chunk = segments.sublist(i, end);

          groups.add(
            PaceGroup(
              title: "${chunk.length} x $key (Reps ${i + 1}-$end)",
              originalIndices: chunk.map((s) => s.originalIndex).toList(),
              proposedPaceSeconds: proposed,
              selectedPaceSeconds: proposed,
            ),
          );
        }
      }
    });
    groups.sort(
      (a, b) => a.originalIndices.first.compareTo(b.originalIndices.first),
    );

    return groups;
  }

  static String _generateKey(_TempSegment seg) {
    if (seg.type == WorkType.DISTANCE) {
      return "${seg.val.toInt()}m";
    } else {
      return "${seg.val.toInt()}s";
    }
  }
}

class _TempSegment {
  final int originalIndex;
  final double val;
  final WorkType type;
  _TempSegment({
    required this.originalIndex,
    required this.val,
    required this.type,
  });
}
