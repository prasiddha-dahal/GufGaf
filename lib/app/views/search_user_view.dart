import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/controllers/chat_controller.dart';
import 'package:gufgaf/app/controllers/user_controller.dart';
import 'package:gufgaf/app/routes/app_routes.dart';
import 'package:gufgaf/app/views/chat_view.dart';

class SearchUserView extends StatelessWidget {
  SearchUserView({super.key});

  final userController = Get.find<UserController>();
  final chatController = Get.find<ChatController>();
  final searchController = TextEditingController();
  int currentValue = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Users")),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: userController.searchUser,
                decoration: InputDecoration(
                  hintText: "Search users...",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              Gap(20),
          
              Expanded(
                child: Obx(() {
                  if (userController.isSearching.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (userController.searchResults.isEmpty) {
                    return Center(child: Text("No users found!!"));
                  }
          
                  return ListView.builder(
                    itemCount: userController.searchResults.length,
                    itemBuilder: (context, index) {
                      final user = userController.searchResults[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(user.name[0].toUpperCase()),
                        ),
                        title: Text(user.name),
                        onTap: () async{
                          final chatId = await chatController.startChat(user.uid); 
                          if(chatId == null){
                            return;
                          }
                          searchController.text = '';

                          Get.to(()=> ChatView(chatId: chatId, otherUser: user) );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
