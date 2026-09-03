import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> initialize(String uid) async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print(
      'Notification permission: '
      '${settings.authorizationStatus}',
    );

    final token = await _messaging.getToken();

    print('FCM TOKEN: $token');

    if (token != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({
        'fcmToken': token,
      });
    }
  }
}