/// Generic API response wrapper.
///
/// Standardizes response handling across the app.
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode ?? 200,
    );
  }

  factory ApiResponse.error({String? message, int? statusCode}) {
    return ApiResponse(
      success: false,
      message: message ?? 'An error occurred',
      statusCode: statusCode,
    );
  }
}
