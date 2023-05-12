import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/customisation/custom_avatar.dart';
import 'package:qreoh/entities/customisation/custom_banner.dart';
import 'package:qreoh/entities/customisation/custom_item.dart';
import 'package:qreoh/entities/customisation/reward_item.dart';
import 'package:qreoh/entities/customisation/shop_item.dart';
import 'package:qreoh/firebase_functions/storage.dart';
import 'package:qreoh/firebase_functions/user.dart';
import 'package:qreoh/strings.dart';

class UserState {
  final String uid;
  final List<CustomItem> collection;
  final int balance;
  final String login;
  final int tag;
  final String? profileImageUrl;
  final CustomAvatar avatar;
  final CustomBanner banner;
  final int tasksFriendsCompleted;
  final int tasksFriendsCreated;
  final int tasksCreated;
  final int tasksCompleted;
  final int tasksFromFriendsReceived;
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
      required this.tasksFromFriendsReceived,
      this.profileImageUrl,
      required this.tasksFriendsCompleted,
      required this.tasksFriendsCreated,
      required this.tasksCreated,
      required this.tasksCompleted,
      required this.achievements});

  factory UserState.init(String uid, String login, int tag) {
    return UserState(
      collection: [
        CustomAvatar(
            id: "Uz6gZ1t3pSnGqOHvAD13",
            res: "dino_red.png",
            type: CustomItemType.avatar),
        CustomBanner(
            id: "mIJxTwVuryce10ctFsRl",
            res: "torii.jpg",
            type: CustomItemType.banner),
      ],
      uid: uid,
      balance: 0,
      avatar: CustomAvatar(
          id: "Uz6gZ1t3pSnGqOHvAD13",
          res: "dino_red.png",
          type: CustomItemType.avatar),
      login: login,
      tag: tag,
      level: 1,
      experience: 0,
      banner: CustomBanner(
          id: "mIJxTwVuryce10ctFsRl",
          res: "torii.jpg",
          type: CustomItemType.banner),
      tasksFromFriendsReceived: 0,
      tasksFriendsCompleted: 0,
      tasksFriendsCreated: 0,
      tasksCreated: 0,
      tasksCompleted: 0,
      achievements: [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'login': login,
      'tag': tag,
      'balance': balance,
      'banner': banner.toFirestore(),
      'avatar': avatar.toFirestore(),
      'achievements': achievements,
      'collection': collection.map((e)=>e.toFirestore()).toList(),
      'friends': [],
      'tasksFriendsCompleted': tasksFriendsCompleted,
      'tasksFriendsCreated': tasksFriendsCreated,
      'tasksCreated': tasksCreated,
      'tasksCompleted': tasksCompleted,
      'tasksFromFriendsReceived': tasksFromFriendsReceived,
      'experience': experience,
      'level': level,
    };
  }

  factory UserState.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserState(
        uid: uid,
        collection: List.from(
            (data['collection'] as Iterable).map((e) => CustomItem.fromMap(e))),
        balance: data['balance'],
        login: data['login'],
        tag: data['tag'],
        level: data['level'],
        experience: data['experience'],
        avatar: CustomItem.fromMap(data['avatar']) as CustomAvatar,
        banner: CustomItem.fromMap(data['banner']) as CustomBanner,
        profileImageUrl: data['profileImage'],
        tasksFriendsCompleted: data['tasksFriendsCompleted'],
        tasksFriendsCreated: data['tasksFriendsCreated'],
        tasksCreated: data['tasksCreated'],
        tasksFromFriendsReceived: data['tasksFromFriendsReceived'],
        tasksCompleted: data['tasksCompleted'],
        achievements: List.from(data['achievements']));
  }

  UserState copyWith(
      {int? balance,
      String? login,
      int? tag,
      CustomBanner? banner,
      CustomAvatar? avatar,
      String? profileImage,
      int? tasksFromFriendsReceived,
      int? tasksCompleted,
      int? level,
      int? experience,
      int? tasksFriendsCompleted,
      int? tasksFriendsCreated,
      int? tasksCreated,
      int? friendsCount,
      List<CustomItem>? collection,
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
        profileImageUrl: profileImage,
        tasksFromFriendsReceived:
            tasksFromFriendsReceived ?? this.tasksFromFriendsReceived,
        avatar: avatar ?? this.avatar,
        tasksFriendsCompleted:
            tasksFriendsCompleted ?? this.tasksFriendsCompleted,
        tasksFriendsCreated: tasksFriendsCreated ?? this.tasksFriendsCreated,
        tasksCreated: tasksCreated ?? this.tasksCreated,
        tasksCompleted: tasksCompleted ?? this.tasksCompleted,
        achievements: achievements ?? this.achievements);
  }

  bool hasShopItem(ShopItem item) {
    for (var collectionItem in collection) {
      if (item.id == collectionItem.id) {
        return true;
      }
    }
    return false;
  }
}

