import 'action.dart';

class ReceiverInfo {
  final String receiverId;
  final List<Action> actions = [];

  ReceiverInfo(this.receiverId);

  void addAction(Action action) {
    actions.add(action);
  }
}