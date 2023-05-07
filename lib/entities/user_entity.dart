import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/states/achievements_state.dart';
import 'package:qreoh/kastom.dart';

//TODO: remade user entity
class UserEntity {
  final String uid;
  final String login;
  final int tag;
  Image? image;
  int countTasks = 0;
  int countHeightPriorityTasks = 0;
  int mediumPriorityTasks = 0;
  int lowPriorityTasks = 0;
  int countFriends = 0;
  List<Achievement> userAchievements = [];
  List<Baner> userBanerss =[];
  List<Avatar> userAvatars =[];
  

  UserEntity(this.uid, this.login, this.tag);

  factory UserEntity.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserEntity(snapshot.id, data?['login'], data?['tag']);
  }
}
