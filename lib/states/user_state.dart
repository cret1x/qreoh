import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/entities/collection_item.dart';
import 'package:qreoh/entities/shop_item.dart';
import 'package:qreoh/firebase_functions/user.dart';

class UserState {
  final String uid;
  final List<String> collection;
  final int balance;
  final String login;
  final int tag;
  final Image? profileImage;
  final AssetImage banner;
  final int totalTasksCount;
  final int highPriorityTasksCount;
  final int mediumPriorityTasksCount;
  final int lowPriorityTasksCount;
  final int friendsCount;
  final List<String> achievements;

  UserState({required this.collection,
    required this.uid,
    required this.balance,
    required this.login,
    required this.tag,
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
        banner: AssetImage("graphics/${data['banner']}"),
        profileImage: null,
        totalTasksCount: data['tasksCount'],
        highPriorityTasksCount: data['highTasksCount'],
        mediumPriorityTasksCount: data['midTasksCount'],
        lowPriorityTasksCount: data['lowTasksCount'],
        friendsCount: data['friends'] == null ? 0 : data['friends'].length,
        achievements: List.from(data['achievements']));
  }

  UserState copyWith({
    List<String>? collection,
    int? balance,
    String? login,
    int? tag,
    AssetImage? banner,
    Image? profileImage,
    int? totalTasksCount,
    int? highPriorityTasksCount,
    int? mediumPriorityTasksCount,
    int? lowPriorityTasksCount,
    int? friendsCount,
    List<String>? achievements}) {
    return UserState(collection: collection ?? this.collection,
        uid: uid,
        balance: balance ?? this.balance,
        login: login ?? this.login,
        tag: tag ?? this.tag,
        banner: banner ?? this.banner,
        profileImage: profileImage,
        totalTasksCount: totalTasksCount ?? this.totalTasksCount,
        highPriorityTasksCount: highPriorityTasksCount ?? this.highPriorityTasksCount,
        mediumPriorityTasksCount: mediumPriorityTasksCount ?? this.mediumPriorityTasksCount,
        lowPriorityTasksCount: lowPriorityTasksCount ?? this.lowPriorityTasksCount,
        friendsCount: friendsCount ?? this.friendsCount,
        achievements: achievements ?? this.achievements);
  }
}

class UserStateNotifier extends StateNotifier<UserState> {
  final firebaseUserManager = FirebaseUserManager();

  UserStateNotifier()
      : super(UserState(
    uid: "anon",
      collection: [],
      balance: 0,
      login: "anon",
      tag: 0,
      profileImage: null,
      banner: const AssetImage("graphics/background4.jpg"),
      totalTasksCount: 0,
      highPriorityTasksCount: 0,
      mediumPriorityTasksCount: 0,
      lowPriorityTasksCount: 0,
      friendsCount: 0,
      achievements: ["1", "3"]));

  void getUser() async {
    state = await firebaseUserManager.getUser();
  }

  Future<bool> buyItem(ShopItem item) async {
    if (state.balance >= item.price) {
      state = state.copyWith(balance: state.balance - item.price, collection: [...state.collection, item.id]);
      return true;
    }
    return false;
  }

  Future<void> selectItem(ShopItem item) async {
    if (item.type == ShopItemType.banner) {
      state = state.copyWith(banner: item.image);
    }
  }
}
