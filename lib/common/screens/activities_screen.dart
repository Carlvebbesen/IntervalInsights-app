import 'package:flutter/material.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      _ActivityData(
        1,
        'Morning Interval Session',
        'Tempo',
        '10.2 km',
        '4:15 /km',
        'Today',
        false,
      ),
      _ActivityData(
        2,
        'Long Run - Easy Pace',
        'Easy',
        '18.5 km',
        '5:20 /km',
        'Yesterday',
        true,
      ),
      _ActivityData(
        3,
        'Track Workout - 400m Repeats',
        'VO2 Max',
        '8.0 km',
        '3:45 /km',
        '2 days ago',
        false,
      ),
      _ActivityData(
        4,
        'Recovery Run',
        'Easy',
        '6.5 km',
        '5:45 /km',
        '3 days ago',
        true,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _ActivitiesHeader(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: activities.length,
                separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) => _ActivityCard(data: activities[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivitiesHeader extends StatelessWidget {
  const _ActivitiesHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withOpacity(0.8),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activities',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search activities...',
              filled: true,
              fillColor: const Color(0xFF1F2937).withOpacity(0.5),
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: const Icon(Icons.filter, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 16),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip('All Runs', true),
                _FilterChip('Tempo', false),
                _FilterChip('Long Run', false),
                _FilterChip('VO2 Max', false),
                _FilterChip('Context Needed', false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _FilterChip(this.label, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.vanillaCustard.withOpacity(0.2)
              : const Color(0xFF1F2937).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.vanillaCustard.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected
                ? AppColors.vanillaCustard
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final _ActivityData data;
  const _ActivityCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map Placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Center(
              child: Icon(Icons.map, color: AppColors.vanillaCustard),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              data.type,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: !data.hasContext
                          ? AppColors.vanillaCustard
                          : Colors.grey[600],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoCol('Distance', data.distance),
                    _InfoCol('Pace', data.pace),
                    const _InfoCol('Time', '43:24'), // Mock time
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (!data.hasContext)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.petalFrost.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 6,
                              color: AppColors.petalFrost,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Add context',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.petalFrost,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCol extends StatelessWidget {
  final String label;
  final String val;
  const _InfoCol(this.label, this.val);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          val,
          style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _ActivityData {
  final int id;
  final String title;
  final String type;
  final String distance;
  final String pace;
  final String date;
  final bool hasContext;
  _ActivityData(
    this.id,
    this.title,
    this.type,
    this.distance,
    this.pace,
    this.date,
    this.hasContext,
  );
}
