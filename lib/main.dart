import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/screens/auth/reset_password.dart';
import 'package:qreoh/screens/auth/verify.dart';
import 'package:qreoh/screens/auth/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/screens/home_page.dart';
import 'package:qreoh/states/app_theme_state.dart';
import 'package:qreoh/states/user_auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'global_providers.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    print("${provider.name ?? provider.runtimeType} => $newValue");
  }

  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    print("Provider disposed: ${provider.name ?? provider.runtimeType}");
  }

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value, ProviderContainer container) {
    print("Provider Added: ${provider.name ?? provider.runtimeType}");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(observers: [Logger()], child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  AppThemeState _appThemeState = AppThemeState.base();

  @override
  void initState() {
    super.initState();
    ref.read(appThemeProvider.notifier).loadFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    _appThemeState = ref.watch(appThemeProvider);
    return MaterialApp(
      title: 'Qreoh app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: Color.fromARGB(255, 250, 250, 250),
          primary: Colors.deepOrangeAccent,
          onSurface: Colors.black38,
          secondary: Colors.deepOrangeAccent.shade100,
          onBackground: Colors.black87,
          primaryContainer: Colors.white.withOpacity(0.4),
          brightness: Brightness.light,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: Color.fromARGB(255, 46, 46, 46),
          surface: Colors.grey.shade900,
          onSurface: Colors.white,
          primary: Colors.deepOrangeAccent,
          secondary: Colors.deepOrangeAccent.shade100,
          primaryContainer: Colors.black26,
          brightness: Brightness.dark,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      themeMode: _appThemeState.themeMode,
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
    switch (_authState.state) {
      case AuthState.anonymous:
        return const WelcomeWidget();
      case AuthState.registered:
        return const VerifyEmailWidget();
      case AuthState.verified:
        return const HomePage();
    }
  }
}