class UserStateNotifier extends StateNotifier<UserState?> {
  final firebaseUserManager = FirebaseUserManager();
  final firebaseStorageManager = FirebaseStorageManager();
  final Ref ref;

  UserStateNotifier(this.ref) : super(null) {
    loadFromDB();
  }

  Future<void> loadFromDB() async {
    firebaseUserManager.getUser().then((value) {
      if (mounted) {
        state = value;
      }
    });
  }

  Future<void> addXp(int xp) async {
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

  Future<void> addMoney(int amount) async {
    if (state != null) {
      state = state!.copyWith(balance: state!.balance + amount);
      firebaseUserManager.updateBalance(state!.balance);
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
      firebaseUserManager.updateLogin(login);
      state = state!.copyWith(login: login);
    }
  }

  Future<bool> buyItem(ShopItem item) async {
    if (state != null) {
      if (state!.balance >= item.price) {
        firebaseUserManager.buyItem(item, state!.balance);
        state = state!.copyWith(
            balance: state!.balance - item.price,
            collection: [...state!.collection, item.item]);

        return true;
      }
    }
    return false;
  }

  Future<bool> collectReward(RewardItem item) async {
    if (state != null) {
      if (state!.level >= item.level) {
        firebaseUserManager.collectReward(item);
        state = state!.copyWith(collection: [...state!.collection, item.item]);
        return true;
      }
    }
    return false;
  }

  Future<void> selectShopItem(ShopItem item) async {
    if (state != null) {
      firebaseUserManager.selectItem(item.item);
      if (item.item is CustomBanner) {
        state = state!.copyWith(banner: item.item as CustomBanner);
      } else {
        state = state!.copyWith(avatar: item.item as CustomAvatar);
      }
    }
  }

  Future<void> selectRewardItem(
      CustomBanner? banner, CustomAvatar? avatar) async {
    if (state != null) {
      state = state!.copyWith(banner: banner, avatar: avatar);
      if (avatar != null) {
        firebaseUserManager.selectItem(avatar);
      }
      if (banner != null) {
        firebaseUserManager.selectItem(banner);
      }
    }
  }

  Future<void> updateStats({
    int? tasksFriendsCompleted,
    int? tasksFriendsCreated,
    int? tasksCreated,
    int? tasksCompleted,
  }) async {
    await firebaseUserManager.updateStats(
        tasksFriendsCompleted: tasksFriendsCompleted,
        tasksFriendsCreated: tasksFriendsCreated,
        tasksCreated: tasksCreated,
        tasksCompleted: tasksCompleted);
    // Achievements
    if ((tasksCompleted ?? 0) >= 5) {
      getAchievement("O2odVXVywvNwMQIY5bnh");
    }
    if ((tasksCompleted ?? 0) >= 25) {
      getAchievement("fx82rivViNdrOxUWlDsH");
    }
    if ((tasksCreated ?? 0) >= 30) {
      getAchievement("YCaZyKpkYCl02ijZTCPP");
    }
    if ((tasksCreated ?? 0) >= 50) {
      getAchievement("PudEGukirhWiwa1nIkku");
    }
    if ((tasksFriendsCreated ?? 0) >= 20) {
      getAchievement("GrYAn0VDPtHaGSdmBTtC");
    }
    if ((tasksFriendsCompleted ?? 0) >= 10) {
      getAchievement("Nwcqbn0bC5E5lkWbZA86");
    }
    if ((tasksFriendsCompleted ?? 0) >= 25) {
      getAchievement("wAkHXdvXxwg6v61l9iOF");
    }
    if (state != null) {
      state = state!.copyWith(
          tasksFriendsCompleted: tasksFriendsCompleted,
          tasksFriendsCreated: tasksFriendsCreated,
          tasksCreated: tasksCreated,
          tasksCompleted: tasksCompleted);
    }
  }

  Future<void> getAchievement(String id) async {
    if (state != null && !state!.achievements.contains(id)) {
      firebaseUserManager.getAchievement(id);
      addMoney(Strings.moneyRewardAchievement);
      addXp(Strings.xpRewardAchievement);
    }
  }
}
