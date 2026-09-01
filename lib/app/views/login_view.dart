import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/constants/app_constants.dart';
import 'package:gufgaf/app/controllers/auth_controller.dart';
import 'package:gufgaf/app/routes/app_routes.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.all(AppConstants.screenPadding),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Login", style: TextStyle(fontSize: 30)),
                    Gap(AppConstants.mediumVerticalGap),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        label: const Text("Email"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Gap(AppConstants.smallVerticalGap),
                    Obx((){
                    return TextField(
                      controller: passwordController,
                      obscureText: !authController.isPasswordVisible.value,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            authController.passwordVisibilityToggle();
                          },
                          icon: (!authController.isPasswordVisible.value) ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                        ),
                        label: Text("Password"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
 
                    }),
                   Gap(AppConstants.mediumVerticalGap),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async{
                          Loader.show(context);
                          await authController.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                          Loader.hide();
                          emailController.text = '';
                          passwordController.text = '';
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Gap(AppConstants.smallVerticalGap),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("New User? "),
                        InkWell(
                          child: const Text("Register"),
                          onTap: () {
                            Get.offNamed(AppRoutes.register);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
