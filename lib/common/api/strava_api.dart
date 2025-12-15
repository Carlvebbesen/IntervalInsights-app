import 'package:interval_insights_app/common/api/api.dart';

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
}
