import 'package:flutter/material.dart';
import 'package:interval_insights_app/common/models/complete_activity.dart';

import 'package:interval_insights_app/common/widgets/app_list_tile.dart';

class ActivityListItem extends StatelessWidget {
  final CompleteActivity activity;
  final VoidCallback? onTap;
  final bool isSelected;

  const ActivityListItem({
    super.key,
    required this.activity,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final distanceKm = (activity.distance / 1000).toStringAsFixed(1);

    return AppListTile(
      title: activity.title,
      onTap: onTap,
      isSelected: isSelected,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _getIconForSport(activity.sportType),
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                "${activity.startDateLocal.year}-${activity.startDateLocal.month.toString().padLeft(2, '0')}-${activity.startDateLocal.day.toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(width: 6),
              const Text(
                "•",
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              const SizedBox(width: 6),
              Text(
                "$distanceKm km",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                activity.trainingType.displayName,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatDuration(activity.movingTime),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  IconData _getIconForSport(String? type) {
    if (type == null) return Icons.fitness_center;
    switch (type.toLowerCase()) {
      case 'run':
        return Icons.directions_run;
      case 'ride':
        return Icons.directions_bike;
      case 'swim':
        return Icons.pool;
      default:
        return Icons.fitness_center;
    }
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
