import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/pending_activities_controller.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/widgets/custom_modal.dart';
import 'package:interval_insights_app/common/widgets/pending_review/pending_review_tab_bar.dart';

class PendingReviewActionButton extends ConsumerWidget {
  const PendingReviewActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingActivitiesControllerProvider);

    return pendingAsync.when(
      data: (activities) {
        final pendingCount = activities.where((a) => !a.isCompleted).length;
        if (pendingCount == 0) return const SizedBox.shrink();
        return FloatingActionButton(
          backgroundColor: AppColors.accent,
          onPressed: () {
            CustomModal.show(
              context,
              true,
              useRootListView: false,
              title: 'Review Activities',
              child: const PendingReviewTabBar(),
              minChildSize: 0.4,
            );
          },
          child: Badge(
            label: Text(
              '$pendingCount',
              style: const TextStyle(color: Colors.white),
            ),
            child: const Icon(Icons.analytics_outlined, color: Colors.white),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
