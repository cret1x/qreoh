
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/entities/reward_item.dart';
import 'package:qreoh/entities/shop_item.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/states/achievements_state.dart';
import 'package:qreoh/states/app_theme_state.dart';
import 'package:qreoh/states/folder_state.dart';
import 'package:qreoh/states/friends_list_state.dart';
import 'package:qreoh/states/network_state.dart';
import 'package:qreoh/states/rewards_items_state.dart';
import 'package:qreoh/states/shop_state.dart';
import 'package:qreoh/states/task_filter_state.dart';
import 'package:qreoh/states/task_list_state.dart';
import 'package:qreoh/states/user_auth_state.dart';
import 'package:qreoh/states/user_state.dart';
import 'package:qreoh/states/user_tags_state.dart';

import 'entities/folder.dart';

final appThemeProvider = StateNotifierProvider<AppThemeStateNotifier, AppThemeState>((ref) => AppThemeStateNotifier());

final userTagsProvider = StateNotifierProvider<TagListStateNotifier, List<Tag>>((ref) => TagListStateNotifier());

final tasksFilterProvider = StateNotifierProvider<FilterStateNotifier, FilterState>((ref) => FilterStateNotifier());

final networkStateProvider = StateNotifierProvider<NetworkStateNotifier, bool>((ref) => NetworkStateNotifier());

final taskListStateProvider = StateNotifierProvider<TaskListStateNotifier, List<Task>>((ref) => TaskListStateNotifier(ref));

final authStateProvider = StateNotifierProvider<UserAuthStateNotifier, UserAuthState>((ref) => UserAuthStateNotifier());

final friendsListStateProvider = StateNotifierProvider<FriendListStateNotifier, FriendsState>((ref) => FriendListStateNotifier());

final shopStateProvider = StateNotifierProvider<ShopStateNotifier, List<ShopItem>>((ref) => ShopStateNotifier());

final userStateProvider = StateNotifierProvider<UserStateNotifier, UserState?>((ref) => UserStateNotifier(ref));

final achievementsProvider = StateNotifierProvider<AchievementsStateNotifier, List<Achievement>>((ref) => AchievementsStateNotifier(ref));

final rewardsStateProvider = StateNotifierProvider<RewardsStateNotifier, List<RewardItem>>((ref) => RewardsStateNotifier());

final folderStateProvider = StateNotifierProvider<FolderStateNotifier, Folder>((ref) => FolderStateNotifier());

final tasksListRebuildProvider = ChangeNotifierProvider<TaskListRebuildNotifier>((ref) => TaskListRebuildNotifier());