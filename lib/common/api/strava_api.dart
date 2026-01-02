import 'package:interval_insights_app/common/api/api.dart';
import 'package:interval_insights_app/common/models/strava_subscription.dart';
import 'package:interval_insights_app/common/models/summary_activity.dart';
import 'package:interval_insights_app/common/models/sync_result.dart';

class StravaService {
  final Api _api = Api();

  Future<String> getAuthUrl() async {
    try {
      final response = await _api.get('strava/auth/url');
      if (response != null && response['url'] != null) {
        return response['url'] as String;
      } else {
        throw Exception("Invalid response structure from backend");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 2. Exchange the authorization code for tokens
  /// Endpoint: POST /auth/exchange
  Future<void> exchangeCode(String code) async {
    try {
      final response = await _api.post(
        'strava/auth/exchange',
        body: {'code': code},
      );

      // Assuming backend returns: { "success": true, "user": { ... } }
      if (response['success'] == true) {
        // You might want to save the user data locally or update state here
        print("Successfully authenticated: ${response['user']}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> debugStartSubscription() async {
    try {
      return await _api.get('strava/webhook/subscribe');
    } catch (e) {
      return e;
    }
  }

  /// Fetch current webhook subscriptions
  Future<List<StravaSubscription>> getSubscription() async {
    try {
      final response = await _api.get('strava/webhook/subscription');

      return StravaSubscription.fromList(response as List<dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a specific subscription
  Future<void> deleteSubscription(String id) async {
    try {
      await _api.delete('strava/webhook/subscription/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SummaryActivity>> getPotentialSyncActivities({
    int page = 1,
    int perPage = 30,
  }) async {
    try {
      final response = await _api.get(
        '/strava/sync/activities',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      if (response is List<dynamic>) {
        return SummaryActivity.fromList(response);
      }
      throw Exception("Unknown data type");
    } catch (e) {
      throw Exception('Failed to fetch activities');
    }
  }

  Future<List<SyncResult>> syncActivites(Iterable<int> ids) async {
    try {
      final response = await _api.post(
        '/strava/sync/activities',
        body: {"ids": ids.toList()},
      );
      if (response is List<dynamic>) {
        return SyncResult.fromList(response);
      }
      throw Exception("Unknown data type");
    } catch (e) {
      throw Exception('Failed to fetch activities');
    }
  }

  Future<dynamic> testHandshake() async {
    try {
      return await _api.get('strava/event');
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> testEvent() async {
    try {
      return await _api.post('strava/event', body: {"id": "Halla"});
    } catch (e) {
      return e;
    }
  }
}
