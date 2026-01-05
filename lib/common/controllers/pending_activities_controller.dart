import 'dart:async';

import 'package:interval_insights_app/common/api/activities_api.dart';
import 'package:interval_insights_app/common/api/agents_api.dart';
import 'package:interval_insights_app/common/controllers/proposed_pace_controller.dart';
import 'package:interval_insights_app/common/models/enums/training_type_enum.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/models/proposed_interval_segment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_activities_controller.g.dart';

@riverpod
class PendingActivitiesController extends _$PendingActivitiesController {
  @override
  FutureOr<List<PendingActivity>> build() async {
    final link = ref.keepAlive();
    final disposalTimer = Timer(const Duration(minutes: 5), () => link.close());
    ref.onDispose(() {
      disposalTimer.cancel();
    });

    final pending = await AgentsApi().getPendingAnalysisActivities();
    return pending;
  }

  void changeTrainingType(int activityId) {
    final currentList = state.value;
    if (currentList == null) return;
    final newList = currentList.map((activity) {
      if (activity.id == activityId) {
        return activity.copyWith(isOnAnalyzeStep: false);
      }
      return activity;
    }).toList();
    state = AsyncData(newList);
  }

  Future<void> updateTrainingType(int activityId, TrainingType type) async {
    await ActivitiesApi().update(activityId, trainingType: type);
    final currentList = state.value;
    if (currentList == null) return;
    final newList = currentList.map((activity) {
      if (activity.id == activityId) {
        return activity.copyWith(isOnAnalyzeStep: true, trainingType: type);
      }
      return activity;
    }).toList();
    state = AsyncData(newList);
  }

  Future<void> updateFeeling(int activityId, int feeling) async {
    ActivitiesApi().update(activityId, feeling: feeling);
    final currentList = state.value;
    if (currentList == null) return;
    final newList = currentList.map((activity) {
      if (activity.id == activityId) {
        return activity.copyWith(feeling: feeling);
      }
      return activity;
    }).toList();
    state = AsyncData(newList);
  }

  Future<void> markAsCompleted(
    int activityId,
    int stravaId,
    String notes,
    List<DetectedStructure> structure,
  ) async {
    final groups = ref.read(proposedPaceControllerProvider(structure)).value;
    await AgentsApi().startCompleteAnalysis(
      activityId,
      stravaId,
      notes,
      groups?.values.toList() ?? [],
    );
    final currentList = state.value;
    if (currentList == null) return;
    final newList = currentList.map((activity) {
      if (activity.id == activityId) {
        return activity.copyWith(isCompleted: true, notes: notes);
      }
      return activity;
    }).toList();
    state = AsyncData(newList);
  }
}
