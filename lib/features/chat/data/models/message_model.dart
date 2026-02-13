import 'package:hive_ce/hive_ce.dart';

part 'message_model.g.dart';

enum MessageStatus {
  pending,
  sent,
  delivered,
  read,
  failed,
}

@HiveType(typeId: 1)
class MessageModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String chatId;

  @HiveField(2)
  String text;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  bool isSentByMe;

  @HiveField(5)
  String status; // Store as String for Hive compatibility

  MessageModel({
    required this.id,
    required this.chatId,
    required this.text,
    required this.timestamp,
    required this.isSentByMe,
    this.status = 'sent',
  });

  MessageStatus get messageStatus {
    switch (status) {
      case 'pending':
        return MessageStatus.pending;
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sent;
    }
  }

  void updateStatus(MessageStatus newStatus) {
    status = newStatus.toString().split('.').last;
  }

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? text,
    DateTime? timestamp,
    bool? isSentByMe,
    String? status,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isSentByMe: isSentByMe ?? this.isSentByMe,
      status: status ?? this.status,
    );
  }
}