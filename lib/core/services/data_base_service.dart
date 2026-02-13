import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class DatabaseService {
  static const String _chatsBoxName = 'chats';
  static const String _messagesBoxName = 'messages';

  static Box<ChatModel>? _chatsBox;
  static Box<MessageModel>? _messagesBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();

    _chatsBox = await Hive.openBox<ChatModel>(_chatsBoxName);
    _messagesBox = await Hive.openBox<MessageModel>(_messagesBoxName);
  }

  static Box<ChatModel> get chatsBox {
    if (_chatsBox == null || !_chatsBox!.isOpen) {
      throw Exception('Chats box is not initialized. Call initialize() first.');
    }
    return _chatsBox!;
  }

  static Box<MessageModel> get messagesBox {
    if (_messagesBox == null || !_messagesBox!.isOpen) {
      throw Exception(
        'Messages box is not initialized. Call initialize() first.',
      );
    }
    return _messagesBox!;
  }

  static Future<void> saveChat(ChatModel chat) async {
    await chatsBox.put(chat.id, chat);
  }

  static ChatModel? getChat(String chatId) {
    return chatsBox.get(chatId);
  }

  static List<ChatModel> getAllChats() {
    final chats = chatsBox.values.toList();
    chats.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return chats;
  }

  static Future<void> deleteChat(String chatId) async {
    await chatsBox.delete(chatId);
    final messagesToDelete = messagesBox.values
        .where((msg) => msg.chatId == chatId)
        .map((msg) => msg.key)
        .toList();
    await messagesBox.deleteAll(messagesToDelete);
  }

  static Future<void> updateChatLastMessage({
    required String chatId,
    required String lastMessage,
    required DateTime lastMessageTime,
    required bool isLastMessageSeen,
  }) async {
    final chat = getChat(chatId);
    if (chat != null) {
      chat.lastMessage = lastMessage;
      chat.lastMessageTime = lastMessageTime;
      chat.isLastMessageSeen = isLastMessageSeen;
      if (!isLastMessageSeen) {
        chat.unreadCount += 1;
      }
      await chat.save();
    }
  }

  static Future<void> markChatAsRead(String chatId) async {
    final chat = getChat(chatId);
    if (chat != null) {
      chat.isLastMessageSeen = true;
      chat.unreadCount = 0;
      await chat.save();
    }
  }

  static Future<void> saveMessage(MessageModel message) async {
    await messagesBox.put(message.id, message);
  }

  static MessageModel? getMessage(String messageId) {
    return messagesBox.get(messageId);
  }

  static List<MessageModel> getMessagesForChat(String chatId) {
    final messages = messagesBox.values
        .where((msg) => msg.chatId == chatId)
        .toList();
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  static Future<void> deleteMessage(String messageId) async {
    await messagesBox.delete(messageId);
  }

  static Future<void> updateMessageStatus(
    String messageId,
    String status,
  ) async {
    final message = getMessage(messageId);
    if (message != null) {
      message.status = status;
      await message.save();
    }
  }

  static Future<void> clearAllData() async {
    await chatsBox.clear();
    await messagesBox.clear();
  }

  static Future<void> close() async {
    await _chatsBox?.close();
    await _messagesBox?.close();
  }
}
