
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/filter.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/states/network_state.dart';
import 'package:qreoh/states/task_list_state.dart';
import 'package:qreoh/states/user_auth_state.dart';
import 'package:qreoh/states/user_tags_state.dart';

final appThemeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final userTagsProvider = StateNotifierProvider<TagListStateNotifier, List<Tag>>((ref) => TagListStateNotifier());

final tasksFilterProvider = StateProvider<Filter>((ref) => Filter());

final networkStateProvider = StateNotifierProvider<NetworkStateNotifier, bool>((ref) => NetworkStateNotifier());

final taskListStateProvider = StateNotifierProvider<TaskListStateNotifier, List<Task>>((ref) => TaskListStateNotifier());

final authStateProvider = StateNotifierProvider<UserAuthStateNotifier, UserAuthState>((ref) => UserAuthStateNotifier());