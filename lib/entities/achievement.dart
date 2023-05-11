import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory Achievement.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return Achievement(
      id: snapshot.id,
      name: data?['name'] ?? "Achievement",
      image: AssetImage(Strings.achievementsAssetFolder + (data?['image'] ?? 'rocket.jpg')),
      condition: data?['condition'] ?? "Condition",
    );
  }
}
