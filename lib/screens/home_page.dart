import 'package:flutter/material.dart';
import 'package:qreoh/screens/friends/add_friend.dart';
import 'package:qreoh/screens/friends/friend_requests.dart';
import 'package:qreoh/screens/friends/friends_widget.dart';
import 'package:qreoh/screens/profile/profile_settings.dart';
import 'package:qreoh/screens/profile/user_profile.dart';
import 'package:qreoh/screens/settings/settings.dart';
import 'package:qreoh/screens/tasks/task_manager_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navbarSelectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  static final List<Widget> _pages = [
    TaskManagerWidget(),
    UserProfile(),
    FriendsWidget(),
    SettingsWidget()
  ];
  static const List<String> _titles = [
    'Задания',
    'Профиль',
    'Друзья',
    'Настройки'
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
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
