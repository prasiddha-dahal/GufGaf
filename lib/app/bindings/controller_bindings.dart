import 'package:get/get.dart';
import 'package:gufgaf/app/controllers/auth_controller.dart';
import 'package:gufgaf/app/controllers/chat_controller.dart';
import 'package:gufgaf/app/controllers/user_controller.dart';

class ControllerBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(),permanent: true);
    Get.put<UserController>(UserController(),permanent: true);
    Get.put<ChatController>(ChatController(),permanent: true);
  }
}