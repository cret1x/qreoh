import 'package:flutter/material.dart';
import 'task_comparators.dart';
import 'task_manager_widget.dart';
import 'task_widget.dart';
import 'tag_widget.dart';
import '../../entities/task.dart';

class TaskListWidget extends StatefulWidget {
  final TaskManagerWidget _parent;
  late List<Task> _tasks;

  TaskListWidget(this._parent, {super.key});

  @override
  State<StatefulWidget> createState() {
    return TaskListState();
  }
}

class TaskListState extends State<TaskListWidget> {
  @override
  Widget build(BuildContext context) {
    widget._tasks = widget._parent
        .getCurrentFolder()
        .getTasks()
        .where(widget._parent.getFilter().check)
        .toList();
    widget._tasks.sort(getFunc(widget._parent.getSortRule()));
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget._tasks.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskWidget(
                                widget._parent, widget._tasks[index])));
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
                                value: widget._tasks[index].getState(),
                                onChanged: (bool? state) => {
                                      widget._tasks[index].setState(state),
                                      setState(() {})
                                    }),
                            Column(
                              children: [
                                Text(widget._tasks[index].getName()),
                                TagsWidget(widget._tasks[index].getTags())
                              ],
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget._tasks[index].getDate()),
                            widget._tasks[index].getTextPriority()
                          ],
                        )
                      ],
                    ),
                  )));
        });
  }
}
