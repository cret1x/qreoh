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
  final FirebaseTaskManager firebaseTaskManager = FirebaseTaskManager();

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
  @override
  Widget build(BuildContext context) {
    Filter filter = ref.watch(tasksFilterProvider);
    return FutureBuilder(
        future: widget.firebaseTaskManager.getTasksInFolder(widget.folder),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Task> tasks = snapshot.data!.where(filter.check).toList();
            tasks.sort(getFunc(widget.sort));
            return SizedBox(
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: tasks.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return TaskItemWidget(task: tasks[index]);
                            }))));
          } else {
            return const Center(
              child: Text("No tasks"),
            );
          }
        });
  }
}
