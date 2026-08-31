import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/controllers/user_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final userController = Get.find<UserController>();
  final name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Obx(() {
        final user = userController.currentUser.value;

        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 10),
          );
        }
        return Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
              Gap(30),
              Text(
                user.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Gap(10),
              Text(user.email),
              Gap(30),
              ElevatedButton.icon(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text("edit name"),
                      content: TextField(
                        controller: name,
                        decoration: InputDecoration(
                          labelText: "Name"
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: (){
                          Get.back();
                        }, child: Text("Cancel")),
                        ElevatedButton(onPressed: (){
                          if(name.text.isEmpty){
                            return;
                          }
                          userController.updateUser(name.text);
                        }, child: Text("Save"))
                      ],
                    )
                  );
                },
                label: Text("Edit"),
                icon: Icon(Icons.edit),
              ),
            ],
          ),
        );
      }),
    );
  }
}
