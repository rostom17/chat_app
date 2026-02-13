import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/core/services/chat_service.dart';
import 'package:chat_app/core/services/data_base_service.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  StreamSubscription? _chatsSubscription;

  ChatListBloc() : super(const ChatListInitial()) {
    on<LoadChats>(_onLoadChats);
    on<ChatsUpdated>(_onChatsUpdated);
    on<CreateChat>(_onCreateChat);
    on<DeleteChat>(_onDeleteChat);
    on<MarkChatAsRead>(_onMarkChatAsRead);

    // Listen to Hive box changes
    _startListeningToChats();
  }

  void _startListeningToChats() {
    _chatsSubscription = DatabaseService.chatsBox.watch().listen((event) {
      // When data changes in Hive, reload chats
      add(LoadChats());
    });
  }

  Future<void> _onLoadChats(
    LoadChats event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      final chats = DatabaseService.getAllChats();
      emit(ChatListLoaded(chats));
    } catch (e) {
      emit(ChatListError(e.toString()));
    }
  }

  Future<void> _onChatsUpdated(
    ChatsUpdated event,
    Emitter<ChatListState> emit,
  ) async {
    emit(ChatListLoaded(event.chats));
  }

  Future<void> _onCreateChat(
    CreateChat event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      final chat = await ChatService.createChat(
        name: event.name,
        profilePicture: event.profilePicture,
      );

      // Emit created state temporarily, then load all chats
      emit(ChatCreated(chat));

      // Load updated list
      final chats = DatabaseService.getAllChats();
      emit(ChatListLoaded(chats));
    } catch (e) {
      emit(ChatListError(e.toString()));
    }
  }

  Future<void> _onDeleteChat(
    DeleteChat event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      await DatabaseService.deleteChat(event.chatId);

      // Emit deleted state temporarily
      emit(ChatDeleted(event.chatId));

      // Load updated list
      final chats = DatabaseService.getAllChats();
      emit(ChatListLoaded(chats));
    } catch (e) {
      emit(ChatListError(e.toString()));
    }
  }

  Future<void> _onMarkChatAsRead(
    MarkChatAsRead event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      await DatabaseService.markChatAsRead(event.chatId);

      // Load updated list
      final chats = DatabaseService.getAllChats();
      emit(ChatListLoaded(chats));
    } catch (e) {
      emit(ChatListError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }
}
