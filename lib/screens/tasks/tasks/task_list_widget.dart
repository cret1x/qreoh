import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/screens/tasks/tasks/task_item.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/global_providers.dart';
import '../../../states/task_list_state.dart';
import 'task_comparators.dart';
import '../../../entities/task.dart';

class TaskListWidget extends ConsumerStatefulWidget {
  final Folder folder;
  final SortRule sort;

  const TaskListWidget({
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
  List<Task> _taskList = [];

  @override
  Widget build(BuildContext context) {
    ref.read(tasksListRebuildProvider).addListener(() { 
      setState(() {});
    });
    _taskList = ref.read(taskListStateProvider);
    ref.watch(tasksFilterProvider);
    List<Task> tasks = _taskList.where(ref.read(tasksFilterProvider.notifier).check).toList();
    tasks.sort(getFunc(widget.sort));
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        child: tasks.isNotEmpty
            ? ListView.separated(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: tasks.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return TaskItemWidget(originFolder: widget.folder, task: tasks[index]);
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
