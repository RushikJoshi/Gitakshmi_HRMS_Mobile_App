import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gitakshmi_hrms_app/core/api/api_constants.dart';

class DioProvider {
  static Dio? _dio;

  static Dio get instance {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Origin': ApiConstants.origin,
        },
      ));

      _dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('--> HTTP REQUEST: ${options.method} ${options.uri}');
          debugPrint('Headers: ${options.headers}');
          if (options.data != null) {
            try {
              final formattedJson = const JsonEncoder.withIndent('  ').convert(options.data);
              debugPrint('Body:\n$formattedJson');
            } catch (_) {
              debugPrint('Body: ${options.data}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('<-- HTTP RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
          try {
            final formattedJson = const JsonEncoder.withIndent('  ').convert(response.data);
            debugPrint('Response Data:\n$formattedJson');
          } catch (_) {
            debugPrint('Response Data: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('<-- HTTP ERROR: ${e.response?.statusCode} ${e.requestOptions.uri}');
          debugPrint('Error Message: ${e.message}');
          if (e.response?.data != null) {
            try {
              final formattedJson = const JsonEncoder.withIndent('  ').convert(e.response!.data);
              debugPrint('Error Response:\n$formattedJson');
            } catch (_) {
              debugPrint('Error Response: ${e.response!.data}');
            }
          }
          return handler.next(e);
        },
      ));
    }
    return _dio!;
  }
}
