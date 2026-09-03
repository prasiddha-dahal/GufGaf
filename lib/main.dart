import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/bindings/controller_bindings.dart';
import 'package:gufgaf/app/routes/app_pages.dart';
import 'package:gufgaf/app/services/notification_service.dart';
import 'package:gufgaf/app/utils/auth_gate.dart';
import 'package:gufgaf/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor:Colors.blue ,brightness: Brightness.dark)
      ),
      home: AuthGate(),
      getPages: AppPages.routes,
      initialBinding: ControllerBindings(),
    );
  }
}
