import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkStateNotifier extends StateNotifier<bool> {
  NetworkStateNotifier(): super(false);

  void toggle(bool value) {
    state = value;
  }
}