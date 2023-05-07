import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/screens/auth/reset_password.dart';
import 'package:qreoh/screens/auth/verify.dart';
import 'package:qreoh/screens/auth/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/screens/home_page.dart';
import 'package:qreoh/states/user_auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Achievement{

  String name;
  AssetImage image;
  String condition;
  bool received = false;
  DateTime? data;

  Achievement(this.name, this.image, this.condition);
}

List<Achievement> achievements = [
  Achievement(
        "Начало положено",
        const AssetImage("achievement_icons/rocket.jpg"),
        "выполнено 5 заданий"
        ),
    Achievement(
        "Принял, выполняю",
        const AssetImage("achievement_icons/idea.jpg"),
        "выполнено 25 заданий от друзей"),
    Achievement(
        "Не имей 100 рублей",
        const AssetImage("achievement_icons/team.jpg"),
        "добавлено 10 друзей"),
    Achievement(
        "Сказано, сделано",
        const AssetImage("achievement_icons/good-choice.jpg"),
        "выполнено 25 заданий"),
    Achievement(
        "Вызов принят",
        const AssetImage("achievement_icons/success2.jpg"),
        "выполнено 10 заданий от друзей"),
    Achievement(
        "Популярная личность",
        const AssetImage("achievement_icons/teamwork.jpg"),
        "добавлено 30 друзей"),
    Achievement(
        "Большие планы",
        const AssetImage("achievement_icons/success.jpg"),
        "добавлено 30 задач"),
    Achievement(
        "Сама организованность",
        const AssetImage("achievement_icons/analysis.jpg"),
        "добавлено 50 задач"),
    Achievement(
        "Беру на слабо",
        const AssetImage("achievement_icons/manager.jpg"),
        "отправлено 20 заданий друзьям"),
    Achievement(
        "Успеть до",
        const AssetImage("achievement_icons/chronometer.jpg"),
        "выполнено 10 заданий за 2 часа до дедлайна"),
    Achievement(
        "Все самое важное",
        const AssetImage("achievement_icons/target.jpg"),
        "выполнено 10 заданий с повышенным приоритетом"),
    Achievement(
        "Внимание к мелочам",
        const AssetImage("achievement_icons/confetti.jpg"),
        "выполнено 20 заданий с низкой приоритетностом"),
];