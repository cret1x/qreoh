import 'package:flutter/material.dart';

class Achievement {
  static const _imagePath = "graphics/achievement_icons/";
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
      image: AssetImage(_imagePath + data['image']),
      condition: data['condition'],
    );
  }
}
