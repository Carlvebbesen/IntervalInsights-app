import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/activity_filter.dart';
import 'package:interval_insights_app/common/widgets/activities_filter.dart';

class FilterHeaderView extends ConsumerWidget {
  const FilterHeaderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(activityFilterProvider);
    final notifier = ref.read(activityFilterProvider.notifier);
    final hasSearch =
        filterState.search != null && filterState.search!.isNotEmpty;
    final hasDistance =
        filterState.minDistanceMeters != null &&
        filterState.minDistanceMeters! > 0;
    final hasType = filterState.trainingType != null;
    final hasActiveFilters = hasSearch || hasDistance || hasType;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
      color: Colors.white,
      child: Row(
        children: [
          const ActivitiesFilterButton(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  if (hasSearch)
                    _FilterChip(
                      label: '"${filterState.search}"',
                      icon: Icons.search,
                      onDeleted: () => notifier.setSearch(''),
                    ),

                  if (hasDistance)
                    _FilterChip(
                      label:
                          '> ${(filterState.minDistanceMeters! / 1000).toStringAsFixed(1)} km',
                      icon: Icons.straighten,
                      onDeleted: () => notifier.setMinDistance(0),
                    ),
                  if (hasType)
                    _FilterChip(
                      label: filterState.trainingType?.displayName ?? "-",
                      icon: Icons.directions_run,
                      onDeleted: () => notifier.setTrainingType(null),
                    ),

                  if (hasActiveFilters)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: TextButton(
                        onPressed: () => notifier.reset(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          textStyle: const TextStyle(fontSize: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text("Clear all"),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onDeleted;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        backgroundColor: primaryColor.withValues(alpha: 0.1),
        side: BorderSide.none,
        avatar: Icon(icon, size: 14, color: primaryColor),
        label: Text(
          label,
          style: TextStyle(
            color: primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        deleteIcon: Icon(
          Icons.close,
          size: 14,
          color: primaryColor.withValues(alpha: 0.6),
        ),
        onDeleted: onDeleted,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
