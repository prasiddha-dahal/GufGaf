import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../services/chat_service.dart';

class ChatController extends GetxController {

  final isLoading = false.obs;

  Future<String?> startChat(String otherUid) async {
    try {
      isLoading.value = true;

      final currentUser =
          FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        return null;
      }

      await ChatService.createChat(
        currentUid: currentUser.uid,
        otherUid: otherUid,
      );

      return ChatService.generateChatId(
        currentUser.uid,
        otherUid,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to start conversation',
      );

      return null;
    } finally {
      isLoading.value = false;
    }
  }
}