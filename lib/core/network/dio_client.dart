import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'dio_interceptor.dart';

class DioClient {
  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: const {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.add(DioInterceptor());
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  static final DioClient _instance = DioClient._internal();

  late final Dio _dio;

  Dio get dio => _dio;

  /// Sends a GET request and unwraps the `{ message, success, data,
  /// timestamp }` envelope, turning a `success: false` body into an
  /// [ApiException] even when the HTTP status code was 2xx.
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) fromJson,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    final apiResponse = ApiResponse<T>.fromJson(
      response.data as Map<String, dynamic>,
      fromJson,
    );
    if (!apiResponse.success) {
      throw ApiException(
        message: apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Request failed.',
        statusCode: response.statusCode,
      );
    }
    return apiResponse.data as T;
  }
}
