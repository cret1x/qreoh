import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/entities/collection_item.dart';
import 'package:qreoh/firebase_functions/user.dart';

class UserState {
  final List<String> collection;
  final int balance;
  final String login;
  final int tag;
  final Image? profileImage;
  final int totalTasksCount;
  final int highPriorityTasksCount;
  final int mediumPriorityTasksCount;
  final int lowPriorityTasksCount;
  final int friendsCount;
  final List<String> achievements;

  UserState(
      {required this.collection,
      required this.balance,
      required this.login,
      required this.tag,
      required this.profileImage,
      required this.totalTasksCount,
      required this.highPriorityTasksCount,
      required this.mediumPriorityTasksCount,
      required this.lowPriorityTasksCount,
      required this.friendsCount,
      required this.achievements});

  factory UserState.fromFirestore(Map<String, dynamic> data) {
    return UserState(
        collection: List.from(data['collection']),
        balance: data['balance'],
        login: data['login'],
        tag: data['tag'],
        profileImage: null,
        totalTasksCount: data['tasksCount'],
        highPriorityTasksCount: data['highTasksCount'],
        mediumPriorityTasksCount: data['midTasksCount'],
        lowPriorityTasksCount: data['lowTasksCount'],
        friendsCount: data['friends'] == null ? 0 : data['friends'].length,
        achievements: List.from(data['achievements']));
  }
}

class UserStateNotifier extends StateNotifier<UserState> {
  final firebaseUserManager = FirebaseUserManager();
  UserStateNotifier()
      : super(UserState(
            collection: [],
            balance: 0,
            login: "anon",
            tag: 0,
            profileImage: null,
            totalTasksCount: 0,
            highPriorityTasksCount: 0,
            mediumPriorityTasksCount: 0,
            lowPriorityTasksCount: 0,
            friendsCount: 0,
            achievements: ["1", "3"]));

  void getUser() async {
      state = await firebaseUserManager.getUser();
  }
}
