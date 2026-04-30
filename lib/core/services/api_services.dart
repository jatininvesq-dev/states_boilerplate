import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:states_app/core/network/error_handling/interceptors.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class ApiService {
  final Dio _dio = Dio();

  //
  /// BaseUrl getter
  String get serverUrl => dotenv.env['SERVER_URL']!;

  // ignore: non_constant_identifier_names
  ApiService() {
    _dio.options.baseUrl = serverUrl;
    _dio.options.headers = {
      "accept": "application/json",
    }; //new contenttype
    _dio.interceptors.addAll([
      /// It is used to catch error while requesting to server.
      ErrorInterceptor(),

      /// It is used to add an authenticate while request an api.
      AuthInterceptor(),

      /// It is used to send information related to user(OS Version, App version) etc.
      UserAgentInterceptor(),
    ]);
    if (kDebugMode) {
      _dio.interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
            printResponseMessage: true,
            printResponseData: true,
            printRequestData: true,
          ),
          // settings: const TalkerDioLoggerSettings(),
        ),
      );
    }
  }

  Future<Either<String, Response>> get(
    //Response<dynamic>?
    String path, {
    Map<String, String>? headers,
    CancelToken? cancelToken,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Fluttertoast.showToast(msg: "Please check your internet");
      return const Left("No internet connection");
    }
    try {
      final res = await _dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      // print(res.data);
      // print(res);
      return Right(res);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('ApiService.get DioException: $e');
      }
      if (e.error != null) {
        return Left(e.error.toString());
      }
      final code = e.response?.statusCode;
      if (code != null) {
        return Left(code.toString());
      }
      return Left(e.message ?? 'Request failed');
    }
  }

  Future<Either<String, Response>> post(
    String path,
    dynamic data, {
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Fluttertoast.showToast(msg: "Please check your internet");
      return const Left("No internet connection");
    }
    try {
      Options finalOptions = options ?? Options();
      if (data is FormData) {
        final headers = Map<String, dynamic>.from(_dio.options.headers);
        headers.addAll(Map<String, dynamic>.from(finalOptions.headers ?? {}));
        headers['Content-Type'] = Headers.multipartFormDataContentType;
        finalOptions = Options(
          headers: headers,
          contentType: Headers.multipartFormDataContentType,
          method: finalOptions.method,
          responseType: finalOptions.responseType,
          followRedirects: finalOptions.followRedirects,
          validateStatus: finalOptions.validateStatus,
          receiveTimeout: finalOptions.receiveTimeout,
          sendTimeout: finalOptions.sendTimeout,
          extra: finalOptions.extra,
        );
      }

      final res = await _dio.post(
        path,
        data: data,
        cancelToken: cancelToken,
        options: finalOptions,
      );
      // print("Data of user");
      // print(res.statusCode);
      if (res.statusCode == 401) {
        return const Left("Unauthenticated");
      }
      return Right(res);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData != null) {
        print("This is service Err$responseData");
      } else {
        print("This is service Err without response");
      }

      if (e.error != null) {
        return Left(e.error.toString());
      }
      if (e.response?.statusCode != null) {
        return Left(e.response!.statusCode.toString());
      }
      return Left('Request failed');
    }
  }

  Future<Either<String, Response>> put(
    //Response<dynamic>?
    String path,
    dynamic data, {
    Map<String, String>? headers,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Fluttertoast.showToast(msg: "Please check your internet");
      return const Left("No internet connection");
    }
    try {
      Options finalOptions = options ?? Options();
      if (data is FormData) {
        final headers = Map<String, dynamic>.from(_dio.options.headers);
        headers.addAll(Map<String, dynamic>.from(finalOptions.headers ?? {}));
        headers['Content-Type'] = Headers.multipartFormDataContentType;
        finalOptions = Options(
          headers: headers,
          contentType: Headers.multipartFormDataContentType,
          method: finalOptions.method,
          responseType: finalOptions.responseType,
          followRedirects: finalOptions.followRedirects,
          validateStatus: finalOptions.validateStatus,
          receiveTimeout: finalOptions.receiveTimeout,
          sendTimeout: finalOptions.sendTimeout,
          extra: finalOptions.extra,
        );
      }
      final res = await _dio.put(
        path,
        data: data,
        cancelToken: cancelToken,
        options: finalOptions,
      );
      return Right(res);
    } on DioException catch (e) {
      // print("This is error $e");
      // // return Left(e.error.toString());

      // if (e.response != null) {
      //   // print("This isss ---");
      //   return Left(e.response!.data['messageTranslation']['label'].toString());
      // } else if (e.error != null) {
      //   print("This isss");
      //   return Left(e.error.toString());
      // }
      // return Left(e.response!.statusCode!.toString());
      // return Left(e.response!.statusCode!.toString());
      return Left(e.error.toString());
    }
    /*  on DioException catch (e) {
      print("This is error ${e.error}");
      print("This is error ${e.message}");
      print("This is error ${e.response}");
      if (kDebugMode) {
        print(e);
      }
      return Left(e.error.toString());
    }*/
  }

  // Future<Response<dynamic>?> delete(
  Future<Either<String, Response>> delete(
    String path, {
    Map<String, String>? headers,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      // return _dio.delete(path, cancelToken: cancelToken, options: options);
      final res = await _dio.delete(
        path,
        cancelToken: cancelToken,
        options: options,
      );
      return Right(res);
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Left(e.error.toString());
      // return null;
    }
  }
}
