import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qreoh/entities/reward_item.dart';
import 'package:qreoh/entities/shop_item.dart';


class FirebaseRewardsManager {
  final db = FirebaseFirestore.instance;
  static final FirebaseRewardsManager _singleton = FirebaseRewardsManager._internal();

  factory FirebaseRewardsManager() {
    return _singleton;
  }

  FirebaseRewardsManager._internal();

  Future<List<RewardItem>> getRewardsItems() async {
    List<RewardItem> rewardItems = [];
    final itemsRef = await db.collection('rewards').get();
    for (var item in itemsRef.docs) {
      rewardItems.add(RewardItem.fromFirestore(item.id, item.data()));
    }
    return rewardItems;
  }
}