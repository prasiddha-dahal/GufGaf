import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gufgaf/app/models/message_model.dart';

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

  static Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'senderId': senderId,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<List<MessageModel>> getMessages(String chatId) {
  return _firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => MessageModel.fromJson(
                doc.data(),
                doc.id,
              ),
            )
            .toList(),
      );
}

}
