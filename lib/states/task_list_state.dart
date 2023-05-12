
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/strings.dart';

class TaskListRebuildNotifier with ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class TaskListStateNotifier extends StateNotifier<List<Task>> {
  final Ref ref;
  TaskListStateNotifier(this.ref) : super([]);
  final FirebaseTaskManager firebaseTaskManager = FirebaseTaskManager();

  void addTask(Folder folder, Task task) async {
    await firebaseTaskManager.createTask(task);
    if (task.parent.id == folder.id) {
      state = [...state, task];
    }
    await ref.read(userStateProvider.notifier).loadFromDB();
    if (task.from == null) {
      final created = ref.read(userStateProvider)!.tasksCreated;
      await ref.read(userStateProvider.notifier).updateStats(tasksCreated: created + 1);
    } else {
      final created = ref.read(userStateProvider)!.tasksFriendsCreated;
      await ref.read(userStateProvider.notifier).updateStats(tasksFriendsCreated: created + 1);
    }

  }

  void deleteTask(Task task) async {
    await firebaseTaskManager.deleteTask(task);
    state = [
      for (final todo in state)
        if (todo.id != task.id) todo,
    ];
  }

  Future<void> toggleTask(Task task) async {
    await firebaseTaskManager.changeTaskState(task);
    await ref.read(userStateProvider.notifier).loadFromDB();
    if (task.from == null) {
      final completed = ref.read(userStateProvider)!.tasksCompleted;
      if (task.done) {
        ref.read(userStateProvider.notifier).updateStats(tasksCompleted: completed + 1);
        ref.read(userStateProvider.notifier).addXp(Strings.xpRewardTask);
        ref.read(userStateProvider.notifier).addMoney(Strings.moneyRewardTask);
      } else {
        ref.read(userStateProvider.notifier).updateStats(tasksCompleted: completed - 1);
      }
    } else {
      final completed = ref.read(userStateProvider)!.tasksFriendsCompleted;
      if (task.done) {
        ref.read(userStateProvider.notifier).addXp(Strings.xpRewardFriendTask);
        ref.read(userStateProvider.notifier).addMoney(Strings.moneyRewardFriendTask);
        ref.read(userStateProvider.notifier).updateStats(tasksFriendsCompleted: completed + 1);
      } else {
        ref.read(userStateProvider.notifier).updateStats(tasksFriendsCompleted: completed - 1);
      }
    }
    state = [
      for (final todo in state)
        if (todo.id == task.id) todo.copyWith(done: task.done) else todo,
    ];
  }

  void updateTask(Folder folder, Task task) async {
    await firebaseTaskManager.updateTask(task);
    List<Task> newState = [];
    for (final todo in state) {
      if (todo.id == task.id) {
        if (task.parent.id == folder.id) {
          newState.add(todo.copyWith(
              parent: task.parent,
              name: task.name,
              priority: task.priority,
              done: task.done,
              haveTime: task.haveTime,
              tags: task.tags));
        }
      } else {
        newState.add(todo);
      }
    }
    state = newState;
  }

  void loadTasksFromFolder(Folder folder) async {
    firebaseTaskManager.getTasksInFolder(folder).then((value) {
      if (mounted) {
        state = value;
      }
    });
  }
}
