import 'package:flutter/material.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/screens/tasks/task_manager_widget.dart';

import '../../entities/tag.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<StatefulWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  final _rootFolder = Folder("root", null);
  final List<Tag> _tags = [Tag(Icons.add, "pl"), Tag(Icons.ac_unit, "fh")];


  @override
  Widget build(BuildContext context) {
    return TaskManagerWidget(_rootFolder, _tags);
  }

}
