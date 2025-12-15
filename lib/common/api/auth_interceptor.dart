import 'package:dio/dio.dart';
import 'package:interval_insights_app/common/controllers/auth_controller.dart';
// Import your ClerkInstance file here

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // 1. Fetch the token from your ClerkInstance
      // We await it because getting a token is an asynchronous operation
      final sessionToken = await ClerkInstance().getToken;

      // 2. Extract the JWT string
      // CHECK THIS: specific property depends on your Clerk package version.
      // It is often .jwt, .token, or the object itself if it's a String.
      final String token = sessionToken.jwt;

      // 3. Add the Authorization Header if the token exists
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      // 4. Continue with the request
      return handler.next(options);
    } catch (e) {
      // Optional: Handle token fetch errors (e.g., user is offline or signed out)
      print("AuthInterceptor: Failed to get token - $e");

      // Continue without token; the backend will likely return 401
      return handler.next(options);
    }
  }
}
