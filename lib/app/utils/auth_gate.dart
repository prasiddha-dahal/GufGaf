import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gufgaf/app/views/home_view.dart';
import 'package:gufgaf/app/views/login_view.dart';
import 'package:gufgaf/app/widgets/notification_initializer.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(strokeWidth: 10));
        }

        if (snapshot.hasData) {
          return NotificationInitializer(child: const HomeView());
        }

        return LoginView();
      },
    );
  }
}

