import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_controller.dart';
import '../models/app_user_model.dart';
import '../services/user_service.dart';

class ChatView extends StatefulWidget {
  final String chatId;
  final AppUserModel otherUser;

  const ChatView({
    super.key,
    required this.chatId,
    required this.otherUser,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController chatController = Get.find<ChatController>();

  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    chatController.sendMessage(
      chatId: widget.chatId,
      text: text,
    );

    messageController.clear();
  }

  String _formatLastSeen(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Last seen just now';
    if (diff.inMinutes < 60) return 'Last seen ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Last seen ${diff.inHours}h ago';
    return 'Last seen ${DateFormat('MMM d, h:mm a').format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        scrolledUnderElevation: 2,
        title: StreamBuilder<AppUserModel?>(
          stream: UserService.getUserStream(widget.otherUser.uid),
          builder: (context, snapshot) {
            final user = snapshot.data ?? widget.otherUser;

            return Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    if (user.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.isOnline
                            ? 'Online'
                            : user.lastSeen != null
                                ? _formatLastSeen(user.lastSeen!)
                                : '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: user.isOnline
                              ? Colors.green
                              : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/gufgaf_background.svg',
              fit: BoxFit.cover,
              color: Colors.grey.withValues(alpha: 0.3),
            ),
          ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: chatController.getMessages(widget.chatId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
        
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.forum_outlined,
                                size: 56,
                                color: theme.colorScheme.outline.withValues(alpha: 0.5),
                              ),
                              const Gap(12),
                              Text(
                                'Start the conversation',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
        
                      final messages = snapshot.data!;
        
                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == currentUid;
        
                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    message.text,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isMe
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    message.createdAt != null
                                        ? DateFormat('h:mm a').format(message.createdAt!)
                                        : '',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isMe
                                          ? theme.colorScheme.onPrimary.withValues(alpha: 0.6)
                                          : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: TextField(
                            controller: messageController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const Gap(8),
                      IconButton.filled(
                        onPressed: _sendMessage,
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.all(12),
                        ),
                        icon: const Icon(
                          Icons.send_rounded,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ]
      ),
    );
  }
}