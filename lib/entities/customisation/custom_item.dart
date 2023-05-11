import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:qreoh/strings.dart';

import 'custom_avatar.dart';
import 'custom_banner.dart';

enum CustomItemType {banner, avatar}

abstract class CustomItem {
  final String id;
  final String res;
  final CustomItemType type;

  CustomItem({required this.id, required this.res, required this.type});

  AssetImage get asset => const AssetImage(Strings.defaultPfp);

  Map<String, dynamic> toFirestore();

  factory CustomItem.fromMap(Map<String, dynamic> data) {
    final type = CustomItemType.values.byName(data['type']);
    switch (type) {
      case CustomItemType.banner:
        return CustomBanner(id: data['id'], res: data['res'], type: type);
      case CustomItemType.avatar:
        return CustomAvatar(id: data['id'], res: data['res'], type: type);
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is CustomItem) {
      return id == other.id;
    }
    return false;
  }
}