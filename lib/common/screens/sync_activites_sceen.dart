import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/api/strava_api.dart';
import 'package:interval_insights_app/common/controllers/strava_activities_controller.dart';
import 'package:interval_insights_app/common/widgets/app_button.dart';
import 'package:interval_insights_app/common/widgets/app_list_tile.dart';
import 'package:interval_insights_app/common/widgets/custom_modal.dart';
import 'package:interval_insights_app/common/widgets/paginated_list_view.dart';
import 'package:interval_insights_app/common/widgets/strava_activity_tile.dart';

class SyncActivitesSceen extends ConsumerStatefulWidget {
  const SyncActivitesSceen({super.key});

  @override
  ConsumerState<SyncActivitesSceen> createState() => _SyncActivitesSceenState();
}

class _SyncActivitesSceenState extends ConsumerState<SyncActivitesSceen> {
  Map<int, bool> selected = {};
  Map<int, bool> synced = {};
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final activitiesData = ref.watch(stravaActivitiesControllerProvider);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "How to Sync",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.blue.shade900, height: 1.4),
                    children: const [
                      TextSpan(text: "Select Strava activities"),
                      TextSpan(
                        text: "to begin the synchronization.",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text:
                            "Select the activities you want to import, then press the button to sync. ( Max 10 activities at a time) They will then be saved as activities in the app.",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PaginatedListView(
              asyncData: activitiesData,
              onLoadMore: () => ref
                  .read(stravaActivitiesControllerProvider.notifier)
                  .loadMore(),
              itemBuilder: (context, data, index) {
                if (synced[data.id] == true) {
                  return const SizedBox.shrink();
                }
                return StravaActivityTile(
                  activity: data,
                  isSelected: selected[data.id] == true,
                  onTap: () {
                    final current = selected;
                    final currentValue = current[data.id] ?? false;
                    setState(() {
                      selected = {...current, data.id: !currentValue};
                    });
                  },
                );
              },
            ),
          ),
          AppButton(
            label: "Sync Activities",
            isLoading: isLoading,
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              final data = await StravaService().syncActivites(
                selected.entries
                    .where((entry) => entry.value == true)
                    .map((entry) => entry.key),
              );
              if (context.mounted) {
                setState(() {
                  isLoading = false;
                  final current = selected;
                  selected = {
                    for (var synced in data) synced.id: !synced.isSuccess,
                  };
                  synced = {
                    ...current,
                    for (var synced in data) synced.id: synced.isSuccess,
                  };
                });
                CustomModal.show(
                  context,
                  true,
                  title: "Sync result:",
                  child: Column(
                    children: [
                      AppListTile(
                        title: "Successfull sync:",
                        subtitle: Text(
                          "Count: ${data.where((sync) => sync.isSuccess).length}",
                        ),
                      ),
                      AppListTile(
                        title: "Unsuccessfull sync:",
                        subtitle: Column(
                          spacing: 5,
                          children: [
                            Text(
                              "Count: ${data.where((sync) => !sync.isSuccess).length}",
                            ),
                            if (data
                                .where((sync) => !sync.isSuccess)
                                .isNotEmpty)
                              Text(
                                "Reason ${data.where((sync) => !sync.isSuccess).first.status.toString()}",
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            disabled:
                selected.isEmpty ||
                selected.values.where((v) => v == true).length > 10,
          ),
        ],
      ),
    );
  }
}
