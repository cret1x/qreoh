import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/entities/tag.dart';


class FirebaseTagManager {
  final db = FirebaseFirestore.instance;
  static final FirebaseTagManager _singleton = FirebaseTagManager._internal();

  factory FirebaseTagManager() {
    return _singleton;
  }

  FirebaseTagManager._internal();

  Future<List<Tag>> getAllTags() async {
    List<Tag> tags = [];
    final tasksRef = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tags");
    final tasksCollection = await tasksRef.get();
    for (var element in tasksCollection.docs) {
      tags.add(Tag.fromFirestore(element.id, element.data()));
    }
    return tags;
  }

  Future<void> createTag(Tag tag) async {
    final tasksRef = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tags");
    tasksRef.doc(tag.id).set(tag.toFirestore());
  }

  Future<void> deleteTag(Tag tag) async {
    final tagsRef = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tags");
    final tasksRef = db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('tasks');
    final toDelete = await tasksRef.where('tags', arrayContains: tag.id).get();
    tagsRef.doc(tag.id).delete();
    for (var doc in toDelete.docs) {
      tasksRef.doc(doc.id).update({
        "tags": FieldValue.arrayRemove([tag.id]),
      });
    }
  }

  Future<void> updateTag(Tag tag) async {
    final tasksRef = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tags");
    tasksRef.doc(tag.id).set(tag.toFirestore());
  }
}

