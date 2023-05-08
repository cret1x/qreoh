import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/task_filter_state.dart';
import '../../entities/tag.dart';
import '../../entities/task.dart';

class FilterWidget extends ConsumerStatefulWidget {
  const FilterWidget({super.key});

  @override
  ConsumerState<FilterWidget> createState() => _FilterState();
}

class _FilterState extends ConsumerState<FilterWidget> {
  late bool _priorities;
  late bool _statuses;
  late bool _tags;
  List<Tag> _allTags = [];
  List<String> _selectedTags = [];
  List<Priority> _selectedPriorities = [];
  List<bool> _selectedStatuses = [];

  @override
  Widget build(BuildContext context) {
    _priorities = ref.read(tasksFilterProvider).priorities.length == 4;
    _statuses = ref.read(tasksFilterProvider).statuses.length == 2;
    _tags = ref.read(tasksFilterProvider).tags.length ==
        ref.read(userTagsProvider).length;
    FilterState filterState = ref.watch(tasksFilterProvider);
    _allTags = ref.watch(userTagsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Фильтры"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Row(children: [
                Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      "Приоритет",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Checkbox(
                        value: _priorities,
                        onChanged: (bool? state) {
                          _priorities = state!;
                          if (state) {
                            ref
                                .read(tasksFilterProvider.notifier)
                                .addPriority(Priority.high);
                            ref
                                .read(tasksFilterProvider.notifier)
                                .addPriority(Priority.medium);
                            ref
                                .read(tasksFilterProvider.notifier)
                                .addPriority(Priority.low);
                            ref
                                .read(tasksFilterProvider.notifier)
                                .addPriority(Priority.none);
                          } else {
                            ref
                                .read(tasksFilterProvider.notifier)
                                .deletePriority(Priority.high);
                            ref
                                .read(tasksFilterProvider.notifier)
                                .deletePriority(Priority.medium);
                            ref
                                .read(tasksFilterProvider.notifier)
                                .deletePriority(Priority.low);
                            ref
                                .read(tasksFilterProvider.notifier)
                                .deletePriority(Priority.none);
                          }
                          setState(() {});
                        }))
              ]),
              CheckboxListTile(
                  title: const Text("Высокий"),
                  value: filterState.priorities.contains(Priority.high),
                  onChanged: (bool? state) {
                    if (state == null) {
                      return;
                    }
                    if (state) {
                      ref
                          .read(tasksFilterProvider.notifier)
                          .addPriority(Priority.high);
                    } else {
                      ref
                          .read(tasksFilterProvider.notifier)
                          .deletePriority(Priority.high);
                    }
                    setState(() {});
                  }),
              CheckboxListTile(
                  title: const Text("Средний"),
                  value: filterState.priorities.contains(Priority.medium),
                  onChanged: (bool? state) {
                    if (state == null) {
                      return;
                    }
                    if (state) {
                      ref
                          .read(tasksFilterProvider.notifier)
                          .addPriority(Priority.medium);
                    } else {
                      ref
                          .read(tasksFilterProvider.notifier)
                          .deletePriority(Priority.medium);
                    }
                    setState(() {});
                  }),
              CheckboxListTile(
                  title: const Text("Низкий"),
                  value: filterState.priorities.contains(Priority.low),
                  onChanged: (bool? state) {
                    if (state == null) {
                      return;
                    }
                    if (state) {
                      ref
                          .read(tasksFilterProvider.notifier)
                          .addPriority(Priority.low);
                    } else {
                      ref
                          .read(tasksFilterProvider.notifier)
                          .deletePriority(Priority.low);
                    }
                    setState(() {});
                  }),
              CheckboxListTile(
                  title: const Text("Без приоритета"),
                  value: filterState.priorities.contains(Priority.none),
                  onChanged: (bool? state) {
                    if (state == null) {
                      return;
                    }
                    if (state) {
                      ref
                          .read(tasksFilterProvider.notifier)
                          .addPriority(Priority.none);
                    } else {
                      ref
                          .read(tasksFilterProvider.notifier)
                          .deletePriority(Priority.none);
                    }
                    setState(() {});
                  }),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    "Статус выполнения",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Checkbox(
                        value: _statuses,
                        onChanged: (bool? state) {
                          _statuses = state!;
                          if (state) {
                            ref
                                .read(tasksFilterProvider.notifier)
                                .addStatus(true);
                            ref
                                .read(tasksFilterProvider.notifier)
                                .addStatus(false);
                          } else {
                            ref
                                .read(tasksFilterProvider.notifier)
                                .deleteStatus(true);
                            ref
                                .read(tasksFilterProvider.notifier)
                                .deleteStatus(false);
                          }
                          setState(() {});
                        }))
              ]),
              CheckboxListTile(
                  title: const Text("Выполнено"),
                  value: filterState.statuses.contains(true),
                  onChanged: (bool? state) {
                    if (state == null) {
                      return;
                    }
                    if (state) {
                      ref.read(tasksFilterProvider.notifier).addStatus(true);
                    } else {
                      ref.read(tasksFilterProvider.notifier).deleteStatus(true);
                    }
                    setState(() {});
                  }),
              CheckboxListTile(
                  title: const Text("Не выполнено"),
                  value: filterState.statuses.contains(false),
                  onChanged: (bool? state) {
                    if (state == null) {
                      return;
                    }
                    if (state) {
                      ref.read(tasksFilterProvider.notifier).addStatus(false);
                    } else {
                      ref
                          .read(tasksFilterProvider.notifier)
                          .deleteStatus(false);
                    }
                    setState(() {});
                  }),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      "Теги",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Divider())),
                  Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Checkbox(
                          value: _tags,
                          onChanged: (bool? state) {
                            _tags = state!;

                            for (int i = 0;
                                i < ref.read(userTagsProvider).length;
                                ++i) {
                              if (state) {
                                ref
                                    .read(tasksFilterProvider.notifier)
                                    .addTag(ref.read(userTagsProvider)[i].id);
                              } else {
                                ref
                                    .read(tasksFilterProvider.notifier)
                                    .deleteTag(
                                        ref.read(userTagsProvider)[i].id);
                              }
                            }
                            setState(() {});
                          })),
                ],
              ),
              Wrap(
                spacing: 10,
                children: [
                  ..._allTags
                      .map(
                        (tag) => InputChip(
                            avatar: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              foregroundColor: tag.color,
                              child: Icon(
                                tag.icon,
                                size: 20,
                              ),
                            ),
                            label: Text(
                              tag.name,
                              style: TextStyle(
                                color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                              ),
                            ),
                            onDeleted: () {
                              ref
                                  .read(userTagsProvider.notifier)
                                  .deleteTag(tag);
                            },
                            onPressed: () {
                              setState(() {});
                              if (!filterState.tags.contains(tag.id)) {
                                setState(() {
                                  ref
                                      .read(tasksFilterProvider.notifier)
                                      .addTag(tag.id);
                                });
                              } else {
                                setState(() {
                                  ref
                                      .read(tasksFilterProvider.notifier)
                                      .deleteTag(tag.id);
                                });
                              }
                            },
                            backgroundColor: filterState.tags.contains(tag.id)
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).chipTheme.backgroundColor),
                      )
                      .toList(),
                  ActionChip(
                    avatar: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    label: const Text('Добавить'),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
