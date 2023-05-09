import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/strings.dart';


class FirebaseAuthManager {
  final db = FirebaseFirestore.instance;
  static final FirebaseAuthManager _singleton = FirebaseAuthManager._internal();

  factory FirebaseAuthManager() {
    return _singleton;
  }

  FirebaseAuthManager._internal();


  Future<String?> registerUser(
      String login, String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser!.updateDisplayName(login);
      createUserInDatabase(
          FirebaseAuth.instance.currentUser!.uid,
          login);
      return "OK";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Strings.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        return Strings.accountTaken;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> loginUser(email, password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "OK";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Strings.noAccountForEmail;
      } else if (e.code == 'wrong-password') {
        return Strings.wrongPassword;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> deleteUserAccount() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  Future<void> verifyUser() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  Future<void> createUserInDatabase(String uid, String login) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final snapshot = await usersRef.count().get();
    int tag = snapshot.count;
    usersRef.doc(uid).set({
      'login': login,
      'tag': tag,
      'balance': 100,
      'banner': 'torii.jpg',
      'avatar': 'eboy.jpg',
      'achievements': [],
      'collection': ['h9o8MYCjvMK4UxXvoa7z', 'sEth2BoQoV41l8AOWp9G'],
      'friends': [],
      'tasksFriendsCompleted': 0,
      'tasksFriendsCreated': 0,
      'tasksCreated': 0,
      'tasksCompleted': 0,
      'tasksFromFriendsReceived': 0,
      'experience': 0,
      'level': 1,
    });
    usersRef
        .doc(uid)
        .collection("folders")
        .doc("root")
        .set({"name": "Общее", "parent": null});
  }

  Future<void> resetPassword(String email) async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

}