import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/shop_item.dart';


class ShopStateNotifier extends StateNotifier<List<ShopItem>> {
  ShopStateNotifier() : super([
    ShopItem(id: "id", name: "name", image: AssetImage("graphics/background1.jpg"), price: 30, type: ShopItemType.banner),
    ShopItem(id: "id", name: "name", image: AssetImage("graphics/avatars/av1.png"), price: 30, type: ShopItemType.avatar),
    ShopItem(id: "id", name: "name", image: AssetImage("graphics/avatars/av2.png"), price: 30, type: ShopItemType.avatar),
  ]);

  void loadItems() async {

  }
}