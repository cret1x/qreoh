import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/tasks/folders_widget.dart';
import 'create_edit_task_widget.dart';
import 'filter_widget.dart';
import 'task_comparators.dart';
import 'task_list_widget.dart';
import '../../entities/folder.dart';

class TaskManagerWidget extends ConsumerStatefulWidget {
  final _firebaseTaskManager = FirebaseTaskManager();

  TaskManagerWidget({super.key});

  @override
  ConsumerState<TaskManagerWidget> createState() => _TaskManagerState();
}

class _TaskManagerState extends ConsumerState<TaskManagerWidget> {
  Folder _current = Folder(id: "root", name: "Общее", parent: null);
  SortRule _sortRule = SortRule.leftAsc;
  static final List<DropdownMenuItem<SortRule>> _menuItems = [
    DropdownMenuItem(
        value: SortRule.leftAsc, child: getDropdownListItem("Time left ▲")),
    DropdownMenuItem(
        value: SortRule.leftDesc, child: getDropdownListItem("Time left ▼")),
    DropdownMenuItem(
        value: SortRule.nameAZ, child: getDropdownListItem("Name A-Z")),
    DropdownMenuItem(
        value: SortRule.nameZA, child: getDropdownListItem("Name Z-A")),
    DropdownMenuItem(
        value: SortRule.priorityAsc, child: getDropdownListItem("Priority ▲")),
    DropdownMenuItem(
        value: SortRule.priorityDesc, child: getDropdownListItem("Priority ▼")),
    DropdownMenuItem(
        value: SortRule.estimation, child: getDropdownListItem("Estimated"))
  ];

  static Widget getDropdownListItem(String text) {
    return Center(
      child: Text(
        text,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.read(userTagsProvider.notifier).loadTags();
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Image(
            image: AssetImage(
                Theme.of(context).colorScheme.brightness == Brightness.light
                    ? "graphics/background2.jpg"
                    : "graphics/background5.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              SizedBox(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 16, bottom: 4),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 2.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 12, 0),
                                      child: Center(
                                        child: FutureBuilder(
                                          future: widget._firebaseTaskManager
                                              .reloadName(_current),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              _current.rename(snapshot.data!);
                                              return Text(_current.name);
                                            }
                                            return const CircularProgressIndicator();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius:
                                          BorderRadiusDirectional.circular(12),
                                    ),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () async {
                                          Folder? newFolder =
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FoldersWidget(
                                                              _current)));
                                          if (newFolder != null) {
                                            _current = newFolder;
                                          }
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.folder_open),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 52,
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 12, 12, 4),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 2.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 12, left: 18),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<SortRule>(
                                            alignment: Alignment.center,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            isExpanded: true,
                                            iconSize: 0.0,
                                            value: _sortRule,
                                            items: _menuItems,
                                            onChanged: (SortRule? value) {
                                              setState(() {
                                                _sortRule = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 12, 12, 0),
                                  height: 52,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                12)),
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
                                        icon: const Icon(
                                            Icons.filter_alt_outlined),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 12, 12, 0),
                                    height: 52,
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                BorderRadiusDirectional
                                                    .circular(12)),
                                        child: Center(
                                            child: IconButton(
                                          onPressed: () {},
                                          icon:
                                              const Icon(Icons.label_important),
                                          color: Colors.white,
                                        )))),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                  height: 52,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                12)),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditCreateTaskWidget(
                                                      _current, null),
                                            ),
                                          );
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.add),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: TaskListWidget(
                      folder: _current,
                      sort: _sortRule,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
