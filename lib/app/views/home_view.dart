import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/controllers/auth_controller.dart';
import 'package:gufgaf/app/controllers/chat_controller.dart';
import 'package:gufgaf/app/controllers/user_controller.dart';
import 'package:gufgaf/app/routes/app_routes.dart';
import 'package:gufgaf/app/views/chat_list_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final authController = Get.find<AuthController>();
  final userController = Get.find<UserController>();
  final chatController = Get.find<ChatController>();
  int currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GufGaf", style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            onPressed: () {
              authController.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(),
          Expanded(child: ChatListView()),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentValue,
        onTap: (index) {
          if (index == 0) {
            Get.offNamed(AppRoutes.home);
          } else if (index == 1) {
            Get.offNamed(AppRoutes.profile);
          } else if (index == 2) {
            Get.toNamed(AppRoutes.searchUsers);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search Users",
          ),
        ],
      ),
    );
  }
}
