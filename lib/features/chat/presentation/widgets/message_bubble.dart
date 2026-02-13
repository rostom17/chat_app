import 'package:chat_app/core/config/size_config.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/util/helper_methods.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final String chatProfilePicture;

  const MessageBubble({
    required this.message,
    required this.chatProfilePicture,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isSentByMe = message.isSentByMe;
    final status = message.messageStatus;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSentByMe)
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 4),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  chatProfilePicture,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isSentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // 🔵 Message Bubble
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSentByMe
                        ? AppColors.primaryColor
                        : SizeConfig.isLightMode
                        ? AppColors.chatColorLight
                        : AppColors.chatColorDark,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isSentByMe ? 20 : 4),
                      bottomRight: Radius.circular(isSentByMe ? 4 : 20),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: isSentByMe
                          ? Colors.white
                          : SizeConfig.isLightMode
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      HelperMethods.formatMessageTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (isSentByMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        _getStatusIcon(status),
                        size: 14,
                        color: Colors.grey[500],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isSentByMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  IconData _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.pending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
      case MessageStatus.failed:
        return Icons.error_outline;
    }
  }
}
