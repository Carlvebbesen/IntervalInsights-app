import 'package:flutter/material.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/widgets/pace_selector_view/interval_group_card.dart';

class IntervalGroupView extends StatelessWidget {
  final bool speedMode;
  final List<int> groupIds;
  final List<DetectedStructure> structure;

  const IntervalGroupView({
    super.key,
    required this.speedMode,
    required this.structure,
    required this.groupIds,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final groupId in groupIds)
          IntervalGroupCard(
            key: ValueKey(groupId),
            structure: structure,
            groupId: groupId,
            isSpeedMode: speedMode,
          ),
      ],
    );
  }
}
