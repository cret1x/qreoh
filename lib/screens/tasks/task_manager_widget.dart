import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/global_providers.dart';
import 'create_edit_task_widget.dart';
import 'filter_widget.dart';
import '../../entities/tag.dart';
import '../../entities/filter.dart';
import 'task_comparators.dart';
import 'task_list_widget.dart';
import '../../entities/folder.dart';

class TaskManagerWidget extends ConsumerStatefulWidget {
  const TaskManagerWidget({super.key});

  @override
  ConsumerState<TaskManagerWidget> createState() => _TaskManagerState();
}

class _TaskManagerState extends ConsumerState<TaskManagerWidget> {
  Folder _current = Folder("root", null);
  SortRule _sortRule = SortRule.leftAsc;
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
  void initState() {
    super.initState();
  }

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
                                  child: Text(_current.getName(),
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
                                    value: _sortRule,
                                    items: _menu_items,
                                    onChanged: (SortRule? value) {
                                      setState(() {
                                        _sortRule = value!;
                                      });
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
                                        FilterWidget()));
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
                                    builder: (context) => EditCreateTaskWidget(_current)));
                            setState(() {});
                          },
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                        ))))
              ]),
              TaskListWidget(
                folder: _current,
                sort: _sortRule,
              ),
            ])));
  }
}
