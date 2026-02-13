import 'package:chat_app/core/config/size_config.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_message_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_message_event.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_message_state.dart';
import 'package:chat_app/features/chat/presentation/widgets/custom_appbar.dart';
import 'package:chat_app/features/chat/presentation/widgets/message_bubble.dart';
import 'package:chat_app/features/chat/presentation/widgets/time_stamp_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessageScreen extends StatefulWidget {
  final ChatModel chat;

  const ChatMessageScreen({super.key, required this.chat});

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _sendMessage(BuildContext context) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    context.read<ChatMessageBloc>().add(
      SendMessage(chatId: widget.chat.id, text: text),
    );

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatMessageBloc(chatId: widget.chat.id),
      child: Scaffold(
        appBar: CustomAppBar(widget: widget),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatMessageBloc, ChatMessageState>(
                listener: (context, state) {
                  if (state is MessageSent) {
                    _scrollToBottom();
                  } else if (state is ChatMessageLoaded) {
                    _scrollToBottom();
                  } else if (state is ChatMessageError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.message}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ChatMessageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatMessageLoaded ||
                      state is MessageSending ||
                      state is MessageSent) {
                    List<MessageModel> messages = [];

                    if (state is ChatMessageLoaded) {
                      messages = state.messages;
                    } else if (state is MessageSending) {
                      messages = state.messages;
                    } else if (state is MessageSent) {
                      messages = state.messages;
                    }

                    if (messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.message,
                              size: 80,
                              color: SizeConfig.isLightMode
                                  ? Colors.grey[400]
                                  : Colors.grey[200],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No messages yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: SizeConfig.isLightMode
                                    ? Colors.grey[400]
                                    : Colors.grey[200],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Say hi to ${widget.chat.name}!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final showTimestamp =
                            index == 0 ||
                            message.timestamp
                                    .difference(messages[index - 1].timestamp)
                                    .inMinutes >
                                5;

                        return Column(
                          children: [
                            if (showTimestamp)
                              TimeStampDivider(timestamp: message.timestamp),
                            MessageBubble(
                              message: message,
                              chatProfilePicture: widget.chat.profilePicture,
                            ),
                          ],
                        );
                      },
                    );
                  }

                  // Initial state
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      child: SafeArea(
        child: BlocBuilder<ChatMessageBloc, ChatMessageState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: SizeConfig.isLightMode
                          ? AppColors.chatColorLight
                          : AppColors.chatColorDark,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: SizeConfig.isDarkMode
                            ? Color(0xFF334155)
                            : Color(0xFFE2E8F0),
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: SizeConfig.isLightMode
                              ? Color(0xFF94A3B8)
                              : Color(0xFF64748B),
                        ),

                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            // Emoji picker can be added here
                          },
                        ),
                      ),
                      style: TextStyle(
                        color: SizeConfig.isLightMode
                            ? Colors.grey[900]
                            : Colors.grey[100],
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      onSubmitted: (_) => _sendMessage(context),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),

                  child: GestureDetector(
                    onTap: () => _sendMessage(context),
                    child: Padding(
                      padding: EdgeInsets.all(12.0.w),
                      child: Icon(Icons.send, color: AppColors.whiteColor),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
