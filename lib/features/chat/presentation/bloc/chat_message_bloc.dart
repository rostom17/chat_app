import 'dart:async';
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

    // Listen to Hive box changes
    _startListeningToMessages();

    // Load initial messages
    add(LoadMessages(chatId));
  }

  void _startListeningToMessages() {
    _messagesSubscription = DatabaseService.messagesBox.watch().listen((event) {
      // When data changes in Hive, reload messages for this chat
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
      // Get current messages
      final currentMessages = DatabaseService.getMessagesForChat(event.chatId);

      // Emit sending state
      emit(MessageSending(messages: currentMessages, chatId: event.chatId));

      // Send the message
      final sentMessage = await ChatService.sendMessage(
        chatId: event.chatId,
        text: event.text,
      );

      // Get updated messages
      final updatedMessages = DatabaseService.getMessagesForChat(event.chatId);

      // Emit sent state
      emit(
        MessageSent(
          message: sentMessage,
          messages: updatedMessages,
          chatId: event.chatId,
        ),
      );

      // Then emit loaded state with all messages
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

      // Load updated messages
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
