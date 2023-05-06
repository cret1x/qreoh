import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/global_providers.dart';
import '../../entities/tag.dart';
import '../../entities/task.dart';
import '../../entities/filter.dart';

class FilterWidget extends ConsumerStatefulWidget {
  const FilterWidget({super.key});

  @override
  ConsumerState<FilterWidget> createState() => _FilterState();
}

class _FilterState extends ConsumerState<FilterWidget> {
  late bool _priorities;
  late bool _statuses;
  late bool _tags;

  void _changePriorityState(bool state, Priority priority) {
    if (state) {
      ref.read(tasksFilterProvider.notifier).update((state) {
        var priorities = state.priorities;
        priorities.add(priority);
        return state.copyWith(priorities: priorities, tags: state.tags, statuses: state.statuses);
      });
    } else if (ref.read(tasksFilterProvider).priorities.contains(priority)) {
      ref.read(tasksFilterProvider.notifier).update((state) {
        var priorities = state.priorities;
        priorities.remove(priority);
        return state.copyWith(priorities: priorities, tags: state.tags, statuses: state.statuses);
      });
    }
  }

  void _changeStatusState(bool state, bool status) {
    if (state) {
      ref.read(tasksFilterProvider.notifier).update((state) {
        var statuses = state.statuses;
        statuses.add(status);
        return state.copyWith(priorities: state.priorities, tags: state.tags, statuses: statuses);
      });
    } else if (ref.read(tasksFilterProvider).statuses.contains(status)) {
      ref.read(tasksFilterProvider.notifier).update((state) {
        var statuses = state.statuses;
        statuses.remove(status);
        return state.copyWith(priorities: state.priorities, tags: state.tags, statuses: statuses);
      });
    }
  }

  void _changeTagState(bool state, Tag tag) {
    if (state) {
      ref.read(tasksFilterProvider.notifier).update((state) {
        var tags = state.tags;
        tags.add(tag);
        return state.copyWith(priorities: state.priorities, tags: tags, statuses: state.statuses);
      });
    } else if (ref.read(tasksFilterProvider).tags.contains(tag)) {
      ref.read(tasksFilterProvider.notifier).update((state) {
        var tags = state.tags;
        tags.remove(tag);
        return state.copyWith(priorities: state.priorities, tags: tags, statuses: state.statuses);

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _priorities = ref.read(tasksFilterProvider).priorities.length == 4;
    _statuses = ref.read(tasksFilterProvider).statuses.length == 2;
    _tags = ref.read(tasksFilterProvider).tags.length ==
        ref.read(userTagsProvider).length;
    Filter filter = ref.watch(tasksFilterProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text("Filters"),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back))),
                  Row(children: [
                    const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Priority",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        )),
                    const Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Divider())),
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
                            }))
                  ]),
                  CheckboxListTile(
                      title: const Text("High"),
                      value: filter.priorities.contains(Priority.high),
                      onChanged: (bool? state) {
                        if (state == null) {
                          return;
                        }
                        _changePriorityState(state, Priority.high);
                        setState(() {});
                      }),
                  CheckboxListTile(
                      title: const Text("Medium"),
                      value: filter.priorities.contains(Priority.medium),
                      onChanged: (bool? state) {
                        if (state == null) {
                          return;
                        }
                        _changePriorityState(state, Priority.medium);
                        setState(() {});
                      }),
                  CheckboxListTile(
                      title: const Text("Low"),
                      value: filter.priorities.contains(Priority.low),
                      onChanged: (bool? state) {
                        if (state == null) {
                          return;
                        }
                        _changePriorityState(state, Priority.low);
                        setState(() {});
                      }),
                  CheckboxListTile(
                      title: const Text("None"),
                      value: filter.priorities.contains(Priority.none),
                      onChanged: (bool? state) {
                        if (state == null) {
                          return;
                        }
                        _changePriorityState(state, Priority.none);
                        setState(() {});
                      }),
                  Row(children: [
                    const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text("Status",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54))),
                    const Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Divider())),
                    Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Checkbox(
                            value: _statuses,
                            onChanged: (bool? state) {
                              _statuses = state!;

                              _changeStatusState(state, true);
                              _changeStatusState(state, false);

                              setState(() {});
                            }))
                  ]),
                  CheckboxListTile(
                      title: const Text("Done"),
                      value: filter.statuses.contains(true),
                      onChanged: (bool? state) {
                        if (state == null) {
                          return;
                        }

                        _changeStatusState(state, true);

                        setState(() {});
                      }),
                  CheckboxListTile(
                      title: const Text("Not done"),
                      value: filter.statuses.contains(false),
                      onChanged: (bool? state) {
                        if (state == null) {
                          return;
                        }

                        _changeStatusState(state, false);

                        setState(() {});
                      }),
                  Row(children: [
                    const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text("Tags",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54))),
                    const Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Divider())),
                    Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Checkbox(
                            value: _tags,
                            onChanged: (bool? state) {
                              _tags = state!;

                              for (int i = 0;
                                  i < ref.read(userTagsProvider).length;
                                  ++i) {
                                _changeTagState(
                                    state, ref.read(userTagsProvider)[i]);
                              }

                              setState(() {});
                            })),
                  ]),
                  ListView.builder(
                      itemCount: ref.read(userTagsProvider).length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return CheckboxListTile(
                            title: Text(
                                ref.read(userTagsProvider)[index].name),
                            secondary: Icon(
                                ref.read(userTagsProvider)[index].icon),
                            value: filter.tags
                                .contains(ref.read(userTagsProvider)[index]),
                            onChanged: (bool? state) {
                              if (state == null) {
                                return;
                              }

                              _changeTagState(
                                  state, ref.read(userTagsProvider)[index]);

                              setState(() {});
                            });
                      })
                ]))));
  }
}
