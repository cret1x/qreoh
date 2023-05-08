import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/states/user_state.dart';


class FirebaseUserManager {
  final db = FirebaseFirestore.instance;
  static final FirebaseUserManager _singleton = FirebaseUserManager._internal();

  factory FirebaseUserManager() {
    return _singleton;
  }

  FirebaseUserManager._internal();

  Future<UserState> getUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final user = await db.collection('users').doc(uid).get();
    return UserState.fromFirestore(user.id, user.data()!);
  }
}