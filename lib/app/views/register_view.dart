import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/constants/app_constants.dart';
import 'package:gufgaf/app/routes/app_routes.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

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
                    const Text("Register", style: TextStyle(fontSize: 30),),
                    Gap(AppConstants.mediumVerticalGap),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        label:const Text("Email"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Gap(AppConstants.smallVerticalGap),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.visibility)),
                        label: Text("Password"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Gap(AppConstants.mediumVerticalGap),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Register"),
                      ),
                    ),
                    Gap(AppConstants.smallVerticalGap),
                    Row(
                      children: [
                        const Text("Already has an account? "),
                        InkWell(child: const Text("Login"),onTap: (){
                          Get.offNamed(AppRoutes.login);
                        },),
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
