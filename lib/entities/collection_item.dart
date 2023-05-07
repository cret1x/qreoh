import 'package:flutter/material.dart';
import 'package:qreoh/entities/shop_item.dart';

class CollectionItem {
  final String id;
  final String name;
  final AssetImage image;
  final ShopItemType type;

  CollectionItem({
    required this.id,
    required this.name,
    required this.image,
    required this.type
  });

  factory CollectionItem.fromShopItem({required ShopItem shopItem}) {
    return CollectionItem(id: shopItem.id, name: shopItem.name, image: shopItem.image, type: shopItem.type);
  }
}