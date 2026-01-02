import 'package:interval_insights_app/common/api/api.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';

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

  Future<void> startCompleteAnalysis(
    int activityId,
    int stravaId,
    String comment,
  ) async {
    try {
      await _api.post(
        '/agents/start-complete-analysis',
        body: {
          "activityId": activityId,
          "stravaId": stravaId,
          "userComment": comment,
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
