import 'package:flutter/material.dart';
import '../../entities/tag.dart';
import '../../entities/task.dart';
import 'task_manager_widget.dart';
import '../../entities/filter.dart';

class FilterWidget extends StatefulWidget {
  final TaskManagerWidget _parent;

  const FilterWidget(this._parent, {super.key});

  @override
  State<StatefulWidget> createState() {
    return FilterState();
  }

}

class FilterState extends State<FilterWidget> {
  late bool _priorities;
  late bool _statuses;
  late bool _tags;

  void _changePriorityState(bool state, Priority priority) {
    if (state) {
      widget._parent.getFilter().priorities.add(priority);
    } else if (widget._parent.getFilter().priorities.contains(priority)) {
      widget._parent.getFilter().priorities.remove(priority);
    }
  }

  void _changeStatusState(bool state, bool status) {
    if (state) {
      widget._parent.getFilter().statuses.add(status);
    } else if (widget._parent.getFilter().statuses.contains(status)) {
      widget._parent.getFilter().statuses.remove(status);
    }
  }

  void _changeTagState(bool state, Tag tag) {
    if (state) {
      widget._parent.getFilter().tags.add(tag);
    } else if (widget._parent.getFilter().tags.contains(tag)) {
      widget._parent.getFilter().tags.remove(tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    _priorities = widget._parent.getFilter().priorities.length == 4;
    _statuses = widget._parent.getFilter().statuses.length == 2;
    _tags = widget._parent.getFilter().tags.length == widget._parent.getTags().length;
    return Material(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)
                  )
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      "Priority",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54
                      ),
                    )
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Divider()
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Checkbox(
                      value: _priorities,
                      onChanged: (bool? state) {
                        _priorities = state!;

                        _changePriorityState(state, Priority.high);
                        _changePriorityState(state, Priority.medium);
                        _changePriorityState(state, Priority.low);
                        _changePriorityState(state, Priority.none);

                        setState(() {});
                      }
                    )
                  )

                ]
              ),
              CheckboxListTile(
                title: const Text("High"),
                value: widget._parent.getFilter().priorities.contains(Priority.high),
                onChanged: (bool? state) {
                  if (state == null) {
                    return;
                  }
                  _changePriorityState(state, Priority.high);
                  setState(() {});
                }
              ),
              CheckboxListTile(
                  title: const Text("Medium"),
                  value: widget._parent.getFilter().priorities.contains(Priority.medium),
                  onChanged: (bool? state) {
                    if (state == null) {
                      return;
                    }
                    _changePriorityState(state, Priority.medium);
                    setState(() {});
                  }
              ),
              CheckboxListTile(
                  title: const Text("Low"),
                  value: widget._parent.getFilter().priorities.contains(Priority.low),
                  onChanged: (bool? state) {
                    if (state == null) {
                      return;
                    }
                    _changePriorityState(state, Priority.low);
                    setState(() {});
                  }
              ),
              CheckboxListTile(
                  title: const Text("None"),
                  value: widget._parent.getFilter().priorities.contains(Priority.none),
                  onChanged: (bool? state) {
                    if (state == null) {
                      return;
                    }
                    _changePriorityState(state, Priority.none);
                    setState(() {});
                  }
              ),
              Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Status",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54
                          )
                        )
                    ),
                    const Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Divider()
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Checkbox(
                          value: _statuses,
                          onChanged: (bool? state) {
                            _statuses = state!;

                            _changeStatusState(state, true);
                            _changeStatusState(state, false);

                            setState(() {});
                          }
                      )
                    )
                  ]
              ),
              CheckboxListTile(
                  title: const Text("Done"),
                  value: widget._parent.getFilter().statuses.contains(true),
                  onChanged: (bool? state) {
                    if (state == null) {
                      return;
                    }

                    _changeStatusState(state, true);

                    setState(() {});
                  }
              ),
              CheckboxListTile(
                  title: const Text("Not done"),
                  value: widget._parent.getFilter().statuses.contains(false),
                  onChanged: (bool? state) {
                    if (state == null) {
                      return;
                    }

                    _changeStatusState(state, false);

                    setState(() {});
                  }
              ),
              Row(
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                            "Tags",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54
                            )
                        )
                    ),
                    const Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Divider()
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Checkbox(
                        value: _tags,
                        onChanged: (bool? state) {
                          _tags = state!;

                          for (int i = 0; i < widget._parent.getTags().length; ++i) {
                            _changeTagState(state, widget._parent.getTags()[i]);
                          }

                          setState(() {});
                        }
                      )
                    ),
                  ]
              ),
              ListView.builder(
                  itemCount: widget._parent.getTags().length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        title: Text(widget._parent.getTags()[index].getName()),
                        secondary: Icon(widget._parent.getTags()[index].getIcon()),
                        value: widget._parent.getFilter().tags.contains(widget._parent.getTags()[index]),
                        onChanged: (bool? state) {
                          if (state == null) {
                            return;
                          }

                          _changeTagState(state, widget._parent.getTags()[index]);

                          setState(() {});
                        }
                    );
                  }
              )
            ]
          )
         )
      )
    );
  }
}