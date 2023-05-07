import 'package:flutter/material.dart';

enum ShopItemType { banner, avatar }

class ShopItem {
  final String id;
  final String name;
  final AssetImage image;
  final int price;
  final ShopItemType type;

  ShopItem(
      {required this.id,
      required this.name,
      required this.image,
      required this.price,
      required this.type});

  factory ShopItem.fromFirestore(String id, Map<String, dynamic> data) {
    return ShopItem(
        id: id,
        name: data['name'],
        image: AssetImage("graphics/${data['image']}"),
        price: data['price'],
        type: data['type'] == "banner"
            ? ShopItemType.banner
            : ShopItemType.avatar);
  }
}
