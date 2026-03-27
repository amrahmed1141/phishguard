import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class _LoggingInterceptor extends Interceptor {
  void _log(String message) {
    developer.log(message, name: 'Dio');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log('→ ${options.method} ${options.uri}');
    _log('  headers: ${options.headers}');
    if (options.data != null) {
      _log('  body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log('← ${response.statusCode} ${response.requestOptions.uri}');
    _log('  data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log('✕ ${err.requestOptions.method} ${err.requestOptions.uri}');
    _log('  type: ${err.type}  message: ${err.message}');
    if (err.response != null) {
      _log(
        '  status: ${err.response?.statusCode}  data: ${err.response?.data}',
      );
    }
    handler.next(err);
  }
}

class DioClient {
  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: const {
          'Content-Type': 'application/json',
        },
      ),
    );
    _dio.interceptors.add(_LoggingInterceptor());
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
