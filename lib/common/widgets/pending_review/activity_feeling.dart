import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/pending_activities_controller.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';

class ActivityFeeling extends ConsumerStatefulWidget {
  const ActivityFeeling(
    this.initFeeling, {
    super.key,
    required this.activityId,
  });

  final int? initFeeling;
  final int activityId;
  @override
  ConsumerState<ActivityFeeling> createState() => _ActivityFeelingState();
}

class _ActivityFeelingState extends ConsumerState<ActivityFeeling> {
  int? _feelingScore;

  @override
  void initState() {
    super.initState();
    _feelingScore = widget.initFeeling;
  }

  String _getFeelingLabel(int score) {
    switch (score) {
      case 1:
        return "Bad";
      case 2:
        return "Poor";
      case 3:
        return "Normal";
      case 4:
        return "Good";
      case 5:
        return "Great";
      default:
        return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Feeling",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              _getFeelingLabel(_feelingScore ?? 0),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.accentStrong,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            final int value = index + 1;
            final bool isSelected = _feelingScore == value;

            return InkWell(
              onTap: () {
                setState(() {
                  _feelingScore = value;
                });
                ref
                    .read(pendingActivitiesControllerProvider.notifier)
                    .updateFeeling(widget.activityId, value);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentStrong
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accentStrong
                        : Colors.grey.shade300,
                  ),
                ),
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Bad", style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text("Great", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
