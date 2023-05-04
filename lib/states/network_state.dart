import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkStateNotifier extends StateNotifier<bool> {
  final _connectivity = Connectivity();

  bool _getStateByConn(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.ethernet:
        return true;
      case ConnectivityResult.mobile:
        return true;
      case ConnectivityResult.none:
        return false;
      default:
        return false;
    }
  }

  void _updateState() async {
    final result = await _connectivity.checkConnectivity();
    state = _getStateByConn(result);
    if (state) {
      state = await _checkInetAccess();
    }
  }

  Future<bool> _checkInetAccess() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return  result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  NetworkStateNotifier(): super(false) {
    _updateState();
    _connectivity.onConnectivityChanged.listen((event) async {
      state = _getStateByConn(event);
      if (state) {
        state = await _checkInetAccess();
      }
    });
  }
}