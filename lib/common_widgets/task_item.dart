import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/tasks/tag_widget.dart';
import 'package:qreoh/screens/tasks/task_widget.dart';
import 'package:qreoh/states/user_tags_state.dart';

class TaskItemWidget extends ConsumerStatefulWidget {
  final Task task;
  final FirebaseTaskManager firebaseTaskManager = FirebaseTaskManager();

  TaskItemWidget({super.key, required this.task});

  @override
  ConsumerState<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends ConsumerState<TaskItemWidget> {
  List<Tag> _allTags = [];

  @override
  Widget build(BuildContext context) {
    _allTags = ref.read(userTagsProvider);
    final tags =  _allTags
        .where((element) => widget.task.tags.contains(element.id))
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskWidget(
                task: widget.task,
              ),
            ),
          );
          ref.read(taskListStateProvider.notifier).loadTasksFromFolder(widget.task.parent);
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
                    widget.firebaseTaskManager.changeTaskState(widget.task);
                  });
                },
              ),
              Expanded(
                child: widget.task.deadline != null ||
                        widget.task.tags.isNotEmpty
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
    );
  }
}
