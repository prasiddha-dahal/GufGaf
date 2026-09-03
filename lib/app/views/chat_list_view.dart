import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_controller.dart';
import '../models/app_user_model.dart';
import '../models/chat_model.dart';
import '../services/user_service.dart';
import 'chat_view.dart';

class ChatListView extends StatelessWidget {
  ChatListView({super.key});

  final ChatController chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, size: 64, color: theme.colorScheme.outline),
            const Gap(12),
            Text(
              'Not logged in',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<List<ChatModel>>(
      stream: chatController.getMyChats(currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 60, color: theme.colorScheme.error),
                const Gap(12),
                Text(
                  'Something went wrong',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  'Unable to load your chats right now.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ),
          );
        }

        final chats = snapshot.data ?? [];

        if (chats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 72,
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
                const Gap(16),
                Text(
                  'No conversations yet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Gap(4),
                Text(
                  'Search for users to start chatting!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: chats.length,
          separatorBuilder: (context, index) => const Gap(8),
          itemBuilder: (context, index) {
            final chat = chats[index];
            final otherUserId = chatController.getOtherUserId(chat, currentUser.uid);

            // Skip chats with no valid participants
            if (otherUserId.isEmpty) {
              return const SizedBox.shrink();
            }

            return _ChatTile(
              chat: chat,
              otherUserId: otherUserId,
            );
          },
        );
      },
    );
  }
}

/// Extracted Tile Widget to optimize dynamic rebuilds and isolate async state
class _ChatTile extends StatelessWidget {
  final ChatModel chat;
  final String otherUserId;

  const _ChatTile({
    required this.chat,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<AppUserModel?>(
      future: UserService.getUser(otherUserId),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const ListTile(
              leading: CircleAvatar(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
              title: Text('Loading...', style: TextStyle(color: Colors.grey)),
            ),
          );
        }

        final otherUser = userSnapshot.data;
        if (otherUser == null) return const SizedBox.shrink();

        final firstInitial = otherUser.name.isNotEmpty ? otherUser.name[0].toUpperCase() : '?';
        final hasLastMessage = chat.lastMessage.isNotEmpty;

        return Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                firstInitial,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            title: Text(
              otherUser.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                hasLastMessage ? chat.lastMessage : 'Start a conversation...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: hasLastMessage 
                      ? theme.colorScheme.onSurfaceVariant 
                      : theme.colorScheme.primary,
                  fontStyle: hasLastMessage ? FontStyle.normal : FontStyle.italic,
                  fontWeight: hasLastMessage ? FontWeight.normal : FontWeight.w500,
                ),
              ),
            ),
            trailing: chat.lastMessageAt != null
                ? Text(
                    _formatChatTime(chat.lastMessageAt!),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.outline,
                    ),
                  )
                : null,
            onTap: () {
              Get.to(() => ChatView(chatId: chat.id, otherUser: otherUser));
            },
          ),
        );
      },
    );
  }

  String _formatChatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return DateFormat('h:mm a').format(dateTime);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (now.difference(dateTime).inDays < 7) {
      return DateFormat('EEE').format(dateTime); // e.g., "Mon"
    } else {
      return DateFormat('MMM d').format(dateTime); // e.g., "Aug 28"
    }
  }
}