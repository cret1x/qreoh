import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/customisation/shop_item.dart';
import 'package:qreoh/firebase_functions/shop.dart';


class ShopStateNotifier extends StateNotifier<List<ShopItem>> {
  final firebaseShopManager = FirebaseShopManager();
  ShopStateNotifier() : super([]) {
    loadFromDB();
  }

  void loadFromDB() async {
    state = await firebaseShopManager.getShopItems();
  }
}