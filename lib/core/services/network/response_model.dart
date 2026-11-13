class ResponseModel {
  final bool isSuccess;
  final String message;
  final dynamic body;
  final int? statusCode;
  final List<ErrorDetail>? errors;

  const ResponseModel({
    required this.isSuccess,
    required this.message,
    this.body,
    this.statusCode,
    this.errors,
  });

  /// Factory method to create ResponseModel from JSON
  factory ResponseModel.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    final res = json['res']?.toString().toLowerCase();
    final success = res == 'success' || (json['success'] == true);

    List<ErrorDetail>? errors;
    if (json['errors'] is List) {
      errors = (json['errors'] as List)
          .map((e) => ErrorDetail.fromJson(e))
          .toList();
    }

    return ResponseModel(
      isSuccess: success && (statusCode == 200 || statusCode == null),
      message: json['msg']?.toString() ??
          json['message']?.toString() ??
          (success ? 'Success' : 'Something went wrong'),
      body: json['data'],
      statusCode: statusCode,
      errors: errors,
    );
  }

  /// Convert this model back to JSON
  Map<String, dynamic> toJson() => {
    'isSuccess': isSuccess,
    'message': message,
    'data': body,
    'statusCode': statusCode,
    'errors': errors?.map((e) => e.toJson()).toList(),
  };

  /// Create a copy with updated fields
  ResponseModel copyWith({
    bool? isSuccess,
    String? message,
    dynamic body,
    int? statusCode,
    List<ErrorDetail>? errors,
  }) {
    return ResponseModel(
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      body: body ?? this.body,
      statusCode: statusCode ?? this.statusCode,
      errors: errors ?? this.errors,
    );
  }

  /// For easier debugging
  @override
  String toString() {
    return 'ResponseModel(isSuccess: $isSuccess, '
        'message: $message, '
        'statusCode: $statusCode, '
        'errors: $errors, '
        'body: $body)';
  }
}

/// Represents error detail (if any)
class ErrorDetail {
  final String? code;
  final String? message;

  const ErrorDetail({this.code, this.message});

  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      code: json['code']?.toString(),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'message': message,
  };

  @override
  String toString() => 'ErrorDetail(code: $code, message: $message)';
}
