import 'package:flutter/material.dart';
import 'package:interval_insights_app/common/models/expanded_interval_step.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/widgets/build_stats_badge.dart';
import 'package:interval_insights_app/common/widgets/pace_selector_view/interval_set_card.dart';
import 'package:toastification/toastification.dart';

class IntervalSetView extends StatelessWidget {
  final bool speedMode;
  final Map<int, ExpandedIntervalSet> sets;
  final List<DetectedSet> structure;

  const IntervalSetView({
    super.key,
    required this.speedMode,
    required this.structure,
    required this.sets,
  });
  @override
  Widget build(BuildContext context) {
    final setEntries = sets.entries.toList();
    final uniqueGroupCount = sets.values
        .map((s) => s.originalSetId)
        .toSet()
        .length;
    return Column(
      children: [
        for (int i = 0; i < setEntries.length; i++)
          BuildSetCard(
            hideBorder: uniqueGroupCount < 2,
            structure: structure,
            speedMode: speedMode,
            setEntries: setEntries,
            index: i,
          ),
      ],
    );
  }
}

class BuildSetCard extends StatelessWidget {
  const BuildSetCard({
    super.key,
    required this.hideBorder,
    required this.structure,
    required this.speedMode,
    required this.setEntries,
    required this.index,
  });

  final List<DetectedSet> structure;
  final bool speedMode;
  final bool hideBorder;
  final List<MapEntry<int, ExpandedIntervalSet>> setEntries;
  final int index;

  @override
  Widget build(BuildContext context) {
    final currentEntry = setEntries[index];
    final currentSet = currentEntry.value;
    final currentGroupId = currentSet.originalSetId;

    final isFirstInGroup =
        index == 0 ||
        setEntries[index - 1].value.originalSetId != currentGroupId;

    final isLastInGroup =
        index == setEntries.length - 1 ||
        setEntries[index + 1].value.originalSetId != currentGroupId;
    final intervalCard = IntervalSetCard(
      key: ValueKey(currentEntry.key),
      set: currentSet,
      structure: structure,
      setId: currentEntry.key,
      isSpeedMode: speedMode,
    );
    return Container(
      margin: EdgeInsets.only(bottom: isLastInGroup ? 12 : 0),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border(
          top: isFirstInGroup && !hideBorder
              ? const BorderSide(color: AppColors.accentStrong, width: 2)
              : BorderSide.none,
          bottom: isLastInGroup && !hideBorder
              ? const BorderSide(color: AppColors.accentStrong, width: 2)
              : BorderSide.none,
          left: !hideBorder
              ? const BorderSide(color: AppColors.accentStrong, width: 2)
              : BorderSide.none,
          right: !hideBorder
              ? const BorderSide(color: AppColors.accentStrong, width: 2)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.vertical(
          top: isFirstInGroup ? const Radius.circular(12) : Radius.zero,
          bottom: isLastInGroup ? const Radius.circular(12) : Radius.zero,
        ),
      ),
      child: isFirstInGroup && !hideBorder
          ? Column(
              spacing: 2,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2, top: 2),
                  child: Row(
                    spacing: 8,
                    children: [
                      BuildStatsBadge(
                        icon: Icons.tag,
                        spacing: 2,
                        text: currentSet.originalSetId,
                        bgColor: currentSet.setColor.toMaterialColor,
                        iconColor: currentSet.setColor.withValues(alpha: 1),
                      ),
                      if (currentSet.setRecovery != null)
                        BuildStatsBadge(
                          icon: Icons.hourglass_bottom_rounded,
                          spacing: 2,
                          text: currentSet.setRecovery.toString(),
                          bgColor: AppColors.secondary.toMaterialColor,
                          iconColor: AppColors.secondary,
                        ),
                    ],
                  ),
                ),
                intervalCard,
              ],
            )
          : intervalCard,
    );
  }
}
