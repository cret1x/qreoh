import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/entities/user_entity.dart';

import '../entities/task.dart';

Future<void> createTask(Task task) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  final tasksRef = db.collection('users').doc(uid).collection("tasks");
  CollectionReference curRef = tasksRef;
  late DocumentReference docRef;
  String pathString = task.getParent().getPath();
  final path = pathString.substring(0, pathString.length - 1).split('/').forEach((element) {
    docRef = curRef.doc(element);
    curRef = docRef.collection("folders");
  });
  docRef = docRef.collection("tasks").doc(task.getName());
  docRef.set(
    task.toFirestore(),
  );
}

Future<List<Task>> getFolderContent(Folder folder) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  final tasksRef = db.collection('users').doc(uid).collection("tasks");
  CollectionReference curRef = tasksRef;
  late DocumentReference docRef;
  String pathString = folder.getPath();
  pathString.substring(0, pathString.length - 1).split('/').forEach((element) {
    docRef = curRef.doc(element);
    curRef = docRef.collection("folders");
  });
  final tasksCollection = await docRef.collection("tasks").get();
  List<Task> tasks = [];
  for (var element in tasksCollection.docs) {
      tasks.add(Task.fromFirestore(element, folder, null));
  }
  print(tasks);
  return tasks;
}