import 'package:equatable/equatable.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';

abstract class ChatMessageState extends Equatable {
  const ChatMessageState();

  @override
  List<Object?> get props => [];
}

class ChatMessageInitial extends ChatMessageState {
  const ChatMessageInitial();
}

class ChatMessageLoading extends ChatMessageState {
  const ChatMessageLoading();
}

class ChatMessageLoaded extends ChatMessageState {
  final List<MessageModel> messages;
  final String chatId;

  const ChatMessageLoaded({required this.messages, required this.chatId});

  @override
  List<Object?> get props => [messages, chatId];
}

class ChatMessageError extends ChatMessageState {
  final String message;

  const ChatMessageError(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageSending extends ChatMessageState {
  final List<MessageModel> messages;
  final String chatId;

  const MessageSending({required this.messages, required this.chatId});

  @override
  List<Object?> get props => [messages, chatId];
}

class MessageSent extends ChatMessageState {
  final MessageModel message;
  final List<MessageModel> messages;
  final String chatId;

  const MessageSent({
    required this.message,
    required this.messages,
    required this.chatId,
  });

  @override
  List<Object?> get props => [message, messages, chatId];
}
