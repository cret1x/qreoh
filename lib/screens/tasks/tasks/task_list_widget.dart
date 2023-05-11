import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/common_widgets/task_item.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/global_providers.dart';
import '../../../states/task_list_state.dart';
import 'task_comparators.dart';
import '../../../entities/task.dart';

class TaskListWidget extends ConsumerStatefulWidget {
  final Folder folder;
  final SortRule sort;
  final List<Task> tasks;

  const TaskListWidget({
    super.key,
    required this.folder,
    required this.sort,
    required this.tasks,
  });

  @override
  ConsumerState<TaskListWidget> createState() {
    return TaskListState();
  }
}

class TaskListState extends ConsumerState<TaskListWidget> {
  @override
  void dispose() {
    print("TASK LIST DISPOSE");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('TASK LIST REBUILD');
    widget.tasks.sort(getFunc(widget.sort));
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        child: widget.tasks.isNotEmpty
            ? ListView.separated(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: widget.tasks.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return TaskItemWidget(originFolder: widget.folder, task: widget.tasks[index]);
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
