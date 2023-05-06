import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/global_providers.dart';
import 'create_edit_task_widget.dart';
import 'task_manager_widget.dart';
import '../../entities/task.dart';

class TaskWidget extends ConsumerStatefulWidget {
  final Task task;

  const TaskWidget({super.key, required this.task});

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
    final tags = _allTags.where((element) => widget.task.tags.contains(element.id)).toList();
    return Material(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back)),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.share)),
                        ]),
                    SizedBox(
                      height: 70,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadiusDirectional.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.task.name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Transform.scale(
                                scale: 1.5,
                                child: Theme(
                                  data: ThemeData(
                                      unselectedWidgetColor: Colors.white),
                                  child: Checkbox(
                                    shape: const CircleBorder(),
                                    checkColor: Colors.blue,
                                    activeColor: Colors.white,
                                    value: _isSelected,
                                    onChanged: (bool? state) {
                                      widget.task.done = state!;
                                      setState(() {
                                        _isSelected = widget.task.done;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: widget.task.stringDate.isNotEmpty,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Deadline",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54)),
                              Text(widget.task.stringDate)
                            ])),
                    Visibility(
                        visible: widget.task.stringTimeLeft.isNotEmpty,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Time left",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54)),
                              Text(widget.task.stringTimeLeft)
                            ])),
                    Visibility(
                        visible: widget.task.stringTimeRequired != null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Required time",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                            Text(widget.task.stringTimeRequired ?? ""),
                          ],
                        )),
                    Visibility(
                        visible: widget.task.place != null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Location",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                            Text(widget.task.place ?? ""),
                          ],
                        )),
                    Visibility(
                        visible: widget.task.description != null,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Description",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54)),
                        )),
                    Visibility(
                        visible: widget.task.description != null,
                        child: Row(
                          children: [
                            Flexible(
                                fit: FlexFit.loose,
                                child: Text(widget.task.description ?? ""),),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Path",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                        Text(widget.task.path)
                      ],
                    ),
                    Visibility(
                      visible: tags.isNotEmpty,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tags",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                      ),
                    ),
                    Visibility(
                        visible: tags.isNotEmpty,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: tags.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: [
                                  Icon(tags[index].icon),
                                  Text(tags[index].name),
                                ],
                              );
                            })),
                    Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                          height: 40,
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadiusDirectional.circular(12)),
                              child: TextButton(
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  int result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditCreateTaskWidget.edit(
                                                  widget.task)));
                                  if (result < 0) {
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {});
                                  }
                                },
                              )),
                        ))
                      ],
                    )
                  ],
                ))));
  }
}
