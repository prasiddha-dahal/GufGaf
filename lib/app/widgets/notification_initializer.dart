import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/notification_service.dart';

class NotificationInitializer extends StatefulWidget {
  final Widget child;

  const NotificationInitializer({super.key, required this.child});

  @override
  State<NotificationInitializer> createState() =>
      _NotificationInitializerState();
}

class _NotificationInitializerState extends State<NotificationInitializer> {
  @override
  void initState() {
    super.initState();

    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final notificationService = NotificationService();

    await notificationService.initialize(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
