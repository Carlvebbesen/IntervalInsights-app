import 'dart:async';

import 'package:interval_insights_app/common/api/strava_api.dart';
import 'package:interval_insights_app/common/models/summary_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'strava_activities_controller.g.dart';

@riverpod
class StravaActivitiesController extends _$StravaActivitiesController {
  static const int _perPage = 20;
  int? _page;
  bool _hasReachedMax = false;
  @override
  FutureOr<List<SummaryActivity>> build() async {
    // Cache the data for 5 min
    final link = ref.keepAlive();
    final disposalTimer = Timer(const Duration(minutes: 5), () => link.close());
    ref.onDispose(() {
      disposalTimer.cancel();
    });

    final activities = await StravaService().getPotentialSyncActivities(
      page: 1,
    );
    _page = 1;
    _hasReachedMax = activities.length < _perPage;

    return activities;
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || _hasReachedMax) {
      return;
    }
    try {
      final nextPage = (_page ?? 0) + 1;
      final newActivities = await StravaService().getPotentialSyncActivities(
        page: nextPage,
      );
      _page = nextPage;
      _hasReachedMax = newActivities.length < _perPage;
      state = AsyncData([...currentState, ...newActivities]);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
