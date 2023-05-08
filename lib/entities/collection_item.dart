import 'package:flutter/material.dart';
import 'package:qreoh/entities/shop_item.dart';
import 'package:qreoh/strings.dart';

class CollectionItem {
  final String id;
  final String name;
  final AssetImage image;
  final ShopItemType type;
  final int level;

  CollectionItem({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.level,
  });

  factory CollectionItem.fromFirestore(String id, Map<String, dynamic> data) {
    return CollectionItem(
        id: id,
        name: data['name'],
        image: data['type'] == "banner"
            ? AssetImage("${Strings.bannersAssetFolder}${data['image']}")
            : AssetImage("${Strings.avatarsAssetFolder}${data['image']}"),
        level: data['level'],
        type: data['type'] == "banner"
            ? ShopItemType.banner
            : ShopItemType.avatar);
  }
}