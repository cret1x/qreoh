
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/user_state.dart';

class TaskListStateNotifier extends StateNotifier<List<Task>> {
  final Ref ref;
  UserState? _user;
  TaskListStateNotifier(this.ref) : super([]) {
    Folder folder = ref.watch(folderStateProvider);
    _user = ref.watch(userStateProvider);
    loadTasksFromFolder(folder);
  }
  final FirebaseTaskManager firebaseTaskManager = FirebaseTaskManager();

  @override
  void dispose() {
    print('TASK LIST STATE DISPOSE');
    super.dispose();
  }

  void addTask(Folder folder, Task task) async {
    firebaseTaskManager.createTask(task);
    if (task.parent.id == folder.id) {
      state = [...state, task];
    }
    if (_user == null) {
      return;
    }
    final user = _user!;
    if (task.from == null) {
      final created = user.tasksCreated;
      ref.read(userStateProvider.notifier).updateStats(tasksCreated: created + 1);
    } else {
      final created = user.tasksFriendsCreated;
      ref.read(userStateProvider.notifier).updateStats(tasksFriendsCreated: created + 1);
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
    // state = [
    //   for (final todo in state)
    //     if (todo.id == task.id) todo.copyWith(done: task.done) else todo,
    // ];
    firebaseTaskManager.changeTaskState(task);
    if (_user == null) {
      return;
    }
    final user = _user!;
    if (task.from == null) {
      final completed = user.tasksCompleted;
      if (task.done) {
        ref.read(userStateProvider.notifier).updateStats(tasksCompleted: completed + 1);
        ref.read(userStateProvider.notifier).addXp(50);
      } else {
        ref.read(userStateProvider.notifier).updateStats(tasksCompleted: completed - 1);
      }
    } else {
      final completed = user.tasksFriendsCompleted;
      if (task.done) {
        ref.read(userStateProvider.notifier).addXp(100);
        ref.read(userStateProvider.notifier).updateStats(tasksFriendsCompleted: completed + 1);
      } else {
        ref.read(userStateProvider.notifier).updateStats(tasksFriendsCompleted: completed - 1);
      }
    }
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
    print('LOADING TASKS FROM DB folder: ${folder.name}');
    firebaseTaskManager.getTasksInFolder(folder).then((value) {
      if (mounted) {
        state = value;
      }
    });
  }
}
