import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qreoh/screens/auth/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/screens/friends/add_friend.dart';
import 'package:qreoh/screens/friends/friend_requests.dart';
import 'package:qreoh/screens/friends/friends.dart';
import 'package:qreoh/screens/profile/profile.dart';
import 'package:qreoh/screens/settings/settings.dart';
import 'package:qreoh/screens/tasks/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

final appThemeProvider = Provider((ref) {

});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class AppTheme extends StateNotifier<bool> {
  AppTheme(this.ref): super(false);
  final Ref ref;

  void changeTheme(bool isDark) {

  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode =
          (prefs.getBool("dark") ?? false) ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qreoh app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: const AppMainScreen(title: 'Qreoh Home Page'),
    );
  }
}

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key, required this.title});

  final String title;

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  bool _isAuth = false;
  int _navbarSelectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  static const List<Widget> _pages = [
    TasksWidget(),
    ProfileWidget(),
    FriendsWidget(),
    SettingsWidget()
  ];
  static const List<String> _titles = [
    'Tasks',
    'Profile',
    'Friends',
    'Settings'
  ];

  Future<void> _loadPrefs() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _isAuth = user != null;
      });
    });
  }

  void _onNavbarItemTapped(int index) {
    setState(() {
      _navbarSelectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuth) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_titles.elementAt(_navbarSelectedIndex)),
          actions: _navbarSelectedIndex == 2
              ? [
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
                                builder: (context) =>
                                    const FriendRequestWidget()));
                      },
                      icon: const Icon(Icons.notifications)),
                ]
              : [],
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
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome screen"),
        ),
        body: const WelcomeWidget(),
      );
    }
  }
}
