import 'tag.dart';
import 'task.dart';

class Filter {
  Set<Priority> priorities = <Priority>{};
  Set<bool> statuses = <bool>{};
  Set<Tag> tags = <Tag>{};

  Filter copyWith({Set<Tag>? tags, Set<Priority>? priorities, Set<bool>? statuses}) {
    Filter f = Filter();
    if (priorities != null) f.priorities = priorities;
    if (statuses != null) f.statuses = statuses;
    if (tags != null) f.tags = tags;
    return f;
  }

  bool check(Task task) {
    bool flag = priorities.isEmpty || priorities.contains(task.priority);
    if (!flag) {
      return false;
    }

    flag = statuses.isEmpty || statuses.contains(task.done);
    if (!flag) {
      return false;
    }

    if (tags.isEmpty) {
      return true;
    }

    for (Tag tag in tags) {
      flag = task.tags.contains(tag);
      if (!flag) {
        return false;
      }
    }

    return true;
  }
}