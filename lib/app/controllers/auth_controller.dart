import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  Future register(String email, String password) async{
    try {
      isLoading.value = true; 
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar('success', 'Account created successfully');
    }on FirebaseAuthException catch (e) {
      Get.snackbar('Failed', e.message ?? 'something went wrong'); 
    } finally{
      isLoading.value = false;
    }
  }

  Future login(String email, String password) async{
    try {
      isLoading.value = true; 
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('success', 'Login successfully');
    }on FirebaseAuthException catch (e) {
      Get.snackbar('Failed', e.message ?? 'something went wrong'); 
    } finally{
      isLoading.value = false;
    }
  }

  Future logout() async{
    await _auth.signOut();
  }


}