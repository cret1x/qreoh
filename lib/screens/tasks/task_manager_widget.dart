import 'package:flutter/material.dart';
import 'create_edit_task_widget.dart';
import 'filter_widget.dart';
import '../../entities/tag.dart';
import '../../entities/filter.dart';
import 'task_comparators.dart';
import 'task_list_widget.dart';
import '../../entities/folder.dart';

class TaskManagerWidget extends StatefulWidget {
  Folder _current;
  List<Tag> _tags;
  SortRule _sortRule = SortRule.leftAsc;
  final Filter _filter = Filter();

  TaskManagerWidget(this._current, this._tags, {super.key});

  List<Tag> getTags() {
    return _tags;
  }

  Filter getFilter() {
    return _filter;
  }

  Folder getCurrentFolder() {
    return _current;
  }

  SortRule getSortRule() {
    return _sortRule;
  }

  @override
  State<StatefulWidget> createState() {
    return TaskManagerState();
  }
}

class TaskManagerState extends State<TaskManagerWidget> {
  static const List<DropdownMenuItem<SortRule>> _menu_items = [
    DropdownMenuItem(value: SortRule.leftAsc, child: Text("Time left ▲")),
    DropdownMenuItem(value: SortRule.leftDesc, child: Text("Time left ▼")),
    DropdownMenuItem(value: SortRule.nameAZ, child: Text("Name A-Z")),
    DropdownMenuItem(value: SortRule.nameZA, child: Text("Name Z-A")),
    DropdownMenuItem(value: SortRule.priorityAsc, child: Text("Priority ▲")),
    DropdownMenuItem(value: SortRule.priorityDesc, child: Text("Priority ▼")),
    DropdownMenuItem(value: SortRule.estimation, child: Text("Recommended"))
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                          height: 40,
                          padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius:
                                      BorderRadiusDirectional.circular(12)),
                              child: Center(
                                  child: Text(widget._current.getName(),
                                      style: const TextStyle(
                                          color: Colors.black)))))),
                  SizedBox(
                      height: 40,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadiusDirectional.circular(12)),
                          child: Center(
                              child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.folder_open),
                            color: Colors.white,
                          ))))
                ],
              ),
              Row(children: [
                Expanded(
                    child: Container(
                        height: 52,
                        padding: const EdgeInsets.fromLTRB(0, 12, 12, 0),
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius:
                                    BorderRadiusDirectional.circular(12)),
                            child: Center(
                                child: DropdownButton<SortRule>(
                                    hint: const Text("Sort rule"),
                                    value: widget._sortRule,
                                    items: _menu_items,
                                    onChanged: (SortRule? value) {
                                      widget._sortRule = value!;
                                      setState(() {});
                                    }))))),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 12, 12, 0),
                    height: 52,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadiusDirectional.circular(12)),
                        child: Center(
                            child: IconButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FilterWidget(widget)));
                            setState(() {});
                          },
                          icon: const Icon(Icons.filter_alt_outlined),
                          color: Colors.white,
                        )))),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 12, 12, 0),
                    height: 52,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadiusDirectional.circular(12)),
                        child: Center(
                            child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.label_important),
                          color: Colors.white,
                        )))),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                    height: 52,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadiusDirectional.circular(12)),
                        child: Center(
                            child: IconButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditCreateTaskWidget(
                                        widget, widget._current)));
                            setState(() {});
                          },
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                        ))))
              ]),
              TaskListWidget(widget)
            ])));
  }
}
