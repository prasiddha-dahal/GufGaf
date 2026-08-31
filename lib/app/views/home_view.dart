import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/controllers/auth_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  var authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"),actions: [IconButton(onPressed: (){
        authController.logout();
      }, icon: Icon(Icons.logout))],),
      body: SingleChildScrollView(child: Column(children: [Text("Home page")])),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
