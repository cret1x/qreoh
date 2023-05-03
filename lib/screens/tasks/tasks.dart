import 'package:flutter/material.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
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
    return FutureBuilder(
        future: getFolderContent(_rootFolder),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            print(snapshot.data);
              for (var element in snapshot.data!) {
                _rootFolder.addTask(element);
              }
            return TaskManagerWidget(_rootFolder, _tags);
          }
          return Text("Pidor");
        });
  }
}
