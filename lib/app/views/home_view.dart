import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/controllers/auth_controller.dart';
import 'package:gufgaf/app/controllers/chat_controller.dart';
import 'package:gufgaf/app/controllers/user_controller.dart';
import 'package:gufgaf/app/routes/app_routes.dart';
import 'package:gufgaf/app/views/chat_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final authController = Get.find<AuthController>();
  final userController = Get.find<UserController>();
  final chatController = Get.find<ChatController>();
  int currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == currentIndex) return;

    setState(() {
      currentIndex = index;
    });

    if (index == 1) {
      Get.offNamed(AppRoutes.profile);
    } else if (index == 2) {
      Get.offNamed(AppRoutes.searchUsers);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out of GufGaf?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: theme.colorScheme.outline),
            ),
          ),
          FilledButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            text: 'Guf',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: theme.colorScheme.primary
            ),
            children: [
              TextSpan(
                text: 'Gaf',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: Icon(
              Icons.logout_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ChatListView(),
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
      ),
    );
  }
}