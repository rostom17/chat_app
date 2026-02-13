import 'dart:async';
import 'dart:math';

import 'package:chat_app/core/services/data_base_service.dart';
import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';


class ChatService {
  static const List<String> _dummyReplies = [
    "Hey! How are you?",
    "That sounds great!",
    "I'm doing well, thanks for asking!",
    "Let's catch up soon!",
    "Absolutely! I agree with that.",
    "That's interesting, tell me more!",
    "I'll get back to you on that.",
    "Thanks for letting me know!",
    "Sounds like a plan!",
    "I'm happy to help with that.",
    "That's wonderful news!",
    "I understand what you mean.",
    "Let me think about it.",
    "Great idea!",
    "Looking forward to it!",
  ];

  static Future<MessageModel> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final messageId = _generateId();
    final now = DateTime.now();

    final sentMessage = MessageModel(
      id: messageId,
      chatId: chatId,
      text: text,
      timestamp: now,
      isSentByMe: true,
      status: 'pending',
    );

    await DatabaseService.saveMessage(sentMessage);

    await DatabaseService.updateChatLastMessage(
      chatId: chatId,
      lastMessage: text,
      lastMessageTime: now,
      isLastMessageSeen: true,
    );
    await Future.delayed(const Duration(milliseconds: 500));
    sentMessage.updateStatus(MessageStatus.sent);
    await sentMessage.save();

    _simulateReply(chatId);

    return sentMessage;
  }

  static void _simulateReply(String chatId) {
    final random = Random();
    final delay = Duration(seconds: 1 + random.nextInt(3));

    Timer(delay, () async {
      final replyText = _dummyReplies[random.nextInt(_dummyReplies.length)];
      final replyMessageId = _generateId();
      final now = DateTime.now();

      final replyMessage = MessageModel(
        id: replyMessageId,
        chatId: chatId,
        text: replyText,
        timestamp: now,
        isSentByMe: false,
        status: 'sent',
      );

      await DatabaseService.saveMessage(replyMessage);

      await DatabaseService.updateChatLastMessage(
        chatId: chatId,
        lastMessage: replyText,
        lastMessageTime: now,
        isLastMessageSeen: false,
      );
    });
  }

  static Future<ChatModel> createChat({
    required String name,
    required String profilePicture,
  }) async {
    final chatId = _generateId();
    final now = DateTime.now();

    final chat = ChatModel(
      id: chatId,
      name: name,
      email: "dummy-email@gmail.com",
      profilePicture: profilePicture,
      lastMessage: "Start a conversation",
      lastMessageTime: now,
      isLastMessageSeen: true,
      unreadCount: 0,
    );

    await DatabaseService.saveChat(chat);
    return chat;
  }

  static Future<void> initializeSampleChats() async {
    final chats = DatabaseService.getAllChats();
    
    if (chats.isEmpty) {
      final sampleChats = [
        {
          'name': 'Rostom Ali',
          'profilePicture': '👨‍💻',
          'lastMessage': 'Great Work!',
        },
        {
          'name': 'Lionel Messi',
          'profilePicture': '👨',
          'lastMessage': 'Super Play!',
        },
        {
          'name': 'Serena Williams',
          'profilePicture': '👩‍💼',
          'lastMessage': 'Let me know when you\'re free',
        },
        {
          'name': 'Developer Joe',
          'profilePicture': '👨‍💻',
          'lastMessage': 'That sounds great!',
        },
        {
          'name': 'Emma Davis',
          'profilePicture': '👩‍🎨',
          'lastMessage': 'I\'ll send it over soon',
        },
      ];

      for (int i = 0; i < sampleChats.length; i++) {
        final chatData = sampleChats[i];
        final chat = ChatModel(
          id: _generateId(),
          name: chatData['name']!,
          email: generateUniqueEmail(chatData['name']!),
          profilePicture: chatData['profilePicture']!,
          lastMessage: chatData['lastMessage']!,
          lastMessageTime: DateTime.now().subtract(Duration(hours: i)),
          isLastMessageSeen: i % 2 == 0, // Alternate seen/unseen
          unreadCount: i % 2 == 0 ? 0 : i,
        );
        await DatabaseService.saveChat(chat);
      }
    }
  }

  static String generateUniqueEmail(String name) {
    return "${name.toLowerCase().replaceAll(' ', '')}@gmail.com";
  }

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(9999).toString().padLeft(4, '0');
  }
}