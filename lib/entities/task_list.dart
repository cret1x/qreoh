import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/task.dart';
import 'package:uuid/uuid.dart';

class TaskList extends StateNotifier<List<Task>> {
  TaskList([List<Task>? initialTasks]) : super(initialTasks ?? []);

  void add(Task task) {
    state = [
      ...state,
      task
    ];
  }

  void edit(Task task) {

  }
}