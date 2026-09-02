import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
import '../models/chat_model.dart';
import '../models/app_user_model.dart';
import '../services/user_service.dart';
import 'chat_view.dart';

class ChatListView extends StatelessWidget {
  ChatListView({super.key});

  final ChatController chatController =
      Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text('Not logged in'),
      );
    }

    return StreamBuilder<List<ChatModel>>(
      stream: chatController.getMyChats(
        currentUser.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        final chats = snapshot.data ?? [];

        if (chats.isEmpty) {
          return const Center(
            child: Text(
              'No conversations yet',
            ),
          );
        }

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];

            final otherUserId =
              chatController.getOtherUserId(
              chat,
              currentUser.uid,
            );

            return FutureBuilder<AppUserModel?>(
              future: UserService.getUser(
              otherUserId,
              ),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const ListTile(
                    leading: CircleAvatar(),
                    title: Text('Loading...'),
                  );
                }

                final otherUser = userSnapshot.data;

                if (otherUser == null) {
                  return const SizedBox.shrink();
                }

                return Card(
                  elevation: 20,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        otherUser.name[0].toUpperCase(),
                      ),
                    ),
                    title: Text(
                      otherUser.name,
                    ),
                    subtitle: Text(
                      chat.lastMessage.isEmpty
                          ? 'Start a conversation'
                          : chat.lastMessage,
                    ),
                    onTap: () {
                      Get.to(
                        () => ChatView(
                          chatId: chat.id,
                          otherUser: otherUser,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}