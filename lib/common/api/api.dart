import 'package:dio/dio.dart';
import 'package:interval_insights_app/common/api/auth_interceptor.dart';

class Api {
  // Singleton pattern
  Api._private() {
    _dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'BACKEND_URL',
        ), // Set this in your --dart-define
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // --- UPDATED SECTION ---
    _dio.interceptors.addAll([
      // Add your custom Auth Interceptor
      AuthInterceptor(),

      // Keep your logger for debugging
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
    // -----------------------
  }

  static final Api _instance = Api._private();
  factory Api() => _instance;

  late final Dio _dio;
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic PATCH request
  Future<dynamic> patch(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.patch(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Standardized Error Handling
  Exception _handleError(DioException e) {
    // You can customize this to return your own Domain Exceptions
    if (e.response != null) {
      return Exception(
        "API Error: ${e.response?.statusCode} - ${e.response?.data}",
      );
    } else {
      return Exception("Network Error: ${e.message}");
    }
  }
}
