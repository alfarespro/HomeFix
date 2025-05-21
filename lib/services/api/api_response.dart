// lib/services/api/api_response.dart
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ApiResponse({required this.success, this.data, this.error});

  factory ApiResponse.success(T data) {
    return ApiResponse(success: true, data: data);
  }

  factory ApiResponse.error(String error) {
    return ApiResponse(success: false, error: error);
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data is List
          ? (data as List)
              .map((e) => e is Map ? e : (e as dynamic).toJson())
              .toList()
          : (data is Map ? data : (data as dynamic)?.toJson()),
      'error': error,
    };
  }
}
