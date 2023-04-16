import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_functions/auth.dart';
import '../../main.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget>
    with AutomaticKeepAliveClientMixin<SettingsWidget> {
  bool _isDarkTheme = false;

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = (prefs.getBool("dark") ?? false);
    });
  }

  Future<void> _updateMode(bool value) async {
    MyApp.of(context).changeTheme(value ? ThemeMode.dark : ThemeMode.light);
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(48)),
              onPressed: () {
                signOutUser();
              },
              child: const Text('Sign out')),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
