import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:path/path.dart';
import 'package:qreoh/global_providers.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:sembast/sembast_io.dart';

import '../entities/task.dart';


class FirebaseTaskManager {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  sembast.DatabaseFactory dbFactory = databaseFactoryIo;
  late final sembast.Database localDB;
  late final sembast.Database missedDB;
  late final sembast.Database foldersDB;
  late final sembast.Database tagsDB;
  late final sembast.StoreRef<String, Map<String, dynamic>> store;
  late WidgetRef ref;
  static final FirebaseTaskManager _singleton = FirebaseTaskManager._internal();

  factory FirebaseTaskManager() {
    return _singleton;
  }

  FirebaseTaskManager._internal() {
    openLocalDB();
  }



  void openLocalDB() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, uid, 'tasks.db');
    var missedDbPath = join(dir.path, uid, "missed.db");
    var foldersDbPath = join(dir.path, uid, "folders.db");
    var tagsDbPath = join(dir.path, uid, "tags.db");
    store = sembast.StoreRef.main();
    localDB = await dbFactory.openDatabase(dbPath);
    missedDB = await dbFactory.openDatabase(missedDbPath);
    foldersDB = await dbFactory.openDatabase(foldersDbPath);
    tagsDB = await dbFactory.openDatabase(tagsDbPath);
  }

  Future<void> createTask(Task task, bool isOnline) async {
    await store.record(task.id).add(localDB, {"folder": task.parent.id, "task": task.toFirestore()});
    if (isOnline) {
      final tasksRef = db.collection('users').doc(uid).collection("tasks");
      CollectionReference curRef = tasksRef;
      late DocumentReference docRef;
      task.parent.getIdPath().forEach((element) {
        docRef = curRef.doc(element);
        curRef = docRef.collection("folders");
      });
      docRef = docRef.collection("tasks").doc(task.id);
      docRef.set(
        task.toFirestore(),
      );
    } else {
      await store.record(task.id).add(missedDB, {"action": "add"});
    }
  }

  Future<List<Task>> getTasksInFolder(Folder folder, bool isOnline) async {
    List<Task> tasks = [];
    if (isOnline) {
      final tasksRef = db.collection('users').doc(uid).collection("tasks");
      CollectionReference curRef = tasksRef;
      late DocumentReference docRef;
      folder.getIdPath().forEach((element) {
        docRef = curRef.doc(element);
        curRef = docRef.collection("folders");
      });
      final tasksCollection = await docRef.collection("tasks").get();
      for (var element in tasksCollection.docs) {
        tasks.add(Task.fromFirestore(element.data(), folder));
      }
    } else {
      var finder = sembast.Finder(
          filter: sembast.Filter.equals('folder', folder.id));
      var records = await store.find(localDB, finder: finder);
      for (var element in records) {
        tasks.add(Task.fromFirestore(element.value['task'], folder));
      }
    }
    return tasks;
  }

  Future<void> changeTaskState(Task task, bool isOnline) async {
    await store.record(task.id).update(localDB, {'task.done': task.done});
    if (isOnline) {
      final tasksRef = db.collection('users').doc(uid).collection("tasks");
      CollectionReference curRef = tasksRef;
      late DocumentReference docRef;
      task.parent.getIdPath().forEach((element) {
        docRef = curRef.doc(element);
        curRef = docRef.collection("folders");
      });
      docRef = docRef.collection("tasks").doc(task.id);
      docRef.update({
        "done": task.done,
      });
    } else {
      await store.record(task.id).add(missedDB, {"action": "update"});
    }
  }

  Future<void> updateTask(Task task, bool isOnline) async {

  }

  Future<void> deleteTask(Task task, bool isOnline) async {
    await store.record(task.id).delete(localDB);
    if (isOnline) {
      final tasksRef = db.collection('users').doc(uid).collection("tasks");
      CollectionReference curRef = tasksRef;
      late DocumentReference docRef;
      task.parent.getIdPath().forEach((element) {
        docRef = curRef.doc(element);
        curRef = docRef.collection("folders");
      });
      docRef.collection("tasks").doc(task.id).delete();
    } else {
      await store.record(task.id).add(missedDB, {"action": "delete"});
    }
  }

  Future<List<Folder>> getSubFolders(Folder folder, bool isOnline) async {
    List<Folder> folders = [];
    if (isOnline) {
      final tasksRef = db.collection('users').doc(uid).collection("tasks");
      CollectionReference curRef = tasksRef;
      late DocumentReference docRef;
      folder.getIdPath().forEach((element) {
        docRef = curRef.doc(element);
        curRef = docRef.collection("folders");
      });
      final foldersCollection = await curRef.get();
      for (QueryDocumentSnapshot element in foldersCollection.docs) {
        Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
        folders.add(Folder.fromFirestore(element.id, data['name'], folder));
      }
    } else {
      var finder = sembast.Finder(
          filter: sembast.Filter.equals('parent', folder.id));
      var records = await store.find(foldersDB, finder: finder);
      for (var element in records) {
        folders.add(Folder.fromFirestore(element.key, element.value['name'], folder));
      }
    }
    return folders;
  }

  Future<void> createFolder(Folder folder, bool isOnline) async {
    await store.record(folder.id).add(foldersDB, {"name": folder.name, "parent": folder.parent?.id ?? "null"});
    if (isOnline) {
      final tasksRef = db.collection('users').doc(uid).collection("tasks");
      CollectionReference curRef = tasksRef;
      late DocumentReference docRef;
      folder.getIdPath().forEach((element) {
        docRef = curRef.doc(element);
        curRef = docRef.collection("folders");
      });
      curRef.doc(folder.id).set({
        "name": folder.name,
      });
    }
  }

  Future<void> deleteFolder(Folder folder, bool isOnline) async {

  }

  Future<void> updateFolder(Folder folder, bool isOnline) async {

  }
}