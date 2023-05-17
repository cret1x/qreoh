import 'package:cloud_firestore/cloud_firestore.dart';

enum ActionType { sent, done, undone, deleted }

class Action {
  final ActionType type;
  final DateTime date;

  Action(this.type, this.date);

  Map<String, dynamic> toFirestore() {
    return {
      'type' : type.name,
      'date': date,
    };
  }

  factory Action.fromFirestore(Map<String, dynamic> data) {
    return Action(ActionType.values.byName(data['type']), (data['date'] as Timestamp).toDate());
  }
}