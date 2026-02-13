import 'package:chat_app/core/constants/api_constants.dart';
import 'package:chat_app/core/network/connectivity/connectivity_checker.dart';
import 'package:chat_app/core/network/errors/default_error_mapper.dart';
import 'package:chat_app/core/network/models/network_request.dart';
import 'package:chat_app/core/network/models/network_response.dart';
import 'package:chat_app/core/network/network_executor.dart';
import 'package:chat_app/core/network/setup_dio.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';

class ChatApiService {
  static final netwrokExecutor = NetworkExecutor(
    dio: getDioInstance(),
    connectivityChecker: ConnectivityChecker(),
    errorMapper: DefaultErrorMapper(),
  );

  static Future<bool> sendMessageToApi(
    String chatId,
    String text,
    String messageId,
    MessageModel sentMessage,
  ) async {
    final NetworkResponse response = await netwrokExecutor.postRequest(
      NetworkRequest(path: ApiConstants.productEndPoint, body: {}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      //sent success message
      return true;
    } else {
      //sent failure message
      return false;
    }
  }
}
