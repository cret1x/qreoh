import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/tasks/folders/folders_widget.dart';
import 'package:qreoh/screens/tasks/tags/tags_widget.dart';
import 'package:qreoh/states/app_theme_state.dart';
import 'create_edit_task_widget.dart';
import '../filter/filter_widget.dart';
import 'task_comparators.dart';
import 'task_list_widget.dart';
import '../../../entities/folder.dart';

class TaskManagerWidget extends ConsumerStatefulWidget {
  final _firebaseTaskManager = FirebaseTaskManager();

  TaskManagerWidget({super.key});

  @override
  ConsumerState<TaskManagerWidget> createState() => _TaskManagerState();
}

class _TaskManagerState extends ConsumerState<TaskManagerWidget>
    with AutomaticKeepAliveClientMixin {
  Folder _current = Folder(id: "root", name: "Общее", parent: null);
  AppThemeState _appThemeState = AppThemeState.base();
  SortRule _sortRule = SortRule.leftAsc;
  static final List<DropdownMenuItem<SortRule>> _menuItems = [
    DropdownMenuItem(
        value: SortRule.leftAsc, child: getDropdownListItem("Осталось ▲")),
    DropdownMenuItem(
        value: SortRule.leftDesc, child: getDropdownListItem("Осталось ▼")),
    DropdownMenuItem(
        value: SortRule.nameAZ, child: getDropdownListItem("Название ▲")),
    DropdownMenuItem(
        value: SortRule.nameZA, child: getDropdownListItem("Название ▼")),
    DropdownMenuItem(
        value: SortRule.priorityAsc, child: getDropdownListItem("Приоритет ▲")),
    DropdownMenuItem(
        value: SortRule.priorityDesc, child: getDropdownListItem("Приоритет ▼")),
    DropdownMenuItem(
        value: SortRule.estimation, child: getDropdownListItem("Оценка"))
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
    ref.read(taskListStateProvider.notifier).loadTasksFromFolder(_current);
    ref.read(userTagsProvider.notifier).loadTags();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('TASK MANAGER BUILD');
    _current = ref.watch(folderStateProvider);
    ref.listen(folderStateProvider, (previous, next) {
      ref.read(taskListStateProvider.notifier).loadTasksFromFolder(next);
      ref.read(userTagsProvider.notifier).loadTags();
    });
    _appThemeState = ref.watch(appThemeProvider);
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Image(
            image: Theme.of(context).colorScheme.brightness == Brightness.light
                ? _appThemeState.lightBackground
                : _appThemeState.darkBackground,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: FutureBuilder(
            future: widget._firebaseTaskManager.reloadFolder(_current),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.name != _current.name) {
                _current.rename(snapshot.data!.name);
              }

              return Column(
                children: [
                  SizedBox(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            child: snapshot.hasData
                                                ? Text(snapshot.data!.name, style: const TextStyle( fontSize: 16),)
                                                : Transform.scale(
                                                    scale: 0.6,
                                                    child:
                                                        const CircularProgressIndicator(),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  12),
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
                                                ref
                                                    .read(folderStateProvider
                                                        .notifier)
                                                    .changeFolder(newFolder);
                                              }
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
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 12, 12, 4),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 12, 12, 0),
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
                                            onPressed: () async {
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FilterWidget()));
                                            },
                                            icon: const Icon(
                                                Icons.filter_alt_outlined),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 12, 12, 0),
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
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TagsWidget(),
                                                ),
                                              );
                                              ref
                                                  .read(taskListStateProvider
                                                      .notifier)
                                                  .loadTasksFromFolder(
                                                      _current);
                                            },
                                            icon: const Icon(
                                                Icons.label_important_outline),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 12, 0, 0),
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
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditCreateTaskWidget(
                                                          _current, null),
                                                ),
                                              );
                                              ref
                                                  .read(taskListStateProvider
                                                      .notifier)
                                                  .loadTasksFromFolder(
                                                      _current);
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
                          folder: snapshot.hasData ? snapshot.data! : _current,
                          sort: _sortRule,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
