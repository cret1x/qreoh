import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/entities/customisation/custom_banner.dart';
import 'package:qreoh/entities/customisation/custom_item.dart';
import 'package:qreoh/entities/customisation/reward_item.dart';
import 'package:qreoh/entities/customisation/shop_item.dart';
import 'package:qreoh/states/user_state.dart';

class FirebaseUserManager {
  final db = FirebaseFirestore.instance;
  static final FirebaseUserManager _singleton = FirebaseUserManager._internal();

  factory FirebaseUserManager() {
    return _singleton;
  }

  FirebaseUserManager._internal();

  Future<UserState> getUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final user = await db.collection('users').doc(uid).get();
    return UserState.fromFirestore(user.id, user.data()!);
  }

  Future<void> updateXp(int xp) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    db.collection('users').doc(uid).update({
      'experience': xp,
    });
  }

  Future<void> updateLevel(int level) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    db.collection('users').doc(uid).update({
      'level': level,
    });
  }

  Future<void> buyItem(ShopItem item, int balance) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    db.collection('users').doc(uid).update({
      "collection": FieldValue.arrayUnion([item.item.toFirestore()]),
      'balance': balance - item.price,
    });
  }

  Future<void> selectItem(CustomItem item) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    db.collection('users').doc(uid).update({
      (item is CustomBanner ? 'banner' : "avatar"): item.toFirestore(),
    });
  }

  Future<void> updateLogin(String newLogin) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    db.collection('users').doc(uid).update({
      'login': newLogin,
    });
  }

  Future<void> updateStats({
    int? tasksFriendsCompleted,
    int? tasksFriendsCreated,
    int? tasksCreated,
    int? tasksCompleted,
  }) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    db.collection('users').doc(uid).update({
      if (tasksFriendsCompleted != null) 'tasksFriendsCompleted': tasksFriendsCompleted,
      if (tasksFriendsCreated != null) 'tasksFriendsCreated': tasksFriendsCreated,
      if (tasksCreated != null) 'tasksCreated': tasksCreated,
      if (tasksCompleted != null) 'tasksCompleted': tasksCompleted,
    });
  }

  Future<void> getAchievement(String id) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    db.collection('users').doc(uid).update({
      'achievements': FieldValue.arrayUnion([id]),
    });
  }

  void collectReward(RewardItem item) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    db.collection('users').doc(uid).update({
      "collection": FieldValue.arrayUnion([item.item.toFirestore()]),
    });
  }
}
