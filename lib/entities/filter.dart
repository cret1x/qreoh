import 'tag.dart';
import 'task.dart';

class Filter {
  final Set<Priority> priorities = <Priority>{};
  final Set<bool> statuses = <bool>{};
  final Set<Tag> tags = <Tag>{};

  bool check(Task task) {
    bool flag = priorities.isEmpty || priorities.contains(task.getPriority());
    if (!flag) {
      return false;
    }

    flag = statuses.isEmpty || statuses.contains(task.getState());
    if (!flag) {
      return false;
    }

    if (tags.isEmpty) {
      return true;
    }

    for (Tag tag in tags) {
      flag = task.getTags().contains(tag);
      if (!flag) {
        return false;
      }
    }

    return true;
  }
}