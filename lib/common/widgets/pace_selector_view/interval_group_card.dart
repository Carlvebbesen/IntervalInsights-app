import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/proposed_pace_controller.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/models/proposed_interval_segment.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/widgets/pace_selector_view/interval_card.dart';

class IntervalGroupCard extends ConsumerWidget {
  final List<DetectedStructure> structure;
  final int groupId;
  final bool isSpeedMode;

  const IntervalGroupCard({
    super.key,
    required this.structure,
    required this.groupId,
    required this.isSpeedMode,
  });

  void _toggleExpanded(WidgetRef ref, IntervalGroup group) {
    final updatedGroup = group.copyWith(isExpanded: !group.isExpanded);
    ref
        .read(proposedPaceControllerProvider(structure).notifier)
        .updateGroup(updatedGroup);
  }

  void _updatePace(WidgetRef ref, IntervalGroup group, double newMps) {
    final clampedMps = newMps.clamp(0.2, 15.0);

    if (group.isExpanded) {
      return;
    } else {
      if (group.hasSamePace) {
        final updatedItems = group.items.map((item) {
          return item.copyWith(proposedPace: clampedMps);
        }).toList();

        ref
            .read(proposedPaceControllerProvider(structure).notifier)
            .updateGroup(group.copyWith(items: updatedItems));
      } else {
        final oldFirstPace = group.items.first.proposedPace;
        final paceChange = clampedMps - oldFirstPace;
        final updatedItems = group.items.map((item) {
          return item.copyWith(
            proposedPace: (item.proposedPace + paceChange).clamp(0.5, 12.0),
          );
        }).toList();
        ref
            .read(proposedPaceControllerProvider(structure).notifier)
            .updateGroup(group.copyWith(items: updatedItems));
      }
    }
  }

  void _updateSingleItemPace(
    WidgetRef ref,
    IntervalGroup group,
    int index,
    double newMps,
  ) {
    final clampedMps = newMps.clamp(0.5, 12.0);
    final updatedItems = List<ProposedIntervalSegment>.from(group.items);
    updatedItems[index] = updatedItems[index].copyWith(
      proposedPace: clampedMps,
    );

    ref
        .read(proposedPaceControllerProvider(structure).notifier)
        .updateGroup(group.copyWith(items: updatedItems));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(intervalGroupProvider(structure, groupId));
    if (group == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: group.isExpanded
          ? BoxDecoration(
              color: AppColors.surfaceCard.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accentStrong.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.surfaceCard.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : null,
      child: group.isExpanded
          ? _buildExpandedGroup(ref, group)
          : _buildCollapsedGroup(ref, group),
    );
  }

  Widget _buildCollapsedGroup(WidgetRef ref, IntervalGroup group) {
    final firstItem = group.items.first;
    final currentMps = firstItem.proposedPace;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (group.hasMultipleItems) _buildExpandButton(ref, group, false),
        Expanded(
          child: IntervalCard(
            restValue: group.restValue,
            rangeText: group.rangeText,
            interval: firstItem,
            currentMps: currentMps,
            isSpeedMode: isSpeedMode,
            onPaceChanged: (newMps) => _updatePace(ref, group, newMps),
            isRange: group.hasMultipleItems && !group.hasSamePace,
            minPace: group.minPace,
            maxPace: group.maxPace,
            onRangeTap: group.hasMultipleItems && !group.hasSamePace
                ? () => _toggleExpanded(ref, group)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedGroup(WidgetRef ref, IntervalGroup group) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildExpandButton(ref, group, true),
            Expanded(
              child: IntervalCard(
                restValue: group.restValue,
                rangeText: "${group.originalIndices[0] + 1}",
                interval: group.items[0],
                currentMps: group.items[0].proposedPace,
                isSpeedMode: isSpeedMode,
                onPaceChanged: (newMps) =>
                    _updateSingleItemPace(ref, group, 0, newMps),
                isRange: false,
              ),
            ),
          ],
        ),
        Column(
          children: [
            const SizedBox(height: 4),
            for (int i = 1; i < group.items.length; i++) ...[
              IntervalCard(
                restValue: group.restValue,
                rangeText: "${group.originalIndices[i] + 1}",
                interval: group.items[i],
                currentMps: group.items[i].proposedPace,
                isSpeedMode: isSpeedMode,
                onPaceChanged: (newMps) =>
                    _updateSingleItemPace(ref, group, i, newMps),
                isRange: false,
              ),
              if (i < group.items.length - 1) const SizedBox(height: 4),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildExpandButton(
    WidgetRef ref,
    IntervalGroup group,
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
        onTap: () => _toggleExpanded(ref, group),
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
