import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gufgaf/app/controllers/chat_controller.dart';
import 'package:gufgaf/app/controllers/user_controller.dart';
import 'package:gufgaf/app/routes/app_routes.dart';
import 'package:gufgaf/app/views/chat_view.dart';

class SearchUserView extends StatefulWidget {
  const SearchUserView({super.key});

  @override
  State<SearchUserView> createState() => _SearchUserViewState();
}

class _SearchUserViewState extends State<SearchUserView> {
  final userController = Get.find<UserController>();
  final chatController = Get.find<ChatController>();
  final searchController = TextEditingController();
  int currentIndex = 2;

  void _onTabTapped(int index) {
    if (index == currentIndex) return;

    setState(() {
      currentIndex = index;
    });

    if (index == 0) {
      Get.offNamed(AppRoutes.home);
    } else if (index == 1) {
      Get.offNamed(AppRoutes.profile);
    }
  }


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Find People",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(12),
              // Search Input Field
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: searchController,
                builder: (context, value, child) {
                  return TextField(
                    controller: searchController,
                    onChanged: userController.searchUser,
                    decoration: InputDecoration(
                      hintText: "Search by name or username...",
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: value.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                searchController.clear();
                                userController.searchUser('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Gap(16),

              // Search Results List
              Expanded(
                child: Obx(() {
                  if (userController.isSearching.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (userController.searchResults.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_search_rounded,
                            size: 80,
                            color: theme.colorScheme.outline.withValues(alpha: 0.5),
                          ),
                          const Gap(12),
                          Text(
                            "No users found",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            "Try searching with a different name.",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: userController.searchResults.length,
                    separatorBuilder: (context, index) => const Gap(8),
                    itemBuilder: (context, index) {
                      final user = userController.searchResults[index];
                      final firstInitial = user.name.isNotEmpty
                          ? user.name[0].toUpperCase()
                          : '?';

                      return Card(
                        elevation: 0,
                        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Text(
                              firstInitial,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          title: Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          onTap: () async {
                            final chatId = await chatController.startChat(user.uid);
                            if (chatId == null) return;

                            searchController.clear();
                            Get.to(() => ChatView(chatId: chatId, otherUser: user));
                          },
                        ),
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