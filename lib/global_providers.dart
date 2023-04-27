
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final authStateProvider = StateProvider<bool>((ref) => false);