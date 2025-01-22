import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart';
import 'package:hospital_app/views/login.dart';

class DioClient {
  // Singleton instance
  static final DioClient _instance = DioClient._internal();

  // Dio instance
  late Dio _dio;

  // Private constructor
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://qp-backend.techbias.in/api/v1',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.httpClientAdapter = createAdapter();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint("REQUEST [${options.method}] => PATH: ${options.path}");
          debugPrint("Request Headers: ${options.headers}");
          debugPrint("Request Data: ${options.data}");
          return handler.next(options); // Continue
        },
        onResponse: (response, handler) {
          // debugPrint(
          //     "RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}");
          // debugPrint("Response Data: ${jsonEncode(response.data)}");
          return handler.next(response); // Continue
        },
        onError: (DioError error, handler) {
          if (error.response?.statusCode == 401) {
            print("Reachd erher");
            // Navigate to login screen on 401
            Get.snackbar("Unauthorized", "Please login to proceed");
            Get.to(LoginScreen());
          }
          debugPrint(
              "ERROR [${error.response?.statusCode}] => PATH: ${error.requestOptions.path}");
          debugPrint("Error Data: ${error.response?.data}");
          return handler.next(error); // Continue
        },
      ),
    );
  }

  HttpClientAdapter createAdapter() {
    final adapter = IOHttpClientAdapter();
    adapter.onHttpClientCreate = (client) {
      // Ignore SSL certificate errors
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
    return adapter;
  }

  static Dio get dio => _instance._dio;
}
