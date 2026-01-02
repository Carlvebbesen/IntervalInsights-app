import 'package:flutter/material.dart';
import 'package:interval_insights_app/common/models/summary_activity.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/widgets/app_list_tile.dart';

class StravaActivityTile extends StatelessWidget {
  final SummaryActivity activity;
  final bool isSelected;
  final VoidCallback? onTap;

  const StravaActivityTile({
    super.key,
    required this.activity,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final distanceKm = (activity.distance / 1000).toStringAsFixed(2);
    final dateStr =
        "${activity.startDateLocal.day}.${activity.startDateLocal.month}.${activity.startDateLocal.year}";

    return AppListTile(
      isSelected: isSelected,
      onTap: onTap,
      title: activity.name,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getSportColor(activity.sportType).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.directions_run,
          color: _getSportColor(activity.sportType),
          size: 20,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$dateStr • $distanceKm km"),
          if (activity.averageHeartrate != null)
            Text(
              "Avg HR: ${activity.averageHeartrate?.toInt()} bpm",
              style: const TextStyle(fontSize: 12, color: Colors.redAccent),
            ),
        ],
      ),
      trailing: Icon(
        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isSelected ? AppColors.primary : null,
      ),
    );
  }

  Color _getSportColor(String type) =>
      type == 'Run' ? Colors.orange : Colors.blue;
}
