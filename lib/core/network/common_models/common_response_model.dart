class CommonResponseModel<T> {
  final int httpStatus;
  final T? data;
  final String status;
  final String message;

  CommonResponseModel({
    required this.httpStatus,
    this.data,
    required this.status,
    required this.message,
  });

  factory CommonResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return CommonResponseModel<T>(
      httpStatus: json['http_status'] ?? 0,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      status: json['status'] ?? "",
      message: json['message'] ?? "",
    );
  }
}
