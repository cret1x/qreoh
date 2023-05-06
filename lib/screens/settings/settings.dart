import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/common_widgets/buttons.dart';
import 'package:qreoh/global_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_functions/auth.dart';

class SettingsWidget extends ConsumerStatefulWidget {
  const SettingsWidget({super.key});

  @override
  ConsumerState<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends ConsumerState<SettingsWidget>
    with AutomaticKeepAliveClientMixin<SettingsWidget> {
  bool _isDarkTheme = false;

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = (prefs.getBool("dark") ?? false);
    });
  }

  Future<void> _updateMode(bool value) async {
    ref
        .read(appThemeProvider.notifier)
        .update((state) => value ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = value;
      prefs.setBool("dark", _isDarkTheme);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SwitchListTile(
            title: const Text("Dark theme"),
            value: _isDarkTheme,
            onChanged: _updateMode,
            secondary: const Icon(Icons.lightbulb_outline),
          ),
        ),
        const Spacer(),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonDanger(
              buttonText: "Sign out",
              warningText: "Are u sure?",
              action: ref.read(authStateProvider.notifier).signOutUser,
            )),
        Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 32),
            child: ButtonDanger(
              buttonText: "Delete Account",
              warningText: "Are u sure?",
              action: ref.read(authStateProvider.notifier).deleteUserAccount,
            ))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
