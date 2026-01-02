import 'dart:async';

import 'package:interval_insights_app/common/api/activities_api.dart';
import 'package:interval_insights_app/common/controllers/activity_filter.dart';
import 'package:interval_insights_app/common/models/complete_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'complete_activities_controller.g.dart';

@riverpod
class CompleteActivitiesController extends _$CompleteActivitiesController {
  int _page = 1;
  bool _isLastPage = false;

  @override
  FutureOr<List<CompleteActivity>> build() async {
    // 1. WATCH the filter provider
    // Any change to ActivityFilter will cause this build method to re-run immediately.
    final filter = ref.watch(activityFilterProvider);

    // Keep alive logic
    final link = ref.keepAlive();
    final timer = Timer(const Duration(minutes: 5), () => link.close());
    ref.onDispose(() => timer.cancel());

    _page = 1;
    _isLastPage = false;

    // 2. Use the filter values in the API call
    final response = await ActivitiesApi().getActivities(
      page: _page,
      search: filter.search,
      trainingType: filter.trainingType,
      minDistanceMeters: filter.minDistanceMeters,
    );
    if (response.data.length < response.pageSize) {
      _isLastPage = true;
    }

    return response.data;
  }

  Future<void> loadMore() async {
    if (state.isLoading || _isLastPage || !state.hasValue) return;
    final filter = ref.read(activityFilterProvider);

    try {
      final nextPage = _page + 1;
      final response = await ActivitiesApi().getActivities(
        page: nextPage,
        search: filter.search,
        trainingType: filter.trainingType,
        minDistanceMeters: filter.minDistanceMeters,
      );
      if (response.data.isEmpty) {
        _isLastPage = true;
        state = AsyncData(state.value!);
        return;
      }

      _page = nextPage;
      if (response.data.length < response.pageSize) {
        _isLastPage = true;
      }
      final currentList = state.value!;
      state = AsyncData([...currentList, ...response.data]);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
