
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/firebase_functions/achievements.dart';


class AchievementsStateNotifier extends StateNotifier<List<Achievement>> {
  final firebaseAchievementsManager = FirebaseAchievementsManager();
  final Ref ref;
  AchievementsStateNotifier(this.ref) : super([]);

  Future<void> loadAchievements() async {
    state = await firebaseAchievementsManager.getAchievements();
  }
}