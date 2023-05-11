import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/states/user_state.dart';


class FirebaseAchievementsManager {
  final db = FirebaseFirestore.instance;
  static final FirebaseAchievementsManager _singleton = FirebaseAchievementsManager._internal();

  factory FirebaseAchievementsManager() {
    return _singleton;
  }

  FirebaseAchievementsManager._internal();

  Future<List<Achievement>> getAchievements() async {
    List<Achievement> achievements = [];
    final achRef = await db.collection('achievements').get();
    for (var ach in achRef.docs) {
      achievements.add(Achievement.fromFirestore(ach, null));
    }
    return achievements;
  }
}