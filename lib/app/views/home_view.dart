import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/controllers/auth_controller.dart';
import 'package:gufgaf/app/controllers/user_controller.dart';
import 'package:gufgaf/app/routes/app_routes.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  var authController = Get.find<AuthController>();
  var userController = Get.find<UserController>();
  int currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              authController.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Home page"),
            Gap(20),
            Obx(() => Text("Welcome ${userController.currentUser.value?.name ?? 'Loading...'}")),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentValue,
        onTap: (index){
          if(index == 0){
            Get.offNamed(AppRoutes.home);
          }else if( index == 1){
            Get.offNamed(AppRoutes.profile);
          }else if( index == 2){
            Get.toNamed(AppRoutes.searchUsers);
          } 
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search Users"),
        ],
      ),
    );
  }
}
