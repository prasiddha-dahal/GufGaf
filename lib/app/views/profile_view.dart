import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/controllers/user_controller.dart';
import 'package:gufgaf/app/routes/app_routes.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final userController = Get.find<UserController>();

  final name = TextEditingController();

  int currentIndex = 1;

  void _onTabTapped(int index) {
    if (index == currentIndex) return;

    setState(() {
      currentIndex = index;
    });

    if (index == 0) {
      Get.offNamed(AppRoutes.home);
    } else if (index == 2) {
      Get.offNamed(AppRoutes.searchUsers);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
        ],
      ),     body: Obx(() {
        final user = userController.currentUser.value;

        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Gap(20),
                  // Profile Avatar Header
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 16,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),

                  // User Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          user.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 16,
                              color: theme.colorScheme.outline,
                            ),
                            const Gap(6),
                            Text(
                              user.email,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),

                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        name.text = user.name;
                        Get.dialog(
                          AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text("Edit Name"),
                            content: TextField(
                              controller: name,
                              decoration: InputDecoration(
                                labelText: "Name",
                                filled: true,
                                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: theme.colorScheme.outline),
                                ),
                              ),
                              FilledButton(
                                onPressed: () {
                                  if (name.text.isEmpty) {
                                    return;
                                  }
                                  userController.updateUser(name.text);
                                  Get.back();
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      label: const Text("Edit Profile"),
                      icon: const Icon(Icons.edit_rounded, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}