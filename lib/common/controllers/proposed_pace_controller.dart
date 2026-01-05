import 'dart:async';
import 'package:collection/collection.dart';
import 'package:interval_insights_app/common/api/agents_api.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/models/expanded_interval_step.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'proposed_pace_controller.g.dart';

@riverpod
class ProposedPaceController extends _$ProposedPaceController {
  @override
  Future<Map<int, ExpandedIntervalSet>> build(
    List<DetectedSet> structure,
  ) async {
    if (structure.isEmpty) {
      return <int, ExpandedIntervalSet>{};
    }

    final link = ref.keepAlive();
    final disposalTimer = Timer(const Duration(minutes: 5), () => link.close());
    ref.onDispose(() => disposalTimer.cancel());

    final rawSets = await AgentsApi().getProposedPace(structure);
    return _processAndGroupSets(rawSets);
  }

  Map<int, ExpandedIntervalSet> _processAndGroupSets(
    List<ExpandedIntervalSet> rawSets,
  ) {
    final Map<int, ExpandedIntervalSet> groupedMap = {};
    final totalIntervals = rawSets.fold<int>(
      0,
      (sum, set) => sum + set.steps.length,
    );
    int globalGroupId = 0;

    int dynamicChunkSize = 5;
    if (totalIntervals <= 12 && totalIntervals > 0) {
      dynamicChunkSize = (totalIntervals / 3).ceil();
      if (dynamicChunkSize < 3) dynamicChunkSize = 2;
    }
    for (var originalSet in rawSets) {
      if (originalSet.steps.length <= dynamicChunkSize) {
        groupedMap[globalGroupId] = originalSet;
        globalGroupId++;
      } else {
        final stepChunks = _chunkList(originalSet.steps, dynamicChunkSize);
        final indexChunks = _chunkList(
          originalSet.originalIndices,
          dynamicChunkSize,
        );

        for (int i = 0; i < stepChunks.length; i++) {
          groupedMap[globalGroupId] = ExpandedIntervalSet(
            originalSetId: originalSet.originalSetId,
            setColor: originalSet.setColor,
            steps: stepChunks[i],
            originalIndices: indexChunks[i],
            setRecovery: originalSet.setRecovery,
          );
          globalGroupId++;
        }
      }
    }
    return groupedMap;
  }

  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }

  void updateSet(int setId, ExpandedIntervalSet updatedSet) {
    final currentState = state.value;
    if (currentState == null) return;

    final updatedMap = Map<int, ExpandedIntervalSet>.from(currentState);
    updatedMap[setId] = updatedSet;
    state = AsyncData(updatedMap);
  }

  List<ExpandedIntervalSet> getFinalizedStructure() {
    final currentMap = state.value;
    if (currentMap == null) return [];

    final List<ExpandedIntervalSet> mergedSets = [];
    final Map<String, List<ExpandedIntervalSet>> groupedById =
        groupBy<ExpandedIntervalSet, String>(
          currentMap.values,
          (set) => set.originalSetId,
        );
    for (var entry in groupedById.entries) {
      final chunks = entry.value;
      mergedSets.add(
        ExpandedIntervalSet(
          originalSetId: entry.key,
          originalIndices: [],
          setColor: chunks.first.setColor,
          steps: chunks.expand((c) => c.steps).toList(),
          setRecovery: chunks.last.setRecovery,
        ),
      );
    }
    return mergedSets;
  }
}
