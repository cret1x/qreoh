import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qreoh/entities/user_entity.dart';


Future<UserEntity?> getUserByUid(String uid) async {
  final db = FirebaseFirestore.instance;
  final usersRef = db.collection('users');
  final snapshot = await usersRef.doc(uid).get();
  if (snapshot.exists) {
      return UserEntity.fromFirestore(snapshot, null);
  }
  return null;
}