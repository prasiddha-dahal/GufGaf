import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gufgaf/app/models/app_user_model.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createUser(AppUserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  static Future<AppUserModel?> getUser(String uid) async {
    final document = await _firestore.collection('users').doc(uid).get();

    if (!document.exists) {
      return null;
    }
    return AppUserModel.fromJson(document.data()!);
  }

  static Future<void> updateUser({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  static Future<List<AppUserModel>> searchUsers(
    String query,
    String currentUid,
  ) async {
    final snapshot = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '$query\uf8ff')
        .get();

    return snapshot.docs
        .map((doc) => AppUserModel.fromJson(doc.data()))
        .where((user) => user.uid != currentUid)
        .toList();
  }
}
