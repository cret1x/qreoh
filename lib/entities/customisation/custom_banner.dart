import 'package:flutter/cupertino.dart';
import 'package:qreoh/entities/customisation/custom_item.dart';
import 'package:qreoh/strings.dart';

class CustomBanner extends CustomItem {
  CustomBanner({required super.id, required super.res, required super.type});

  @override
  AssetImage get asset => AssetImage(Strings.bannersAssetFolder + res);

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'res': res,
      'type': CustomItemType.banner.name,
    };
  }
}