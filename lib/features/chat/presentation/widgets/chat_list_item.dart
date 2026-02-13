import 'package:chat_app/core/config/size_config.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/util/helper_methods.dart';
import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_list_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_list_event.dart';
import 'package:chat_app/features/chat/presentation/screens/chat_message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListItem extends StatelessWidget {
  final ChatModel chat;

  const ChatListItem({required this.chat, super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(chat.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade400,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(
              'Delete Chat',
              style: TextStyle(
                color: SizeConfig.isLightMode ? Colors.black : Colors.white,
              ),
            ),
            content: Text(
              'Are you sure you want to delete chat with ${chat.name}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        context.read<ChatListBloc>().add(DeleteChat(chat.id));
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: SizeConfig.isLightMode
              ? AppColors.primaryColor.withAlpha(50)
              : AppColors.primaryColor,
          child: Text(
            chat.profilePicture,
            style: const TextStyle(fontSize: 28),
          ),
        ),
        title: Text(chat.name, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text(
          chat.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: chat.isLastMessageSeen
                ? FontWeight.w200
                : FontWeight.w500,
            color: SizeConfig.isLightMode ? Colors.black : Colors.grey.shade100,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              HelperMethods.formatMessageTime(chat.lastMessageTime),
              style: TextStyle(
                fontSize: 12,
                color: chat.isLastMessageSeen
                    ? Colors.grey[600]
                    : AppColors.primaryColor,
                fontWeight: chat.isLastMessageSeen
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
            if (chat.unreadCount > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  chat.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () {
          context.read<ChatListBloc>().add(MarkChatAsRead(chat.id));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatMessageScreen(chat: chat),
            ),
          );
        },
      ),
    );
  }
}
