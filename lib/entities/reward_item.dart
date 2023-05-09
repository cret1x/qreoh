import 'package:flutter/material.dart';
import 'package:qreoh/entities/shop_item.dart';
import 'package:qreoh/strings.dart';

class RewardItem {
  final String id;
  final String name;
  final String file;
  final AssetImage image;
  final ShopItemType type;
  final int level;

  RewardItem({
    required this.id,
    required this.name,
    required this.file,
    required this.image,
    required this.type,
    required this.level,
  });

  factory RewardItem.fromFirestore(String id, Map<String, dynamic> data) {
    return RewardItem(
        id: id,
        name: data['name'],
        image: data['type'] == "banner"
            ? AssetImage("${Strings.bannersAssetFolder}${data['image']}")
            : AssetImage("${Strings.avatarsAssetFolder}${data['image']}"),
        level: data['level'],
        file: data['image'],
        type: data['type'] == "banner"
            ? ShopItemType.banner
            : ShopItemType.avatar);
  }
}