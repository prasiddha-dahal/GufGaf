import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/models/app_user_model.dart';
import 'package:gufgaf/app/routes/app_routes.dart';
import 'package:gufgaf/app/services/user_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

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

      Get.snackbar('success', 'Account created successfully');
      Get.offAllNamed(AppRoutes.home);
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
      Get.snackbar('success', 'Login successfully');
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
    await _auth.signOut();
  }
}
