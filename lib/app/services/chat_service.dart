import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String generateChatId(String uid1, String uid2) {
    final ids = [uid1, uid2]..sort();

    return '${ids[0]}_${ids[1]}';
  }

  static Future<void> createChat({
    required String currentUid,
    required String otherUid,
  }) async {
    final chatId = generateChatId(currentUid, otherUid);

    final chatRef = _firestore.collection('chats').doc(chatId);

    final chatSnapshot = await chatRef.get();

    if (chatSnapshot.exists) {
      return;
    }

    await chatRef.set({
      'participants': [currentUid, otherUid],
      'lastMessage': '',
      'lastMessageAt': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
