import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/auth_controller.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/widgets/app_button.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _DashboardHeader(),
              AppButton(
                label: "logout",
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signOut(),
              ),
              const SizedBox(height: 24),
              const _WeeklyComparisonCard(),
              const SizedBox(height: 24),
              const _TrainingLoadCard(),
              const SizedBox(height: 24),
              const _RecentActivityCard(),
              const SizedBox(height: 24),
              const _IntervalTypesCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.vanillaCustard, AppColors.deepTwilight],
          ).createShader(bounds),
          child: const Text(
            'Interval Insights',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Required for ShaderMask
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your training analytics hub',
          style: TextStyle(color: Colors.grey[500], fontSize: 16),
        ),
      ],
    );
  }
}

class _WeeklyComparisonCard extends StatelessWidget {
  const _WeeklyComparisonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Comparison',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              Icon(Icons.list, color: AppColors.vanillaCustard, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Text(
                '66.5 km',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.vanillaCustard,
                ),
              ),
              SizedBox(width: 12),
              Text(
                '60.3 km',
                style: TextStyle(fontSize: 24, color: AppColors.textSecondary),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '+10.3%',
                  style: TextStyle(
                    color: AppColors.vanillaCustard,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: Color(0xFF064E3B), // Dark Green
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide.none,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        if (value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  // Mock data pairs (Current Week vs Last Week)
                  _makeGroup(0, 8, 5),
                  _makeGroup(1, 5, 8),
                  _makeGroup(2, 10, 7),
                  _makeGroup(3, 6, 5),
                  _makeGroup(4, 12, 9),
                  _makeGroup(5, 15, 13),
                  _makeGroup(6, 8, 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: AppColors.vanillaCustard,
          width: 8,
          borderRadius: BorderRadius.circular(2),
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.grey[700],
          width: 8,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }
}

class _TrainingLoadCard extends StatelessWidget {
  const _TrainingLoadCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Training Load',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                children: [
                  // Simple representation of the gauge using CircularProgressIndicator
                  const Center(
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: 0.67,
                        strokeWidth: 12,
                        backgroundColor: Color(0xFF1E293B),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.petalFrost,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '67',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.petalFrost,
                          ),
                        ),
                        Text(
                          'Load Score',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
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

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.list, color: AppColors.tangerineDream, size: 20),
              SizedBox(width: 8),
              Text(
                'Recent Activity Insights',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildItem(
            'Morning Tempo Run',
            'Today',
            'Felt strong in final 3 intervals',
            '168 avg',
          ),
          const SizedBox(height: 12),
          _buildItem(
            'Long Run - Easy Pace',
            'Yesterday',
            'Good recovery, low effort',
            '142 avg',
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String date, String insight, String hr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            insight,
            style: const TextStyle(color: AppColors.petalFrost, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.petalFrost,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                hr,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntervalTypesCard extends StatelessWidget {
  const _IntervalTypesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.list, color: AppColors.skyBlueLight, size: 20),
              SizedBox(width: 8),
              Text(
                'Common Interval Types',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTypeRow('Tempo', '12 runs', AppColors.petalFrost, [
            3,
            5,
            4,
            7,
            6,
            8,
            9,
          ]),
          const SizedBox(height: 16),
          _buildTypeRow('VO2 Max', '8 runs', AppColors.tangerineDream, [
            2,
            3,
            5,
            4,
            6,
            5,
            7,
          ]),
          const SizedBox(height: 16),
          _buildTypeRow('Easy', '18 runs', AppColors.vanillaCustard, [
            8,
            9,
            10,
            8,
            11,
            10,
            12,
          ]),
        ],
      ),
    );
  }

  Widget _buildTypeRow(
    String type,
    String count,
    Color color,
    List<double> data,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type, style: const TextStyle(fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 30,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: color,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
