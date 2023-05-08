import 'package:flutter/material.dart';
import 'package:qreoh/strings.dart';

class Achievement {
  final String id;
  final String name;
  final AssetImage image;
  final String condition;

  Achievement({
    required this.id,
    required this.name,
    required this.image,
    required this.condition,
  });

  factory Achievement.fromFirestore(String id, Map<String, dynamic> data) {
    return Achievement(
      id: id,
      name: data['name'],
      image: AssetImage(Strings.achievementsAssetFolder + data['image']),
      condition: data['condition'],
    );
  }
}
