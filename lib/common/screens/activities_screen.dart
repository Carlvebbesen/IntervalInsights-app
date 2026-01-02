import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/complete_activities_controller.dart';
import 'package:interval_insights_app/common/widgets/activities_list_item.dart';
import 'package:interval_insights_app/common/widgets/filter_header_view.dart';
import 'package:interval_insights_app/common/widgets/paginated_list_view.dart';

class ActivitiesScreen extends ConsumerWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activites = ref.watch(completeActivitiesControllerProvider);
    return Column(
      children: [
        const FilterHeaderView(),
        Expanded(
          child: PaginatedListView(
            asyncData: activites,
            onLoadMore: () => ref
                .read(completeActivitiesControllerProvider.notifier)
                .loadMore(),
            onRefresh: () =>
                ref.refresh(completeActivitiesControllerProvider.future),
            itemBuilder: (context, item, index) =>
                ActivityListItem(activity: item),
          ),
        ),
      ],
    );
  }
}
