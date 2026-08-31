import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/models/app_user_model.dart';

import '../services/user_service.dart';

class UserController extends GetxController {
  final Rxn<AppUserModel> currentUser = Rxn<AppUserModel>();

  final isLoading = false.obs;

  Future<void> loadCurrentUser(String uid) async {
    try {
      isLoading.value = true;

      final user = await UserService.getUser(uid);

      currentUser.value = user;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load user profile',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(String name) async {
    try {
      isLoading.value = true;

      await UserService.updateUser(uid: currentUser.value!.uid, data: {
        'name': name
      });

      currentUser.value = AppUserModel(uid: currentUser.value!.uid, name: name, email: currentUser.value!.email, createdAt: currentUser.value!.createdAt);

      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update user profile',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() async{
    super.onInit();
    final uid = await FirebaseAuth.instance.currentUser!.uid;
    loadCurrentUser(uid);
  }
}