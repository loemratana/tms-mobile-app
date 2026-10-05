/// Wraps the envelope every API response is returned in:
/// `{ message, success, data, timestamp }`.
class ApiResponse<T> {
  final String message;
  final bool success;
  final T? data;
  final DateTime? timestamp;

  const ApiResponse({
    required this.message,
    required this.success,
    this.data,
    this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse(
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String)
          : null,
    );
  }
}
