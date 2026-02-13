import 'package:dio/dio.dart';

import 'error_mapper.dart';
import '../models/network_response.dart';

class DefaultErrorMapper implements ErrorMapper {
  @override
  NetworkResponse mapError(Exception exception) {
    if (exception is DioException) {
      return _mapDioException(exception);
    } else {
      return NetworkResponse(message: "Unkonwn Error.!", statusCode: -1);
    }
  }

  NetworkResponse _mapDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkResponse(message: "Connection Timeout.!");

      case DioExceptionType.connectionError:
        return const NetworkResponse(message: "Connection Error");

      case DioExceptionType.badResponse:
        return _mapHttpStatusCode(dioException);

      case DioExceptionType.cancel:
        return const NetworkResponse(message: "Canclled");

      case DioExceptionType.unknown:
        return NetworkResponse(message: "Unknown Network Error.!");

      default:
        return NetworkResponse(message: "An unknown error occured.!");
    }
  }

  NetworkResponse _mapHttpStatusCode(DioException dioException) {
    final statusCode = dioException.response?.statusCode;
    final data = dioException.response?.data;

    switch (statusCode) {
      case 400:
        return NetworkResponse(
          message: "$statusCode: Bad Request",
          statusCode: statusCode,
        );
      case 401:
        return NetworkResponse(
          message: "$statusCode: Unauthorized",
          statusCode: statusCode,
        );
      case 403:
        return NetworkResponse(
          message: "$statusCode: Forbidden",
          statusCode: statusCode,
        );
      case 404:
        return NetworkResponse(
          message: "$statusCode: Not Found",
          statusCode: statusCode,
        );
      case 422:
        return NetworkResponse(
          message: "$statusCode: Unprocessable Content",
          statusCode: statusCode,
        );
      case 429:
        return NetworkResponse(
          message: "$statusCode: Too Many request",
          statusCode: statusCode,
        );
      case 500:
        return NetworkResponse(
          message: "$statusCode: Internal Server Error",
          statusCode: statusCode,
        );
      case 502:
        return NetworkResponse(
          message: "$statusCode: Bad Gatewat",
          statusCode: statusCode,
        );
      case 503:
        return NetworkResponse(
          message: "$statusCode: Service Unavailable",
          statusCode: statusCode,
        );
      default:
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return NetworkResponse(
            message: 'Client error: $statusCode',
            statusCode: statusCode,
            bodyData: data,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return NetworkResponse(
            message: 'Server error: $statusCode',
            statusCode: statusCode,
            bodyData: data,
          );
        } else {
          return NetworkResponse(
            message: 'HTTP error: $statusCode',
            statusCode: statusCode,
            bodyData: data,
          );
        }
    }
  }
}
