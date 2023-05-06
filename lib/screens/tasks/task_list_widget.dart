import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/common_widgets/task_item.dart';
import 'package:qreoh/entities/filter.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/global_providers.dart';
import 'task_comparators.dart';
import 'task_manager_widget.dart';
import 'task_widget.dart';
import 'tag_widget.dart';
import '../../entities/task.dart';

class TaskListWidget extends ConsumerStatefulWidget {
  final Folder folder;
  final SortRule sort;

  TaskListWidget({
    super.key,
    required this.folder,
    required this.sort,
  });

  @override
  ConsumerState<TaskListWidget> createState() {
    return TaskListState();
  }
}

class TaskListState extends ConsumerState<TaskListWidget> {
  bool _isOnline = false;
  List<Task> _taskList = [];

  @override
  Widget build(BuildContext context) {
    Filter filter = ref.watch(tasksFilterProvider);
    _isOnline = ref.watch(networkStateProvider);
    _taskList = ref.watch(taskListStateProvider);
    ref
        .read(taskListStateProvider.notifier)
        .loadTasksFromFolder(widget.folder);
    List<Task> tasks = _taskList.where(filter.check).toList();
    tasks.sort(getFunc(widget.sort));
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        child: _taskList.isNotEmpty
            ? ListView.separated(
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: tasks.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return TaskItemWidget(task: tasks[index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('У вас пока нет заданий.'),
                  ],
                ),
              ),
      ),
    );
  }
}
