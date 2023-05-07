import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/screens/auth/reset_password.dart';
import 'package:qreoh/screens/auth/verify.dart';
import 'package:qreoh/screens/auth/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/screens/home_page.dart';
import 'package:qreoh/states/user_auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'global_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    ref.read(appThemeProvider.notifier).update((state) => (prefs.getBool("dark") ?? false) ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    _themeMode = ref.watch(appThemeProvider);
    return MaterialApp(
      title: 'Qreoh app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: Colors.white,
          primary: Colors.deepOrangeAccent,
          secondary: Colors.deepOrangeAccent.shade100,
          onBackground: Colors.black87,
          primaryContainer: Colors.white.withOpacity(0.4),
          brightness: Brightness.light,
        ),

      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: Colors.grey.shade800,
          surface: Colors.black12,
          onSurface: Colors.white,
          primary: Colors.deepOrangeAccent,
          secondary: Colors.orange.shade800,
          primaryContainer: Colors.black26,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      home: const StartupPage(),
    );
  }
}

class StartupPage extends ConsumerStatefulWidget {
  const StartupPage({super.key});

  @override
  ConsumerState<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends ConsumerState<StartupPage> {
  UserAuthState _authState = UserAuthState.anonymous();

  @override
  Widget build(BuildContext context) {
    _authState = ref.watch(authStateProvider);
    switch(_authState.state) {
      case AuthState.anonymous:
        return const WelcomeWidget();
      case AuthState.registered:
        return const VerifyEmailWidget();
      case AuthState.verified:
        return const HomePage();
    }
  }
}
