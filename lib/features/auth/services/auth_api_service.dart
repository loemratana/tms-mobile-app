import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/dio_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/user.dart';

/// Sends HTTP requests to the `/auth/*` endpoints.
///
/// This class only talks to the backend. It does not store anything.
/// Every failure is thrown as an [ApiException].
class AuthApiService {
  AuthApiService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  final Dio _dio;

  Future<LoginResponse> login(LoginRequest request) async {
    final data = await _post(ApiConstants.login, request.toJson());
    return LoginResponse.fromJson(data);
  }

  Future<UserModel> register(RegisterRequest request) async {
    final data = await _post(ApiConstants.register, request.toJson());
    return UserModel.fromJson(data);
  }

  Future<UserModel> getCurrentUser() async {
    final data = await _get(ApiConstants.me);
    return UserModel.fromJson(data);
  }

  Future<void> logout() async {
    await _post(ApiConstants.logout);
  }

  Future<void> forgotPassword(String email) async {
    await _post(ApiConstants.forgotPassword, {'email': email});
  }

  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    await _post(ApiConstants.resetPassword, {
      'token': token,
      'password': password,
      'confirmPassword': confirmPassword,
    });
  }

  Future<void> verifyEmail(String code) async {
    await _post(ApiConstants.verifyEmail, {'code': code});
  }

  Future<dynamic> _get(String path) {
    return _send(() => _dio.get(path));
  }

  Future<dynamic> _post(String path, [Map<String, dynamic>? body]) {
    return _send(() => _dio.post(path, data: body));
  }

  /// Sends the request and returns the `data` field of the
  /// `{ message, success, data, timestamp }` envelope.
  Future<dynamic> _send(Future<Response> Function() request) async {
    try {
      final response = await request();
      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json,
      );

      // The backend can answer HTTP 200 with `success: false`.
      if (!apiResponse.success) {
        throw ApiException(
          message: apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Request failed.',
          statusCode: response.statusCode,
        );
      }
      return apiResponse.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final authApiServiceProvider = Provider<AuthApiService>(
  (ref) => AuthApiService(),
);
