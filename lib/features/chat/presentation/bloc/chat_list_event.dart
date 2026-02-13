import 'package:equatable/equatable.dart';
import 'package:chat_app/features/chat/data/models/chat_model.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

class LoadChats extends ChatListEvent {
  const LoadChats();
}

class ChatsUpdated extends ChatListEvent {
  final List<ChatModel> chats;

  const ChatsUpdated(this.chats);

  @override
  List<Object?> get props => [chats];
}

class CreateChat extends ChatListEvent {
  final String name;
  final String profilePicture;

  const CreateChat({required this.name, required this.profilePicture});

  @override
  List<Object?> get props => [name, profilePicture];
}

class DeleteChat extends ChatListEvent {
  final String chatId;

  const DeleteChat(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class MarkChatAsRead extends ChatListEvent {
  final String chatId;

  const MarkChatAsRead(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
