import 'package:get/get.dart';
import 'package:gufgaf/app/controllers/auth_controller.dart';

class ControllerBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(),permanent: true);

  }
}