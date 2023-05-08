import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/global_providers.dart';
import 'create_edit_task_widget.dart';
import 'task_manager_widget.dart';
import '../../entities/task.dart';

class TaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final firebaseTaskManager = FirebaseTaskManager();

  TaskWidget({super.key, required this.task});

  @override
  ConsumerState<TaskWidget> createState() => TaskState();
}

class TaskState extends ConsumerState<TaskWidget> {
  bool _isSelected = false;
  List<Tag> _allTags = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _isSelected = widget.task.done;
    });
  }

  @override
  Widget build(BuildContext context) {
    _allTags = ref.watch(userTagsProvider);
    final tags = _allTags
        .where((element) => widget.task.tags.contains(element.id))
        .toList();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Wrap(
            runSpacing: 6,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.task.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Theme(
                      data: ThemeData(
                          unselectedWidgetColor:
                              Theme.of(context).colorScheme.primary),
                      child: Checkbox(
                        shape: const CircleBorder(),
                        checkColor: Colors.white,
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: _isSelected,
                        onChanged: (bool? state) {
                          setState(() {
                            widget.task.done = state!;
                            widget.firebaseTaskManager
                                .changeTaskState(widget.task);
                            _isSelected = widget.task.done;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: widget.task.stringDate.isNotEmpty,
                child: const Divider(),
              ),
              Visibility(
                visible: widget.task.stringDate.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Deadline",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.task.stringDate)
                  ],
                ),
              ),
              Visibility(
                visible: widget.task.stringTimeLeft.isNotEmpty,
                child: const Divider(),
              ),
              Visibility(
                visible: widget.task.stringTimeLeft.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Time left",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.task.stringTimeLeft)
                  ],
                ),
              ),
              Visibility(
                visible: widget.task.stringTimeRequired != null,
                child: const Divider(),
              ),
              Visibility(
                visible: widget.task.stringTimeRequired != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Required time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.task.stringTimeRequired ?? ""),
                  ],
                ),
              ),
              Visibility(
                visible: widget.task.place != null,
                child: const Divider(),
              ),
              Visibility(
                visible: widget.task.place != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.task.place ?? ""),
                  ],
                ),
              ),
              Visibility(
                visible: widget.task.description != null,
                child: const Divider(),
              ),
              Visibility(
                visible: widget.task.description != null,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(widget.task.description ?? ""),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Path",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.task.path)
                ],
              ),
              Visibility(
                visible: tags.isNotEmpty,
                child: const Divider(),
              ),
              Visibility(
                visible: tags.isNotEmpty,
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tags",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Wrap(
                spacing: 10,
                children: tags.map(
                  (tag) {
                    return InputChip(
                        avatar: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          foregroundColor: tag.color,
                          child: Icon(
                            tag.icon,
                            size: 20,
                          ),
                        ),
                        label: Text(tag.name),
                        onPressed: () {},
                        backgroundColor:
                            Theme.of(context).chipTheme.backgroundColor,);
                  },
                ).toList(),
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          int? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCreateTaskWidget(
                                  widget.task.parent, widget.task),
                            ),
                          );
                          if (result == null) {
                            return;
                          }
                          if (result < 0) {
                            Navigator.pop(context);
                          } else {
                            setState(() {});
                          }
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
