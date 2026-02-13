import 'dart:async';
import 'package:chat_app/core/services/chat_api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/core/services/chat_service.dart';
import 'package:chat_app/core/services/data_base_service.dart';
import 'chat_message_event.dart';
import 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  final String chatId;
  StreamSubscription? _messagesSubscription;

  ChatMessageBloc({required this.chatId}) : super(const ChatMessageInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<SendMessage>(_onSendMessage);
    on<MessageStatusUpdated>(_onMessageStatusUpdated);

    _startListeningToMessages();

    add(LoadMessages(chatId));
  }

  void _startListeningToMessages() {
    _messagesSubscription = DatabaseService.messagesBox.watch().listen((event) {
      add(LoadMessages(chatId));
    });
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatMessageState> emit,
  ) async {
    try {
      final messages = DatabaseService.getMessagesForChat(event.chatId);
      emit(ChatMessageLoaded(messages: messages, chatId: event.chatId));
    } catch (e) {
      emit(ChatMessageError(e.toString()));
    }
  }

  Future<void> _onMessagesUpdated(
    MessagesUpdated event,
    Emitter<ChatMessageState> emit,
  ) async {
    emit(ChatMessageLoaded(messages: event.messages, chatId: chatId));
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatMessageState> emit,
  ) async {
    try {
      final currentMessages = DatabaseService.getMessagesForChat(event.chatId);

      emit(MessageSending(messages: currentMessages, chatId: event.chatId));

      final sentMessage = await ChatService.sendMessage(
        chatId: event.chatId,
        text: event.text,
      );

      //here i will call the chat api
      final apiResponse = await ChatApiService.sendMessageToApi(
        chatId,
        event.text,
        "message-id",
        sentMessage,
      );

      if (apiResponse) {
        print("Message sent to server succesfully");
      } else {
        print("message sent failed");
      }

      final updatedMessages = DatabaseService.getMessagesForChat(event.chatId);

      emit(
        MessageSent(
          message: sentMessage,
          messages: updatedMessages,
          chatId: event.chatId,
        ),
      );

      emit(ChatMessageLoaded(messages: updatedMessages, chatId: event.chatId));
    } catch (e) {
      emit(ChatMessageError(e.toString()));
    }
  }

  Future<void> _onMessageStatusUpdated(
    MessageStatusUpdated event,
    Emitter<ChatMessageState> emit,
  ) async {
    try {
      await DatabaseService.updateMessageStatus(event.messageId, event.status);

      final messages = DatabaseService.getMessagesForChat(chatId);
      emit(ChatMessageLoaded(messages: messages, chatId: chatId));
    } catch (e) {
      emit(ChatMessageError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
