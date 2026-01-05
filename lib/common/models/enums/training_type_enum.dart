import 'package:collection/collection.dart';

enum TrainingType {
  longRun,
  easyRun,
  normalRun,
  shortIntervals,
  hillSprints,
  longIntervals,
  sprints,
  fartlek,
  progressiveLongRun,
  race,
  tempo,
  other;

  /// Converts the enum to the string format required by the database/API
  String get apiValue {
    return switch (this) {
      TrainingType.longRun => 'LONG_RUN',
      TrainingType.easyRun => 'EASY_RUN',
      TrainingType.normalRun => 'NORMAL_RUN',
      TrainingType.shortIntervals => 'SHORT_INTERVALS',
      TrainingType.hillSprints => 'HILL_SPRINTS',
      TrainingType.longIntervals => 'LONG_INTERVALS',
      TrainingType.sprints => 'SPRINTS',
      TrainingType.fartlek => 'FARTLEK',
      TrainingType.progressiveLongRun => 'PROGRESSIVE_LONG_RUN',
      TrainingType.race => 'RACE',
      TrainingType.tempo => 'TEMPO',
      TrainingType.other => 'OTHER',
    };
  }

  /// specific helper for UI display (optional)
  String get displayName {
    return switch (this) {
      TrainingType.longRun => 'Long Run',
      TrainingType.easyRun => 'Easy Run',
      TrainingType.normalRun => 'Normal Run',
      TrainingType.shortIntervals => 'Short Intervals',
      TrainingType.hillSprints => 'Hill Sprints',
      TrainingType.longIntervals => 'Long Intervals',
      TrainingType.sprints => 'Sprints',
      TrainingType.fartlek => 'Fartlek',
      TrainingType.progressiveLongRun => 'Progressive Long Run',
      TrainingType.race => 'Race',
      TrainingType.tempo => 'Tempo',
      TrainingType.other => 'Other',
    };
  }

  bool get isIntervalType {
    return switch (this) {
      TrainingType.shortIntervals ||
      TrainingType.longIntervals ||
      TrainingType.sprints ||
      TrainingType.hillSprints ||
      TrainingType.fartlek ||
      TrainingType.progressiveLongRun => true,

      _ => false,
    };
  }

  static TrainingType? fromApiValue(String value) {
    return TrainingType.values.firstWhereOrNull((e) => e.apiValue == value);
  }

  static TrainingType fromString(String value) {
    return TrainingType.values.firstWhere((e) => e.apiValue == value);
  }
}
