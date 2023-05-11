import 'package:flutter/cupertino.dart';
import 'package:qreoh/entities/customisation/custom_item.dart';
import 'package:qreoh/strings.dart';

class CustomAvatar extends CustomItem {
  CustomAvatar({required super.id, required super.res, required super.type});

  @override
  AssetImage get asset => AssetImage(Strings.avatarsAssetFolder + res);

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'res': res,
      'type': CustomItemType.avatar.name,
    };
  }
}