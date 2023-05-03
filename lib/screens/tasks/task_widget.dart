import 'package:flutter/material.dart';
import 'create_edit_task_widget.dart';
import 'task_manager_widget.dart';
import '../../entities/task.dart';

class TaskWidget extends StatefulWidget {
  final Task _task;
  final TaskManagerWidget _parent;

  const TaskWidget(this._parent, this._task, {super.key});

  @override
  State<StatefulWidget> createState() => TaskState(_task.getState());
}

class TaskState extends State<TaskWidget> {
  bool _isSelected;

  TaskState(this._isSelected);

  @override
  Widget build(BuildContext context) {
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
                              borderRadius:
                                  BorderRadiusDirectional.circular(12)),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget._task.getName(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    Transform.scale(
                                        scale: 1.5,
                                        child: Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor:
                                                    Colors.white),
                                            child: Checkbox(
                                                shape: const CircleBorder(),
                                                checkColor: Colors.blue,
                                                activeColor: Colors.white,
                                                value: _isSelected,
                                                onChanged: (bool? state) => {
                                                      widget._task
                                                          .setState(state),
                                                      setState(() {
                                                        _isSelected = widget
                                                            ._task
                                                            .getState();
                                                      })
                                                    }))),
                                  ])),
                        )),
                    Visibility(
                        visible: widget._task.getDate() != "",
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Deadline",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54)),
                              Text(widget._task.getDate())
                            ])),
                    Visibility(
                        visible: widget._task.getTimeLeft() != "",
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Time left",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54)),
                              Text(widget._task.getTimeLeft())
                            ])),
                    Visibility(
                        visible: widget._task.getStringTimeRequired() != null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Required time",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                            Text(widget._task.getStringTimeRequired() == null
                                ? ""
                                : widget._task.getStringTimeRequired()!)
                          ],
                        )),
                    Visibility(
                        visible: widget._task.getLocation() != null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Location",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                            Text(widget._task.getLocation() == null
                                ? ""
                                : widget._task.getLocation()!)
                          ],
                        )),
                    Visibility(
                        visible: widget._task.getDescription() != null,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Description",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54)),
                        )),
                    Visibility(
                        visible: widget._task.getDescription() != null,
                        child: Row(
                          children: [
                            Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                    widget._task.getDescription() == null
                                        ? ""
                                        : widget._task.getDescription()!))
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
                        Text(widget._task.getPath())
                      ],
                    ),
                    Visibility(
                      visible: widget._task.getTags().isNotEmpty,
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
                        visible: widget._task.getTags().isNotEmpty,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget._task.getTags().length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: [
                                  Icon(widget._task.getTags()[index].getIcon()),
                                  Text(widget._task.getTags()[index].getName()),
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
                                                  widget._parent,
                                                  widget._task)));
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
