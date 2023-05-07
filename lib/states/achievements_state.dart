
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/firebase_functions/achievements.dart';


class AchievementsStateNotifier extends StateNotifier<List<Achievement>> {
  final firebaseAchievementsManager = FirebaseAchievementsManager();
  AchievementsStateNotifier() : super([]);

  void loadAchievements() async {
    state = await firebaseAchievementsManager.getAchievements();
  }

}

// List<Achievement> achievements = [
//   Achievement(
//         "Начало положено",
//         const AssetImage("achievement_icons/rocket.jpg"),
//         "выполнено 5 заданий"
//         ),
//     Achievement(
//         "Принял, выполняю",
//         const AssetImage("achievement_icons/idea.jpg"),
//         "выполнено 25 заданий от друзей"),
//     Achievement(
//         "Не имей 100 рублей",
//         const AssetImage("achievement_icons/team.jpg"),
//         "добавлено 10 друзей"),
//     Achievement(
//         "Сказано, сделано",
//         const AssetImage("achievement_icons/good-choice.jpg"),
//         "выполнено 25 заданий"),
//     Achievement(
//         "Вызов принят",
//         const AssetImage("achievement_icons/success2.jpg"),
//         "выполнено 10 заданий от друзей"),
//     Achievement(
//         "Популярная личность",
//         const AssetImage("achievement_icons/teamwork.jpg"),
//         "добавлено 30 друзей"),
//     Achievement(
//         "Большие планы",
//         const AssetImage("achievement_icons/success.jpg"),
//         "добавлено 30 задач"),
//     Achievement(
//         "Сама организованность",
//         const AssetImage("achievement_icons/analysis.jpg"),
//         "добавлено 50 задач"),
//     Achievement(
//         "Беру на слабо",
//         const AssetImage("achievement_icons/manager.jpg"),
//         "отправлено 20 заданий друзьям"),
//     Achievement(
//         "Успеть до",
//         const AssetImage("achievement_icons/chronometer.jpg"),
//         "выполнено 10 заданий за 2 часа до дедлайна"),
//     Achievement(
//         "Все самое важное",
//         const AssetImage("achievement_icons/target.jpg"),
//         "выполнено 10 заданий с повышенным приоритетом"),
//     Achievement(
//         "Внимание к мелочам",
//         const AssetImage("achievement_icons/confetti.jpg"),
//         "выполнено 20 заданий с низкой приоритетностом"),
// ];