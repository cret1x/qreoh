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
  String pathString = task.parent.getPath();
  pathString.substring(0, pathString.length - 1).split('/').forEach((element) {
    docRef = curRef.doc(element);
    curRef = docRef.collection("folders");
  });
  docRef = docRef.collection("tasks").doc(task.id);
  docRef.set(
    task.toFirestore(),
  );
}

Future<List<Task>> getTasksInFolder(Folder folder) async {
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
  return tasks;
}

Future<void> changeTaskState(Task task) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  final tasksRef = db.collection('users').doc(uid).collection("tasks");
  CollectionReference curRef = tasksRef;
  late DocumentReference docRef;
  String pathString = task.parent.getPath();
  pathString.substring(0, pathString.length - 1).split('/').forEach((element) {
    docRef = curRef.doc(element);
    curRef = docRef.collection("folders");
  });
  docRef = docRef.collection("tasks").doc(task.id);
  docRef.update({
    "done": task.done,
  });
}

Future<void> updateTask(Task task) async {

}

Future<void> deleteTask(Task task) async {

}