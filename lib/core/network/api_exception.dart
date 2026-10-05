import 'package:dio/dio.dart';

class ApiException<T> implements Exception {
  const ApiException({required this.message, this.statusCode, this.data});

  final String message;
  final int? statusCode;
  final T? data;

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException<T>(
          message: 'Connection timed out. Please try again.',
        );
      case DioExceptionType.connectionError:
        return ApiException<T>(message: 'No internet connection.');
      case DioExceptionType.cancel:
        return ApiException<T>(message: 'Request was cancelled.');
      case DioExceptionType.badResponse:
        final responseData = e.response?.data;
        return ApiException<T>(
          message: _messageFromResponse(e.response),
          statusCode: e.response?.statusCode,
          data: responseData is T ? responseData : null,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return ApiException<T>(message: e.message ?? 'Something went wrong.');
    }
  }

  static String _messageFromResponse(Response? response) {
    final data = response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    if (data is Map && data['error'] is String) {
      return data['error'] as String;
    }
    return 'Request failed with status ${response?.statusCode}.';
  }

  @override
  String toString() => message;
}
