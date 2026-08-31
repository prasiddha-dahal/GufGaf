import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gufgaf/app/models/app_user_model.dart';


class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createUser(AppUserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toJson());
  }
}