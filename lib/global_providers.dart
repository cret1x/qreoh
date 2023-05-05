
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/filter.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/states/network_state.dart';
import 'package:qreoh/states/task_list_state.dart';

final appThemeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final authStateProvider = StateProvider<bool>((ref) => false);

final userTagsProvider = StateProvider<List<Tag>>((ref) => [Tag("1", Icons.add, "pl"), Tag("2",Icons.ac_unit, "fh")]);

final tasksFilterProvider = StateProvider<Filter>((ref) => Filter());

final networkStateProvider = StateNotifierProvider<NetworkStateNotifier, bool>((ref) => NetworkStateNotifier());

final taskListStateProvider = StateNotifierProvider<TaskListStateNotifier, List<Task>>((ref) => TaskListStateNotifier());