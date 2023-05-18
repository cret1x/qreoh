import 'package:flutter/material.dart';
import '../../../entities/action.dart' as my_action;
import '../../../strings.dart';

class ActionsList extends StatelessWidget {
  final String taskName;
  final List<my_action.Action> actions;

  const ActionsList(this.actions, this.taskName, {super.key});

  Icon _getIcon(my_action.ActionType type) {
    switch (type) {
      case my_action.ActionType.sent:
        return const Icon(Icons.send);
      case my_action.ActionType.done:
        return const Icon(Icons.done);
      case my_action.ActionType.undone:
        return const Icon(Icons.undo);
      case my_action.ActionType.deleted:
        return const Icon(Icons.delete);
    }
  }

  String _getText(my_action.ActionType type) {
    switch (type) {
      case my_action.ActionType.sent:
        return Strings.sent;
      case my_action.ActionType.done:
        return Strings.done;
      case my_action.ActionType.undone:
        return Strings.undone;
      case my_action.ActionType.deleted:
        return Strings.deleted;
    }
  }
  
  String _getDate(DateTime dt) {
    final str = dt.toString();
    return str.substring(0, str.length - 7);
  }

  Row _getItem(my_action.Action action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getIcon(action.type),
        Text(_getText(action.type)),
        Text(_getDate(action.date)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taskName),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        shrinkWrap: true,
        itemBuilder: (context, index) => _getItem(actions[index]),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: actions.length,
      ),
    );
  }
}
