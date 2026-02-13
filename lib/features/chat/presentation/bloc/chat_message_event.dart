import 'package:equatable/equatable.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';

abstract class ChatMessageEvent extends Equatable {
  const ChatMessageEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatMessageEvent {
  final String chatId;

  const LoadMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class MessagesUpdated extends ChatMessageEvent {
  final List<MessageModel> messages;

  const MessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}

class SendMessage extends ChatMessageEvent {
  final String chatId;
  final String text;

  const SendMessage({required this.chatId, required this.text});

  @override
  List<Object?> get props => [chatId, text];
}

class MessageStatusUpdated extends ChatMessageEvent {
  final String messageId;
  final String status;

  const MessageStatusUpdated({required this.messageId, required this.status});

  @override
  List<Object?> get props => [messageId, status];
}
