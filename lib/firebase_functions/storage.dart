import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';


class FirebaseStorageManager {
  final storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  static final FirebaseStorageManager _singleton = FirebaseStorageManager._internal();

  factory FirebaseStorageManager() {
    return _singleton;
  }

  FirebaseStorageManager._internal();

  Future<String> uploadProfilePicture(File file) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = storage.ref();
    final pfp = storageRef.child('images/$uid${extension(file.path)}');
    await pfp.putFile(file);
    final url = await pfp.getDownloadURL();
    await db.collection('users').doc(uid).update({
      'profileImage': url,
    });
    return url;
  }
}