import 'package:chat_app/core/config/size_config.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_list_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_list_event.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_list_state.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_message_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatListBloc()..add(const LoadChats()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chats', style: Theme.of(context).textTheme.titleLarge),
          centerTitle: false,
          actions: [
            IconButton.filled(
              icon: const Icon(Icons.edit_square),
              onPressed: () {},
            ),
            Padding(padding: EdgeInsets.only(right: 12.w)),
          ],
        ),
        body: BlocConsumer<ChatListBloc, ChatListState>(
          listener: (context, state) {
            if (state is ChatCreated) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatMessageScreen(chat: state.chat),
                ),
              );
            } else if (state is ChatDeleted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Chat deleted')));
            } else if (state is ChatListError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            if (state is ChatListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ChatListLoaded) {
              final chats = state.chats;
              if (chats.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No chats yet',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start a conversation by tapping the + button',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ChatListItem(chat: chat);
                },
              );
            }

            return _NoChatList();
          },
        ),
      ),
    );
  }
}

class _NoChatList extends StatelessWidget {
  const _NoChatList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No chats yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
