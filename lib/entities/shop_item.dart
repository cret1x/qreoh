import 'package:flutter/material.dart';

enum ShopItemType { banner, avatar }


class ShopItem {
  final String id;
  final String name;
  final AssetImage image;
  final int price;
  final ShopItemType type;

  ShopItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.type
  });
}