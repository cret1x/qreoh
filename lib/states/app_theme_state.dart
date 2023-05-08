import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeState {
  final ThemeMode themeMode;
  final String background;
  final AssetImage lightBackground;
  final AssetImage darkBackground;

  factory AppThemeState.base() {
    return AppThemeState(
      themeMode: ThemeMode.system,
      background: "forest",
      lightBackground: const AssetImage("${Strings.backgroundsAssetFolder}forest/light.jpg"),
      darkBackground: const AssetImage("${Strings.backgroundsAssetFolder}forest/dark.jpg"),
    );
  }

  AppThemeState(
      {required this.themeMode,
        required this.background,
      required this.lightBackground,
      required this.darkBackground});

  AppThemeState copyWith(
      {ThemeMode? themeMode, String? background, AssetImage? light, AssetImage? dark}) {
    return AppThemeState(
        themeMode: themeMode ?? this.themeMode,
        background: background ?? this.background,
        lightBackground: light ?? lightBackground,
        darkBackground: dark ?? darkBackground);
  }
}

class AppThemeStateNotifier extends StateNotifier<AppThemeState> {
  AppThemeStateNotifier() : super(AppThemeState.base());

  void changeBackground(String bg) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("background", bg);
    state = state.copyWith(
      background: bg,
      light: AssetImage("${Strings.backgroundsAssetFolder}$bg/light.jpg"),
      dark: AssetImage("${Strings.backgroundsAssetFolder}$bg/dark.jpg"),
    );
  }

  void changeTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(themeMode: mode);
    int value = 0;
    switch (mode) {
      case ThemeMode.system:
        value = 0;
        break;
      case ThemeMode.light:
        value = 1;
        break;
      case ThemeMode.dark:
        value = 2;
        break;
    }
    prefs.setInt("theme", value);
  }

  void loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    ThemeMode mode = ThemeMode.system;
    String bg = prefs.getString("background") ?? "forest";
    switch (prefs.getInt("theme") ?? 0) {
      case 0:
        mode = ThemeMode.system;
        break;
      case 1:
        mode = ThemeMode.light;
        break;
      case 2:
        mode = ThemeMode.dark;
        break;
      default:
        mode = ThemeMode.system;
        break;
    }
    state = state.copyWith(
      themeMode: mode,
      background: bg,
      light: AssetImage("${Strings.backgroundsAssetFolder}$bg/light.jpg"),
      dark: AssetImage("${Strings.backgroundsAssetFolder}$bg/dark.jpg"),
    );
  }
}
