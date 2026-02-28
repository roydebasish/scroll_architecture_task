import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://fakestoreapi.com",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  static Future<void> init() async {
    dio.interceptors.clear();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString("token");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          if (kDebugMode) {
            debugPrint("➡️ ${options.method} ${options.path}");
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint("✅ ${response.statusCode} ${response.requestOptions.path}");
          }
          handler.next(response);
        },
        onError: (DioException error, handler) {
          if (kDebugMode) {
            debugPrint("❌ ${error.response?.statusCode} ${error.requestOptions.path}");
          }
          handler.next(error);
        },
      ),
    );
  }
}