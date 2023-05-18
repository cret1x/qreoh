import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/firebase_functions/user.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/tasks/attachments/attachment_list.dart';
import 'package:qreoh/screens/tasks/share/share_task.dart';
import 'create_edit_task_widget.dart';
import 'task_manager_widget.dart';
import '../../../entities/task.dart';

class TaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final firebaseTaskManager = FirebaseTaskManager();
  final firebaseUserManager = FirebaseUserManager();

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
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShareTaskWidget(widget.task),
                  ),
                );
              },
              icon: const Icon(Icons.share)),
        ],
      ),
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
                            ref
                                .read(taskListStateProvider.notifier)
                                .toggleTask(widget.task)
                                .then((value) {
                              ref
                                  .read(tasksListRebuildProvider.notifier)
                                  .notify();
                            });
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
                      "Дедлайн",
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
                      "Осталось",
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
                      "Необходимое время",
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Место",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 44),
                    Flexible(child: Text(widget.task.place ?? ""),),
                  ],
                ),
              ),
              Visibility(
                visible: widget.task.description != null,
                child: const Divider(),
              ),
              Visibility(
                visible: widget.task.description != null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Описание",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: Text(
                        widget.task.description ?? "",
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Путь",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.task.path)
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Приложения",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AttachmentList(widget.task.attachments),
                        ),
                      );
                    },
                    child: Text("Посмотреть"),
                  ),
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
                    "Теги",
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
                          Theme.of(context).chipTheme.backgroundColor,
                    );
                  },
                ).toList(),
              ),
              Visibility(
                visible: widget.task.from != null,
                child: const Divider(),
              ),
              if (widget.task.from != null)
                Visibility(
                  visible: widget.task.from != null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Отправитель",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FutureBuilder(
                        future: widget.firebaseUserManager
                            .findUser(widget.task.from!),
                        builder: (context, snapshot) =>
                            snapshot.hasData && snapshot.data != null
                                ? Text(snapshot.data!)
                                : const CircularProgressIndicator(),
                      ),
                    ],
                  ),
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
                          "Редактировать",
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
