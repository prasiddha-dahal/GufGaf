import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      await _firestore.collection('users').doc(uid).update({'fcmToken': token});
    }

    // Keep token fresh — FCM tokens can expire/rotate
    _messaging.onTokenRefresh.listen((newToken) {
      _firestore.collection('users').doc(uid).update({'fcmToken': newToken});
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        Get.snackbar(
          message.notification!.title ?? 'New Message',
          message.notification!.body ?? '',
        );
      }
    });
  }
}
