import 'package:interval_insights_app/common/api/api.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/models/expanded_interval_step.dart';
import 'package:interval_insights_app/common/utils/toast_helper.dart';

class AgentsApi {
  final Api _api = Api();
  Future<List<PendingActivity>> getPendingAnalysisActivities() async {
    try {
      final response = await _api.get('/agents/pending');
      if (response is List<dynamic>) {
        return PendingActivity.fromJsonList(response);
      }
      throw Exception("Invalid data format");
    } catch (e) {
      return [];
    }
  }

  Future<List<ExpandedIntervalSet>> getProposedPace(
    List<DetectedSet> structure,
  ) async {
    try {
      final response = await _api.post(
        '/agents/proposed-pace',
        body: {"structure": structure.map((st) => st.toJson()).toList()},
      );
      if (response is List<dynamic>) {
        return ExpandedIntervalSet.fromJsonList(response);
      }
      throw Exception("Invalid data format");
    } catch (e) {
      ToastHelper.showError(title: "Invalid data format");
      return [];
    }
  }

  Future<void> startCompleteAnalysis(
    int activityId,
    int stravaId,
    String notes,
    List<ExpandedIntervalSet> sets,
  ) async {
    try {
      await _api.post(
        '/agents/start-complete-analysis',
        body: {
          "activityId": activityId,
          "stravaId": stravaId,
          "notes": notes,
          "sets": sets.map((item) => item.toJson()).toList(),
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
