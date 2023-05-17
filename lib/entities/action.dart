import 'package:cloud_firestore/cloud_firestore.dart';

enum ActionType { sent, done, undone, deleted }

class Action {
  final ActionType type;
  final DateTime date;

  Action(this.type, this.date);
}