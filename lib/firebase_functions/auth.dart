import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> registerUser(String login, String email, String password) async{
  try {
    final credential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    createUserInDatabase(credential.user!.uid, login);
    return "OK";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
    }
  } catch (e) {
    print(e);
  }
  return null;
}

Future<String?> loginUser(email, password) async{
  try {
    final credential =
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return "OK";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      return 'Wrong password provided for that user.';
    }
  } catch (e) {
    print(e);
  }
  return null;
}

Future<void> signOutUser() async{
  await FirebaseAuth.instance.signOut();
}

Future<void> createUserInDatabase(String uid, String login) async {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final snapshot = await usersRef.count().get();
  int tag = snapshot.count;
  usersRef.doc(uid).set({
    'login': login,
    'tag': tag
  });
}

Future<void> restorePassword(String email) async {
  FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}