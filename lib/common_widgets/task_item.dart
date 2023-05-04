import 'package:flutter/material.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/screens/tasks/tag_widget.dart';
import 'package:qreoh/screens/tasks/task_widget.dart';

class TaskItemWidget extends StatefulWidget {
  final Task task;

  const TaskItemWidget({super.key, required this.task});

  @override
  State<StatefulWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.task.done;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    shape: const CircleBorder(),
                    value: _isSelected,
                    onChanged: (bool? state) {
                      widget.task.done = state ?? false;
                      changeTaskState(widget.task);
                      setState(() {
                        _isSelected = widget.task.done;
                      });
                    },
                  ),
                  Column(
                    children: [
                      Text(widget.task.name),
                      TagsWidget(widget.task.tags)
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
