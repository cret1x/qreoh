import '../../entities/task.dart';

enum SortRule {
  leftAsc,
  leftDesc,
  priorityAsc,
  priorityDesc,
  nameAZ,
  nameZA,
  estimation
}

int Function(Task, Task) getFunc(SortRule sr) {
  switch (sr) {
    case SortRule.leftAsc:
      return timeLeftAscending;
    case SortRule.leftDesc:
      return timeLeftDescending;
    case SortRule.priorityAsc:
      return priorityAscending;
    case SortRule.priorityDesc:
      return priorityDescending;
    case SortRule.nameAZ:
      return alphabeticallyAToZ;
    case SortRule.nameZA:
      return alphabeticallyZToA;
    case SortRule.estimation:
      return estimatedOrder;
  }
}

int timeLeftAscending(Task t1, Task t2) {
  if (t1.getDeadline() == null && t2.getDeadline() == null) {
    return 0;
  }
  if (t1.getDeadline() == null) {
    return 1;
  }
  if (t2.getDeadline() == null) {
    return -1;
  }
  DateTime now = DateTime.now();
  return t1
      .getDeadline()!
      .difference(now)
      .compareTo(t2.getDeadline()!.difference(now));
}

int timeLeftDescending(Task t1, Task t2) {
  if (t1.getDeadline() == null && t2.getDeadline() == null) {
    return 0;
  }
  if (t1.getDeadline() == null) {
    return 1;
  }
  if (t2.getDeadline() == null) {
    return -1;
  }
  DateTime now = DateTime.now();
  return t2
      .getDeadline()!
      .difference(now)
      .compareTo(t1.getDeadline()!.difference(now));
}

int alphabeticallyAToZ(Task t1, Task t2) {
  return t1.getName().compareTo(t2.getName());
}

int alphabeticallyZToA(Task t1, Task t2) {
  return t2.getName().compareTo(t1.getName());
}

int priorityAscending(Task t1, Task t2) {
  Priority p1 = t1.getPriority();
  Priority p2 = t2.getPriority();
  if (p1 == Priority.none) {
    if (p2 == Priority.none) {
      return 0;
    } else {
      return 1;
    }
  } else {
    if (p2 == Priority.none) {
      return -1;
    } else {
      return p2.index.compareTo(p1.index);
    }
  }
}

int priorityDescending(Task t1, Task t2) {
  Priority p1 = t1.getPriority();
  Priority p2 = t2.getPriority();
  if (p1 == Priority.none) {
    if (p2 == Priority.none) {
      return 0;
    } else {
      return 1;
    }
  } else {
    if (p2 == Priority.none) {
      return -1;
    } else {
      return p1.index.compareTo(p2.index);
    }
  }
}

int estimatedOrder(Task t1, Task t2) {
  if (t1.getEstimation() == null && t2.getEstimation() == null) {
    return 0;
  }
  if (t1.getEstimation() == null) {
    return 1;
  }
  if (t2.getEstimation() == null) {
    return -1;
  }
  return t1.getEstimation()!.compareTo(t2.getEstimation()!);
}
