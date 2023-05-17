import 'action.dart';

class ReceiverInfo {
  final String receiverId;
  final List<Action> actions = [];

  ReceiverInfo(this.receiverId);

  void addAction(Action action) {
    actions.add(action);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'receiverId': receiverId,
      'actions': actions.map((e) => e.toFirestore()).toList(),
    };
  }

  factory ReceiverInfo.fromFirestore(Map<String, dynamic> data) {
    var ri = ReceiverInfo(data['receiverId']);
    for (final a in List.from(data['actions'].map((e) => Action.fromFirestore(e)))) {
      ri.addAction(a);
    }
    return ri;
  }
}