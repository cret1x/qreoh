import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qreoh/entities/customisation/custom_avatar.dart';
import 'package:qreoh/entities/customisation/custom_banner.dart';
import 'package:qreoh/entities/customisation/custom_item.dart';

class ShopItem{
  final String id;
  final CustomItem item;
  final int price;

  ShopItem({required this.id, required this.item, required this.price});

  factory ShopItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data()!;
    final type = CustomItemType.values.byName(data['type']);
    late CustomItem item;
    switch (type) {
      case CustomItemType.banner:
        item = CustomBanner(id: snapshot.id, res: data['res'],type: type);
        break;
      case CustomItemType.avatar:
        item = CustomAvatar(id: snapshot.id, res: data['res'],type: type);
        break;
    }
    return ShopItem(id: snapshot.id, item: item, price: data['price']);
  }
}