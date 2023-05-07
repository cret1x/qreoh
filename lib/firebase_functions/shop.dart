import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qreoh/entities/shop_item.dart';


class FirebaseShopManager {
  final db = FirebaseFirestore.instance;
  static final FirebaseShopManager _singleton = FirebaseShopManager._internal();

  factory FirebaseShopManager() {
    return _singleton;
  }

  FirebaseShopManager._internal();

  Future<List<ShopItem>> getShopItems() async {
    List<ShopItem> shopItems = [];
    final itemsRef = await db.collection('shop').get();
    for (var item in itemsRef.docs) {
      shopItems.add(ShopItem.fromFirestore(item.id, item.data()));
    }
    return shopItems;
  }
}