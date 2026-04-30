class ErrorDataModel {
  int? httpStatus;
  dynamic data;
  String? status;
  String? message;
  Errors? errors;

  ErrorDataModel({
    this.httpStatus,
    this.data,
    this.status,
    this.message,
    this.errors,
  });

  ErrorDataModel.fromJson(Map<String, dynamic> json) {
    httpStatus = json['http_status'];
    data = json['data'];
    final rawStatus = json['status'];
    status = rawStatus == null ? null : rawStatus.toString();

    final rawMessage = json['message'];
    if (rawMessage == null) {
      message = null;
    } else if (rawMessage is String) {
      message = rawMessage;
    } else {
      // API sometimes returns a Map/List instead of string
      message = rawMessage.toString();
    }
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['http_status'] = httpStatus;
    data['data'] = this.data;
    data['status'] = status;
    data['message'] = message;
    if (errors != null) {
      data['errors'] = errors!.toJson();
    }
    return data;
  }
}

class Errors {
  String? error;

  Errors({this.error});

  Errors.fromJson(Map<String, dynamic> json) {
    final raw = json['error'];
    error = raw == null ? null : raw.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    return data;
  }
}
