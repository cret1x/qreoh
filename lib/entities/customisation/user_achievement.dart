import 'package:flutter/cupertino.dart';

class UserAchievement {
  final String id;
  final String name;
  final String description;
  final AssetImage icon;
  final int progress;

  UserAchievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.progress,
  });
}
