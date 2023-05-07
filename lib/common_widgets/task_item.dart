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
    _allTags = ref.watch(userTagsProvider);
    final tags = _allTags.where((element) => widget.task.tags.contains(element.id)).toList();
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
          setState(() {});
        },
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    shape: const CircleBorder(),
                    value: widget.task.done,
                    onChanged: (bool? state) {
                      widget.firebaseTaskManager.changeTaskState(widget.task);
                      setState(() {
                        widget.task.done = state ?? false;
                      });
                    },
                  ),
                  Column(
                    children: [
                      Text(widget.task.name),
                      TagsWidget(tags)
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.task.stringDate),
                  widget.task.textPriority,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
