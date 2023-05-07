import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/shop_item.dart';
import 'package:qreoh/firebase_functions/shop.dart';


class ShopStateNotifier extends StateNotifier<List<ShopItem>> {
  final firebaseShopManager = FirebaseShopManager();
  ShopStateNotifier() : super([]);

  void loadItems() async {
    state = await firebaseShopManager.getShopItems();
  }
}