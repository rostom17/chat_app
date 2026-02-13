import 'package:equatable/equatable.dart';
import 'package:chat_app/features/chat/data/models/chat_model.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object?> get props => [];
}

class ChatListInitial extends ChatListState {
  const ChatListInitial();
}

class ChatListLoading extends ChatListState {
  const ChatListLoading();
}

class ChatListLoaded extends ChatListState {
  final List<ChatModel> chats;

  const ChatListLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatListError extends ChatListState {
  final String message;

  const ChatListError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatCreated extends ChatListState {
  final ChatModel chat;

  const ChatCreated(this.chat);

  @override
  List<Object?> get props => [chat];
}

class ChatDeleted extends ChatListState {
  final String chatId;

  const ChatDeleted(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
