import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qreoh/screens/auth/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/screens/friends/friends.dart';
import 'package:qreoh/screens/profile/profile.dart';
import 'package:qreoh/screens/settings/settings.dart';
import 'package:qreoh/screens/tasks/tasks.dart';

import 'firebase_options.dart';
import '/firebase_functions/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      themeMode: ThemeMode.dark,
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
          title: Text(widget.title),
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
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
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
