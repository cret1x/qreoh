import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/friends/add_friend.dart';
import 'package:qreoh/screens/friends/friend_requests.dart';
import 'package:qreoh/screens/friends/friends_widget.dart';
import 'package:qreoh/screens/profile/profile_settings.dart';
import 'package:qreoh/screens/profile/user_profile.dart';
import 'package:qreoh/screens/settings/settings.dart';
import 'package:qreoh/screens/tasks/tasks/task_manager_widget.dart';
import 'package:qreoh/strings.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _navbarSelectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  static final List<Widget> _pages = [
    TaskManagerWidget(),
    UserProfile(),
    FriendsWidget(),
    SettingsWidget()
  ];
  static const List<String> _titles = [
    Strings.appTitleTasks,
    Strings.appTitleProfile,
    Strings.appTitleFriends,
    Strings.appTitleSettings,
  ];

  void _onNavbarItemTapped(int index) {
    setState(() {
      _navbarSelectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  List<Widget> getActionsByPage(int index) {
    switch (index) {
      case 1:
        return [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyProfileSettings()));
            },
            icon: const Icon(Icons.settings),
          ),
        ];
      case 2:
        return [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddFriendWidget()));
              },
              icon: const Icon(Icons.person_add)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FriendRequestWidget()));
              },
              icon: const Icon(Icons.notifications)),
        ];
      default:
        return [];
    }
  }

  @override
  void initState() {
    super.initState();
    ref.read(userStateProvider.notifier).getUser();
    ref.read(userTagsProvider.notifier).loadTags();
    ref.read(friendsListStateProvider.notifier).getAllFriends(false);
    ref.read(shopStateProvider.notifier).loadItems();
    ref.read(rewardsStateProvider.notifier).loadItems();
    ref.read(achievementsProvider.notifier).loadAchievements();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles.elementAt(_navbarSelectedIndex)),
        actions: getActionsByPage(_navbarSelectedIndex),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _navbarSelectedIndex,
        onTap: _onNavbarItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check), label: Strings.appTitleTasks),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: Strings.appTitleProfile),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: Strings.appTitleFriends),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: Strings.appTitleSettings),
        ],
      ),
    );
  }
}
