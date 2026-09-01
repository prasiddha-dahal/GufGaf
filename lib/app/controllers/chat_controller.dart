import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/models/message_model.dart';

import '../services/chat_service.dart';

class ChatController extends GetxController {
  final isLoading = false.obs;

  Future<String?> startChat(String otherUid) async {
    try {
      isLoading.value = true;

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        return null;
      }

      await ChatService.createChat(
        currentUid: currentUser.uid,
        otherUid: otherUid,
      );

      return ChatService.generateChatId(currentUser.uid, otherUid);
    } catch (e) {
      Get.snackbar('Error', 'Failed to start conversation');

      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || text.trim().isEmpty) {
      return;
    }

    try {
      await ChatService.sendMessage(
        chatId: chatId,
        senderId: currentUser.uid,
        text: text.trim(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    }
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
  return ChatService.getMessages(chatId);
}
}
