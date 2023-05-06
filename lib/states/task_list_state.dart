
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/firebase_functions/tasks.dart';

class TaskListStateNotifier extends StateNotifier<List<Task>> {
  TaskListStateNotifier() : super([]);
  final FirebaseTaskManager firebaseTaskManager = FirebaseTaskManager();

  void addTask(Task task) async {
    await firebaseTaskManager.createTask(task);
    state = [...state, task];
  }

  void deleteTask(Task task) async {
    await firebaseTaskManager.deleteTask(task);
    state = [
      for (final todo in state)
        if (todo.id != task.id) todo,
    ];
  }

  void toggleTask(Task task) async {
    await firebaseTaskManager.changeTaskState(task);
    state = [
      for (final todo in state)
        if (todo.id == task.id) todo.copyWith(done: task.done) else todo,
    ];
  }

  void updateTask(Task task) async {
    await firebaseTaskManager.updateTask(task);
    state = [
      for (final todo in state)
        if (todo.id == task.id)
          todo.copyWith(
              parent: task.parent,
              name: task.name,
              priority: task.priority,
              done: task.done,
              haveTime: task.haveTime,
              tags: task.tags)
        else
          todo,
    ];
  }

  void loadTasksFromFolder(Folder folder) async {
    state = await firebaseTaskManager.getTasksInFolder(folder);
  }
}
