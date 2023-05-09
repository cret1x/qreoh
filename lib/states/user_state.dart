import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/entities/reward_item.dart';
import 'package:qreoh/entities/shop_item.dart';
import 'package:qreoh/firebase_functions/shop.dart';
import 'package:qreoh/firebase_functions/storage.dart';
import 'package:qreoh/firebase_functions/user.dart';
import 'package:qreoh/strings.dart';

class UserState {
  final String uid;
  final List<String> collection;
  final int balance;
  final String login;
  final int tag;
  final String? profileImage;
  final AssetImage avatar;
  final AssetImage banner;
  final int totalTasksCount;
  final int highPriorityTasksCount;
  final int mediumPriorityTasksCount;
  final int lowPriorityTasksCount;
  final int friendsCount;
  final int level;
  final int experience;
  final List<String> achievements;

  UserState(
      {required this.collection,
      required this.uid,
      required this.balance,
      required this.avatar,
      required this.login,
      required this.tag,
      required this.level,
      required this.experience,
      required this.banner,
      required this.profileImage,
      required this.totalTasksCount,
      required this.highPriorityTasksCount,
      required this.mediumPriorityTasksCount,
      required this.lowPriorityTasksCount,
      required this.friendsCount,
      required this.achievements});

  factory UserState.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserState(
        uid: uid,
        collection: List.from(data['collection']),
        balance: data['balance'],
        login: data['login'],
        tag: data['tag'],
        level: data['level'],
        experience: data['experience'],
        avatar: AssetImage("${Strings.avatarsAssetFolder}${data['avatar']}"),
        banner: AssetImage("${Strings.bannersAssetFolder}${data['banner']}"),
        profileImage: data['profileImage'],
        totalTasksCount: data['tasksCount'],
        highPriorityTasksCount: data['highTasksCount'],
        mediumPriorityTasksCount: data['midTasksCount'],
        lowPriorityTasksCount: data['lowTasksCount'],
        friendsCount: data['friends'] == null ? 0 : data['friends'].length,
        achievements: List.from(data['achievements']));
  }

  UserState copyWith(
      {List<String>? collection,
      int? balance,
      String? login,
      int? tag,
      AssetImage? banner,
      AssetImage? avatar,
      String? profileImage,
      int? totalTasksCount,
      int? level,
      int? experience,
      int? highPriorityTasksCount,
      int? mediumPriorityTasksCount,
      int? lowPriorityTasksCount,
      int? friendsCount,
      List<String>? achievements}) {
    return UserState(
        collection: collection ?? this.collection,
        uid: uid,
        level: level ?? this.level,
        experience: experience ?? this.experience,
        balance: balance ?? this.balance,
        login: login ?? this.login,
        tag: tag ?? this.tag,
        banner: banner ?? this.banner,
        profileImage: profileImage,
        avatar: avatar ?? this.avatar,
        totalTasksCount: totalTasksCount ?? this.totalTasksCount,
        highPriorityTasksCount:
            highPriorityTasksCount ?? this.highPriorityTasksCount,
        mediumPriorityTasksCount:
            mediumPriorityTasksCount ?? this.mediumPriorityTasksCount,
        lowPriorityTasksCount:
            lowPriorityTasksCount ?? this.lowPriorityTasksCount,
        friendsCount: friendsCount ?? this.friendsCount,
        achievements: achievements ?? this.achievements);
  }
}

class UserStateNotifier extends StateNotifier<UserState?> {
  final firebaseUserManager = FirebaseUserManager();
  final firebaseStorageManager = FirebaseStorageManager();

  UserStateNotifier() : super(null);

  void getUser() async {
    state = await firebaseUserManager.getUser();
  }

  void addXp(int xp) async {
    if (state != null) {
      state = state!.copyWith(experience: state!.experience + xp);
      firebaseUserManager.updateXp(state!.experience);
      if (state!.experience >= state!.level * 100) {
        state = state!.copyWith(
            level: state!.level + 1,
            experience: state!.experience - state!.level * 100);
        firebaseUserManager.updateLevel(state!.level);
        firebaseUserManager.updateXp(state!.experience);
      }
    }
  }

  void updateProfileImage(File image) async {
    if (state != null) {
      final url = await firebaseStorageManager.uploadProfilePicture(image);
      state = state!.copyWith(profileImage: url);
    }

  }

  void updateLogin(String login) async {
    if (state != null) {
      await firebaseUserManager.updateLogin(login);
      state = state!.copyWith(login: login);
    }
  }

  Future<bool> buyItem(ShopItem item) async {
    if (state != null) {
      if (state!.balance >= item.price) {
        firebaseUserManager.buyItem(item, state!.balance);
        state = state!.copyWith(
            balance: state!.balance - item.price,
            collection: [...state!.collection, item.id]);

        return true;
      }
    }
    return false;
  }

  Future<bool> collectReward(RewardItem item) async {
    if (state != null) {
      if (state!.level >= item.level) {
        firebaseUserManager.collectReward(item);
        state = state!.copyWith(
            collection: [...state!.collection, item.id]);
        return true;
      }
    }
    return false;
  }

  Future<void> selectItem(ShopItem item) async {
    if (state != null) {
      firebaseUserManager.selectItem(item);
      if (item.type == ShopItemType.banner) {
        state = state!.copyWith(banner: item.image);
      } else {
        state = state!.copyWith(avatar: item.image);
      }
    }
  }

  Future<void> selectItemReward(RewardItem item) async {
    if (state != null) {
      firebaseUserManager.selectRewardItem(item);
      if (item.type == ShopItemType.banner) {
        state = state!.copyWith(banner: item.image);
      } else {
        state = state!.copyWith(avatar: item.image);
      }
    }
  }
}
