import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'interceptor/auth_interceptor.dart';

import 'interceptor/logger_interceptor.dart';
import '../constants/api_constants.dart';

Dio getDioInstance() {
  BaseOptions dioOption = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: ApiConstants.connectionTimeOut,
    headers: {"content-type": "application/json"},
  );

  final Dio dio = Dio(dioOption);

  List<Interceptor> interceptors = [
    AuthInterceptor(getToken: getToken, onTokenExpired: onTokenExpired),
    LoggerInterceptor(),
    RetryInterceptor(
      dio: dio,
      retries: 2,
      retryDelays: ApiConstants.retryDelays,
    ),
    //Refresh Interceptor
  ];

  dio.interceptors.addAll(interceptors);

  return dio;
}

Future<String?> getToken() async {
  return null;
}

Future<String?> onTokenExpired() async {
  return null;
}
