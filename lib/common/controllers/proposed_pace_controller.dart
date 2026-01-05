import 'dart:async';
import 'package:collection/collection.dart';
import 'package:interval_insights_app/common/api/agents_api.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/models/proposed_interval_segment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'proposed_pace_controller.g.dart';

@riverpod
class ProposedPaceController extends _$ProposedPaceController {
  @override
  Future<Map<int, IntervalGroup>> build(
    List<DetectedStructure> structure,
  ) async {
    if (structure.isEmpty) {
      return <int, IntervalGroup>{};
    }

    final link = ref.keepAlive();
    final disposalTimer = Timer(const Duration(minutes: 5), () => link.close());
    ref.onDispose(() => disposalTimer.cancel());

    final rawIntervals = await AgentsApi().getProposedPace(structure);
    final groupsMap = _groupIntervals(rawIntervals, structure);

    return groupsMap;
  }

  void updateGroup(IntervalGroup updatedGroup) {
    final currentState = state.value;
    if (currentState == null) return;

    final groups = currentState;
    final updatedGroups = Map<int, IntervalGroup>.from(groups);
    updatedGroups[updatedGroup.groupId] = updatedGroup;

    state = AsyncData((updatedGroups));
  }

  Map<int, IntervalGroup> _groupIntervals(
    List<ProposedIntervalSegment> intervals,
    List<DetectedStructure> structure,
  ) {
    if (intervals.isEmpty) return {};

    final Map<int, IntervalGroup> groups = {};
    List<ProposedIntervalSegment> currentGroupItems = [];
    List<int> currentIndices = [];
    int groupId = 1;

    for (int i = 0; i < intervals.length; i++) {
      final segment = intervals[i];

      bool shouldStartNewGroup =
          currentGroupItems.isEmpty ||
          currentGroupItems.length >= 5 ||
          currentGroupItems.last.unit != segment.unit ||
          (currentGroupItems.last.targetValue - segment.targetValue).abs() >
              0.01;

      if (shouldStartNewGroup && currentGroupItems.isNotEmpty) {
        groups[groupId] = IntervalGroup(
          restValue: structure
              .firstWhereOrNull((item) => item.workValue == segment.targetValue)
              ?.recoveryValue,
          groupId: groupId,
          items: List.from(currentGroupItems),
          originalIndices: List.from(currentIndices),
        );
        groupId++;
        currentGroupItems.clear();
        currentIndices.clear();
      }

      currentGroupItems.add(segment);
      currentIndices.add(i);
    }
    if (currentGroupItems.isNotEmpty) {
      groups[groupId] = IntervalGroup(
        restValue: structure
            .firstWhereOrNull(
              (item) => item.workValue == currentGroupItems.first.targetValue,
            )
            ?.recoveryValue,
        groupId: groupId,
        items: List.from(currentGroupItems),
        originalIndices: List.from(currentIndices),
      );
    }

    return groups;
  }
}

@riverpod
IntervalGroup? intervalGroup(
  Ref ref,
  List<DetectedStructure> structure,
  int groupId,
) {
  final paceState = ref.watch(proposedPaceControllerProvider(structure));
  return paceState.value?[groupId];
}
