import 'package:collection/collection.dart';

enum IntervalUnit {
  m,
  km,
  sec,
  min;

  static IntervalUnit fromString(String value) {
    return IntervalUnit.values.firstWhere(
      (e) => e.name.toLowerCase() == value,
      orElse: () => IntervalUnit.m,
    );
  }
}

enum WorkType {
  distance,
  time;

  static WorkType fromString(String value) {
    return WorkType.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => WorkType.distance,
    );
  }

  static WorkType? fromStringOrnull(String? value) {
    return WorkType.values.firstWhereOrNull(
      (e) => e.name.toUpperCase() == value?.toUpperCase(),
    );
  }
}
