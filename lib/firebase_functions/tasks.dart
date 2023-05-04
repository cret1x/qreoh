import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/entities/user_entity.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../entities/task.dart';


class FirebaseTaskManager {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  DatabaseFactory dbFactory = databaseFactoryIo;
  late final Database localDB;
  late final StoreRef<String, Map<String, dynamic>> store;
  static final FirebaseTaskManager _singleton = FirebaseTaskManager._internal();

  factory FirebaseTaskManager() {
    return _singleton;
  }

  FirebaseTaskManager._internal() {
    openLocalDB();
    _connectivity.onConnectivityChanged.listen(_checkStatus);
  }

  final _connectivity = Connectivity();

  bool isOnline = false;

  void _checkStatus(ConnectivityResult result) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
  }

  // {"root": {"tasks": [<Task1>, <Task2>], "folders": [
  // "folder1" : {"tasks": [], "folders": []},
  // ]}}

  void openLocalDB() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'user.db');
    localDB = await dbFactory.openDatabase(dbPath, version: 1, onVersionChanged: (db, oldVer, newVer) async {
      if (oldVer == 0) {
        await store.add(db, {"tasks": {"root": {"tasks": [], "folders": {}}}});
      }
    });
    store = StoreRef.main();
    var record = store.record("tasks");
    var tree = await record.get(localDB);
    print(tree);
  }

  Future<void> createTask(Task task) async {
    String pathString = task.parent.getPath();
    if (isOnline) {
      final tasksRef = db.collection('users').doc(uid).collection("tasks");
      CollectionReference curRef = tasksRef;
      late DocumentReference docRef;
      pathString.substring(0, pathString.length - 1).split('/').forEach((element) {
        docRef = curRef.doc(element);
        curRef = docRef.collection("folders");
      });
      docRef = docRef.collection("tasks").doc(task.id);
      docRef.set(
        task.toFirestore(),
      );
    } else {
      var record = store.record("tasks");
      var tree = await record.get(localDB);

      var curFolder = tree!['root'];
      pathString.substring(0, pathString.length - 1).split('/').skip(1).forEach((element) {
        if (!(curFolder['folders'] as Map).containsKey(element)) {
          (curFolder['folders'] as Map)[element] = {"tasks": [], "folders": []};
        }
        curFolder = curFolder['folders'][element];
      });
      (curFolder['tasks'] as List).add(task.toFirestore());
    }
  }

  Future<List<Task>> getTasksInFolder(Folder folder) async {
    String pathString = folder.getPath();
    List<Task> tasks = [];
    if (isOnline) {
      final tasksRef = db.collection('users').doc(uid).collection("tasks");
      CollectionReference curRef = tasksRef;
      late DocumentReference docRef;
      pathString.substring(0, pathString.length - 1).split('/').forEach((element) {
        docRef = curRef.doc(element);
        curRef = docRef.collection("folders");
      });
      final tasksCollection = await docRef.collection("tasks").get();
      for (var element in tasksCollection.docs) {
        tasks.add(Task.fromFirestore(element.data(), folder));
      }
    } else {
      var record = store.record("tasks");
      var tree = await record.get(localDB);
      var curFolder = tree!['root'];
      pathString.substring(0, pathString.length - 1).split('/').skip(1).forEach((element) {
        if (!(curFolder['folders'] as Map).containsKey(element)) {
          (curFolder['folders'] as Map)[element] = {"tasks": [], "folders": []};
        }
        curFolder = curFolder['folders'][element];
      });
      for (var elem in (curFolder['tasks'] as List)) {
        tasks.add(Task.fromFirestore(elem, folder));
      }
    }
    return tasks;
  }

  Future<void> changeTaskState(Task task) async {
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
}