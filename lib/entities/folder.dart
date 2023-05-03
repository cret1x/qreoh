import 'task.dart';

class Folder {
  String _name;
  Folder? _parent;
  final List<Folder> _children = List<Folder>.empty();
  final List<Task> _tasks = [];

  Folder(this._name, this._parent, [List<Task>? tasks]) {
    if (tasks != null) {
      _tasks.addAll(tasks);
    }
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void addTasks(Iterable<Task> tasks) {
    _tasks.addAll(tasks);
  }

  String getName() {
    return _name;
  }

  Folder? getParent() {
    return _parent;
  }

  List<Folder> getChildren() {
    return _children;
  }

  List<Task> getTasks() {
    return _tasks;
  }

  void addChild(Folder child) {
    _children.add(child);
  }

  void setParent(Folder parent) {
    _parent = parent;
  }

  String getPath() {
    if (_parent == null) {
      return "$_name/";
    }
    return "${_parent!.getPath()}$_name/";
  }
}