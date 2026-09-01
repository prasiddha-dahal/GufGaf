import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/models/app_user_model.dart';

import '../services/user_service.dart';

class UserController extends GetxController {
  final Rxn<AppUserModel> currentUser = Rxn<AppUserModel>();
  final isLoading = false.obs;

  final RxList<AppUserModel> searchResults = <AppUserModel>[].obs;
  final isSearching = false.obs;


  Future<void> loadCurrentUser(String uid) async {
    try {
      isLoading.value = true;

      final user = await UserService.getUser(uid);

      currentUser.value = user;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(String name) async {
    try {
      isLoading.value = true;

      await UserService.updateUser(
        uid: currentUser.value!.uid,
        data: {'name': name},
      );

      currentUser.value = AppUserModel(
        uid: currentUser.value!.uid,
        name: name,
        email: currentUser.value!.email,
        createdAt: currentUser.value!.createdAt,
      );

      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchUser(String query) async{
    if(query.trim().isEmpty){
      searchResults.clear();
      return; 
    }

    try{
      isSearching.value = true;
      final currentUser = FirebaseAuth.instance.currentUser;

      if(currentUser == null){
        return;
      }

      final results = await UserService.searchUsers(query.trim(), currentUser.uid);
      searchResults.assignAll(results);
    }catch(e){
      Get.snackbar('Error', 'Failed to search users');
    }finally{
      isSearching.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await loadCurrentUser(user.uid);
    }
  }
}
