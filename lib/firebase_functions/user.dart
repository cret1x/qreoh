import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/entities/reward_item.dart';
import 'package:qreoh/entities/shop_item.dart';
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
    await db.collection('users').doc(uid).update({
      'experience': xp,
    });
  }

  Future<void> updateLevel(int level) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await db.collection('users').doc(uid).update({
      'level': level,
    });
  }

  Future<void> buyItem(ShopItem item, int balance) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await db.collection('users').doc(uid).update({
      "collection": FieldValue.arrayUnion([item.id]),
      'balance': balance - item.price,
    });
  }

  Future<void> selectItem(ShopItem item) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await db.collection('users').doc(uid).update({
      item.type == ShopItemType.banner ? 'banner' : "avatar": item.file,
    });
  }

  Future<void> selectRewardItem(RewardItem item) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await db.collection('users').doc(uid).update({
      item.type == ShopItemType.banner ? 'banner' : "avatar": item.file,
    });
  }

  Future<void> updateLogin(String newLogin) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await db.collection('users').doc(uid).update({
      'login': newLogin,
    });
  }

  void collectReward(RewardItem item) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await db.collection('users').doc(uid).update({
      "collection": FieldValue.arrayUnion([item.id]),
    });
  }
}