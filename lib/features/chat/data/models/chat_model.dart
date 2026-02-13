import 'package:hive_ce/hive_ce.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 0)
class ChatModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String profilePicture;

  @HiveField(4)
  String lastMessage;

  @HiveField(5)
  DateTime lastMessageTime;

  @HiveField(6)
  bool isLastMessageSeen;

  @HiveField(7)
  int unreadCount;

  ChatModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.lastMessage,
    required this.lastMessageTime,
    this.isLastMessageSeen = true,
    this.unreadCount = 0,
  });

  ChatModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePicture,
    String? lastMessage,
    DateTime? lastMessageTime,
    bool? isLastMessageSeen,
    int? unreadCount,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isLastMessageSeen: isLastMessageSeen ?? this.isLastMessageSeen,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
