import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/models/app_user_model.dart';
import 'package:gufgaf/app/controllers/user_controller.dart';
import 'package:gufgaf/app/services/user_service.dart';
import 'package:gufgaf/app/utils/auth_gate.dart';

class AuthController extends GetxController with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    // If user is already logged in, set online
    final user = _auth.currentUser;
    if (user != null) {
      UserService.setOnlineStatus(uid: user.uid, isOnline: true);
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final user = _auth.currentUser;
    if (user == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        UserService.setOnlineStatus(uid: user.uid, isOnline: true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        UserService.setOnlineStatus(uid: user.uid, isOnline: false);
        break;
      default:
        break;
    }
  }

  Future register(String name, String email, String password) async {
    try {
      isLoading.value = true;
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Failed to create user');
      }
      final user = AppUserModel(
        uid: firebaseUser.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      await UserService.createUser(user);
      await UserService.setOnlineStatus(uid: firebaseUser.uid, isOnline: true);

      final userController = Get.find<UserController>();
      await userController.loadCurrentUser(firebaseUser.uid);

      Get.snackbar('success', 'Account created successfully');
      Get.offAll(() => const AuthGate());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Failed', e.message ?? 'something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        await UserService.setOnlineStatus(uid: firebaseUser.uid, isOnline: true);
        final userController = Get.find<UserController>();
        await userController.loadCurrentUser(firebaseUser.uid);
      }

      Get.snackbar('success', 'Login successfully');
      Get.offAll(() => const AuthGate());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Failed', e.message ?? 'something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  void passwordVisibilityToggle() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future logout() async {
    final user = _auth.currentUser;
    if (user != null) {
      await UserService.setOnlineStatus(uid: user.uid, isOnline: false);
    }
    await _auth.signOut();
    final userController = Get.find<UserController>();
    userController.currentUser.value = null;
    Get.offAll(() => const AuthGate());
  }
}

