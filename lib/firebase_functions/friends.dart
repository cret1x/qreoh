import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/entities/user_entity.dart';


Future<UserEntity?> searchFriend(String login, int tag) async {
  final db = FirebaseFirestore.instance;
  final usersRef = db.collection('users');
  final query = usersRef.where('login', isEqualTo: login).where('tag', isEqualTo: tag);
  final value = await query.get();
  if (value.size != 0) {
    final user = value.docs.first.data();
    return UserEntity(value.docs.first.id, user['login'], user['tag']);
  } else {
    return null;
  }
}

Future<List<UserEntity>> getAllFriends(bool descending) async {
  final db = FirebaseFirestore.instance;
  List<UserEntity> friends = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final user = await db.collection('users').doc(uid).get();
  final friendsIds = user.data()?['friends'];
  print(friendsIds);
  if (friendsIds.isNotEmpty) {
    final friendsObj = await db.collection('users').where('__name__', whereIn: friendsIds).get();
    friendsObj.docs.sort((a, b) => (a['login'] as String).toLowerCase().compareTo((b['login'] as String).toLowerCase()));
    for (var element in friendsObj.docs) {
      friends.add(UserEntity(element.id, element['login'], element['tag']));
    }
  }
  return friends;
}