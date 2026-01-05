import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/proposed_pace_controller.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/models/expanded_interval_step.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/widgets/pace_selector_view/interval_card.dart';

class IntervalSetCard extends ConsumerWidget {
  final List<DetectedSet> structure;
  final int setId;
  final ExpandedIntervalSet set;
  final bool isSpeedMode;

  const IntervalSetCard({
    super.key,
    required this.structure,
    required this.set,
    required this.setId,
    required this.isSpeedMode,
  });

  void _toggleExpanded(WidgetRef ref) {
    final updatedSet = set.copyWith(expanded: !set.expanded);
    ref
        .read(proposedPaceControllerProvider(structure).notifier)
        .updateSet(setId, updatedSet);
  }

  void _updatePace(WidgetRef ref, double newMps) {
    final clampedMps = newMps.clamp(0.2, 15.0);
    if (set.expanded) {
      return;
    } else {
      if (set.hasSamePace) {
        final updatedSteps = set.steps.map((item) {
          return item.copyWith(targetPace: clampedMps);
        }).toList();

        ref
            .read(proposedPaceControllerProvider(structure).notifier)
            .updateSet(setId, set.copyWith(steps: updatedSteps));
      } else {
        final oldFirstPace = set.steps.first.targetPace;
        final paceChange = clampedMps - oldFirstPace;
        final updatedSteps = set.steps.map((item) {
          return item.copyWith(
            targetPace: (item.targetPace + paceChange).clamp(0.5, 12.0),
          );
        }).toList();
        ref
            .read(proposedPaceControllerProvider(structure).notifier)
            .updateSet(setId, set.copyWith(steps: updatedSteps));
      }
    }
  }

  void _updateSingleItemPace(WidgetRef ref, int index, double newMps) {
    final clampedMps = newMps.clamp(0.5, 12.0);
    final updatedSteps = List<ExpandedIntervalStep>.from(set.steps);
    updatedSteps[index] = updatedSteps[index].copyWith(targetPace: clampedMps);
    ref
        .read(proposedPaceControllerProvider(structure).notifier)
        .updateSet(setId, set.copyWith(steps: updatedSteps));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: set.expanded
          ? BoxDecoration(
              color: set.setColor.withValues(alpha: .3),
              boxShadow: [
                BoxShadow(
                  color: set.setColor.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : null,
      child: set.expanded
          ? _buildExpandedSet(ref, set)
          : _buildCollapsedSet(ref, set),
    );
  }

  Widget _buildCollapsedSet(WidgetRef ref, ExpandedIntervalSet set) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (set.hasMultipleItems) _buildExpandButton(ref, set, false),
        Expanded(
          child: IntervalCard(
            rangeText: set.rangeText,
            interval: set.steps.first,
            isSpeedMode: isSpeedMode,
            onPaceChanged: (newMps) => _updatePace(ref, newMps),
            isRange: set.hasMultipleItems && !set.hasSamePace,
            minPace: set.minPace,
            maxPace: set.maxPace,
            onRangeTap: set.hasMultipleItems && !set.hasSamePace
                ? () => _toggleExpanded(ref)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedSet(WidgetRef ref, ExpandedIntervalSet set) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildExpandButton(ref, set, true),
            Expanded(
              child: IntervalCard(
                rangeText: "${set.originalIndices[0] + 1}",
                interval: set.steps[0],
                isSpeedMode: isSpeedMode,
                onPaceChanged: (newMps) =>
                    _updateSingleItemPace(ref, 0, newMps),
                isRange: false,
              ),
            ),
          ],
        ),
        Column(
          children: [
            const SizedBox(height: 4),
            for (int i = 1; i < set.steps.length; i++) ...[
              IntervalCard(
                rangeText: "${set.originalIndices[i] + 1}",
                interval: set.steps[i],
                isSpeedMode: isSpeedMode,
                onPaceChanged: (newMps) =>
                    _updateSingleItemPace(ref, i, newMps),
                isRange: false,
              ),
              if (i < set.steps.length - 1) const SizedBox(height: 4),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildExpandButton(
    WidgetRef ref,
    ExpandedIntervalSet set,
    bool isExpanded,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isExpanded ? AppColors.accent : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isExpanded ? AppColors.accentStrong : AppColors.accent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _toggleExpanded(ref),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            isExpanded ? Icons.unfold_less : Icons.unfold_more,
            size: 20,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
