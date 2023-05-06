import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qreoh/entities/folder.dart';

import '../entities/task.dart';

class FirebaseTaskManager {
  final db = FirebaseFirestore.instance;
  static final FirebaseTaskManager _singleton = FirebaseTaskManager._internal();

  factory FirebaseTaskManager() {
    return _singleton;
  }

  FirebaseTaskManager._internal();

  Future<void> createTask(Task task) async {
    final tasksRef = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tasks");
    tasksRef.doc(task.id).set(task.toFirestore());
  }

  Future<List<Task>> getTasksInFolder(Folder folder) async {
    List<Task> tasks = [];
    final tasksRef = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tasks")
        .where("parentId", isEqualTo: folder.id);
    final tasksCollection = await tasksRef.get();
    for (var element in tasksCollection.docs) {
      tasks.add(Task.fromFirestore(element.data(), folder));
    }
    return tasks;
  }

  Future<void> changeTaskState(Task task) async {
    final taskRef =
        db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection("tasks").doc(task.id);
    taskRef.update({
      "done": task.done,
    });
  }

  Future<void> updateTask(Task task) async {
    final tasksRef = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tasks");
    tasksRef.doc(task.id).set(task.toFirestore());
  }

  Future<void> deleteTask(Task task) async {
    final taskRef = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tasks");
    taskRef.doc(task.id).delete();
  }

  Future<List<Folder>> getSubFolders(Folder folder) async {
    List<Folder> folders = [];
    final foldersRef = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("folders")
        .where("parent", isEqualTo: folder.id);
    final foldersCollection = await foldersRef.get();
    for (var element in foldersCollection.docs) {
      folders.add(
          Folder.fromFirestore(element.id, element.data()['name'], folder));
    }
    return folders;
  }

  Future<void> createFolder(Folder folder) async {
    final foldersRef = db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection("folders");
    foldersRef.doc(folder.id).set(folder.toFirestore());
  }

  Future<void> deleteFolder(Folder folder) async {
    final foldersRef = db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection("folders");
    foldersRef.doc(folder.id).delete();
  }

  Future<void> updateFolder(Folder folder) async {
    final foldersRef = db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection("folders");
    foldersRef.doc(folder.id).set(folder.toFirestore());
  }

  Future<String> reloadName(Folder folder) async {
    final foldersRef = db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection("folders");
    final doc = await foldersRef.doc(folder.id).get();
    return doc.data()!['name'];
  }
}
