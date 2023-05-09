import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/tasks/create_edit_task_widget.dart';
import 'package:qreoh/screens/tasks/tag_widget.dart';
import 'package:qreoh/screens/tasks/task_widget.dart';
import 'package:qreoh/states/user_tags_state.dart';

class TaskItemWidget extends ConsumerStatefulWidget {
  final Task task;
  final Folder originFolder;
  final FirebaseTaskManager firebaseTaskManager = FirebaseTaskManager();

  TaskItemWidget({super.key, required this.task, required this.originFolder});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends ConsumerState<TaskItemWidget> {
  List<Tag> _allTags = [];

  @override
  Widget build(BuildContext context) {
    _allTags = ref.watch(userTagsProvider);
    final tags = _allTags
        .where((element) => widget.task.tags.contains(element.id))
        .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
      child: Dismissible(
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditCreateTaskWidget(widget.task.parent, widget.task),
              ),
            );
            return false;
          }
          ref.read(taskListStateProvider.notifier).deleteTask(widget.task);
          ref.read(tasksListRebuildProvider).notify();
          return true;
        },
        secondaryBackground: const Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
        background: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              Icons.mode_edit_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        key: UniqueKey(),
        child: InkWell(
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskWidget(
                  task: widget.task,
                ),
              ),
            );
          },
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                Checkbox(
                  value: widget.task.done,
                  onChanged: (bool? state) {
                    setState(() {
                      widget.task.done = state ?? false;
                      ref.read(taskListStateProvider.notifier).toggleTask(widget.task);
                      //widget.firebaseTaskManager.changeTaskState(widget.task);
                    });
                  },
                ),
                Expanded(
                  child: widget.task.deadline != null ||
                          tags.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.task.name),
                                widget.task.textPriority,
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    height: 20,
                                    child: TagsWidget(tags),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(widget.task.stringDate)),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.task.name),
                            widget.task.textPriority,
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
