import 'package:interval_insights_app/common/models/enums/training_type_enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_filter.g.dart';

// 1. The State Class
class ActivityFilterState {
  final String? search;
  final TrainingType? trainingType;
  final double? minDistanceMeters;

  const ActivityFilterState({
    this.search,
    this.trainingType,
    this.minDistanceMeters,
  });

  // Helper for empty state
  factory ActivityFilterState.initial() => const ActivityFilterState();

  // CopyWith for immutability
  ActivityFilterState copyWith({
    String? search,
    TrainingType? trainingType,
    double? minDistanceMeters,
    bool forceNullType = false, // Helper to clear type
  }) {
    return ActivityFilterState(
      search: search ?? this.search,
      trainingType: forceNullType ? null : (trainingType ?? this.trainingType),
      minDistanceMeters: minDistanceMeters ?? this.minDistanceMeters,
    );
  }
}

// 2. The Provider
@riverpod
class ActivityFilter extends _$ActivityFilter {
  @override
  ActivityFilterState build() {
    return ActivityFilterState.initial();
  }

  void setSearch(String query) {
    state = state.copyWith(search: query);
  }

  void setTrainingType(TrainingType? type) {
    // If passing null, we need to explicitly clear it
    if (type == null) {
      state = state.copyWith(forceNullType: true);
    } else {
      state = state.copyWith(trainingType: type);
    }
  }

  void setMinDistance(double meters) {
    state = state.copyWith(minDistanceMeters: meters);
  }

  void reset() {
    state = ActivityFilterState.initial();
  }

  // Bulk update (useful for "Apply" buttons in modals)
  void applyAll({
    String? search,
    TrainingType? trainingType,
    double? minDistance,
  }) {
    state = ActivityFilterState(
      search: search,
      trainingType: trainingType,
      minDistanceMeters: minDistance,
    );
  }
}
