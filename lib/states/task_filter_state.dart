import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/firebase_functions/tags.dart';

class FilterState {
  final Set<Priority> priorities;
  final Set<bool> statuses;
  final Set<String> tags;

  FilterState({
    required this.priorities,
    required this.statuses,
    required this.tags,
  });

  FilterState copyWith(
          {Set<String>? tags,
          Set<Priority>? priorities,
          Set<bool>? statuses}) =>
      FilterState(
          priorities: priorities ?? this.priorities,
          statuses: statuses ?? this.statuses,
          tags: tags ?? this.tags);
}

class FilterStateNotifier extends StateNotifier<FilterState> {
  FilterStateNotifier()
      : super(FilterState(priorities: {}, statuses: {}, tags: {}));
  final firebaseTagManager = FirebaseTagManager();

  void addTag(String tag) {
    state = state.copyWith(
      tags: {
        ...state.tags, tag
      },
    );
  }

  void deleteTag(String tag) {
    state = state.copyWith(
      tags: {
        for (final tg in state.tags)
          if (tg != tag) tg
      },
    );
  }

  void addPriority(Priority priority) {
    state = state.copyWith(
      priorities: {
        ...state.priorities, priority
      },
    );
  }

  void deletePriority(Priority priority) {
    state = state.copyWith(
      priorities: {
        for (final p in state.priorities)
          if (p != priority) p
      },
    );
  }

  void addStatus(bool status) {
    state = state.copyWith(
      statuses: {
        ...state.statuses, status
      },
    );
  }

  void deleteStatus(bool status) {
    state = state.copyWith(
      statuses: {
        for (final st in state.statuses)
          if (st != status) st
      },
    );
  }

  bool check(Task task) {
    bool flag =
        state.priorities.isEmpty || state.priorities.contains(task.priority);
    if (!flag) {
      return false;
    }

    flag = state.statuses.isEmpty || state.statuses.contains(task.done);
    if (!flag) {
      return false;
    }

    if (state.tags.isEmpty) {
      return true;
    }

    for (var tag in state.tags) {
      flag = task.tags.contains(tag);
      if (!flag) {
        return false;
      }
    }
    return true;
  }
}
