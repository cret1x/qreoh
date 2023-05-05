import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/firebase_functions/tasks.dart';

class TaskListStateNotifier extends StateNotifier<List<Task>> {
  TaskListStateNotifier() : super([]);
  final FirebaseTaskManager firebaseTaskManager = FirebaseTaskManager();

  void addTask(Task task, bool isOnline) async {
    await firebaseTaskManager.createTask(task, isOnline);
    state = [...state, task];
  }

  void deleteTask(Task task, bool isOnline) async {
    await firebaseTaskManager.deleteTask(task, isOnline);
    state = [
      for (final todo in state)
        if (todo.id != task.id) todo,
    ];
  }

  void toggleTask(Task task, bool isOnline) async {
    await firebaseTaskManager.changeTaskState(task, isOnline);
    state = [
      for (final todo in state)
        if (todo.id == task.id)
          todo.copyWith(done: task.done)
        else
          todo,
    ];
  }

  void updateTask(Task task, bool isOnline) async {
    await firebaseTaskManager.updateTask(task, isOnline);

  }

  void loadTasksFromFolder(Folder folder, bool isOnline) async {
    state = await firebaseTaskManager.getTasksInFolder(folder, isOnline);
  }
}