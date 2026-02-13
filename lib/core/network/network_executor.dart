/// Network executor is class for handling all the network calls

import 'dart:convert';

import "package:dio/dio.dart";
import 'models/network_request.dart';
import 'models/network_response.dart';
import 'connectivity/connectivity_checker.dart';
import 'errors/error_mapper.dart';

class NetworkExecutor {
  final Dio dio;
  final ErrorMapper errorMapper;
  final ConnectivityChecker connectivityChecker;

  NetworkExecutor({
    required this.dio,
    required this.connectivityChecker,
    required this.errorMapper,
  });

  Future<NetworkResponse> getRequest(NetworkRequest requestModel) async {
    try {
      if (!await connectivityChecker.isConnected) {
        return NetworkResponse(message: "Internet Connection Problem");
      }
      final Response response = await dio.get(
        requestModel.path,
        queryParameters: requestModel.queryParams,
        data: requestModel.body,
        options: Options(headers: requestModel.headers),
      );

      return NetworkResponse(
        statusCode: response.statusCode,
        bodyData: response.data,
        message: response.statusMessage ?? "No Message",
      );
    } catch (e) {
      return errorMapper.mapError(e as Exception);
    }
  }

  Future<NetworkResponse> postRequest(NetworkRequest requestModel) async {
    try {
      final Response response = await dio.post(
        requestModel.path,
        queryParameters: requestModel.queryParams,
        data: jsonEncode(requestModel.body),
        options: Options(headers: requestModel.headers),
      );

      return NetworkResponse(
        statusCode: response.statusCode,
        bodyData: response.data,
        message: response.statusMessage ?? "${response.statusCode}",
      );
    } catch (e) {
      return errorMapper.mapError(e as Exception);
    }
  }

  Future<NetworkResponse> patchRequest(NetworkRequest requestModel) async {
    try {
      final Response response = await dio.patch(
        requestModel.path,
        queryParameters: requestModel.queryParams,
        data: jsonEncode(requestModel.body),
        options: Options(headers: requestModel.headers),
      );
      return NetworkResponse(
        statusCode: response.statusCode,
        bodyData: response.data,
        message: response.statusMessage ?? "${response.statusCode}",
      );
    } catch (e) {
      return errorMapper.mapError(e as Exception);
    }
  }
}
