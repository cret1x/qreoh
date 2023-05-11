import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qreoh/entities/customisation/custom_avatar.dart';
import 'package:qreoh/entities/customisation/custom_banner.dart';
import 'package:qreoh/entities/customisation/custom_item.dart';

class RewardItem{
  final String id;
  final CustomItem item;
  final int level;

  RewardItem({required this.id, required this.item, required this.level});

  factory RewardItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data()!;
    final type = CustomItemType.values.byName(data['type']);
    late CustomItem item;
    switch (type) {
      case CustomItemType.banner:
        item = CustomBanner(id: snapshot.id, res: data['res'], type: type);
        break;
      case CustomItemType.avatar:
        item = CustomAvatar(id: snapshot.id, res: data['res'], type: type);
        break;
    }
    return RewardItem(id: snapshot.id, item: item, level: data['level']);
  }
}