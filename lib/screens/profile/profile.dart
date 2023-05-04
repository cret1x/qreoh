import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

class ProfileWidget extends ConsumerStatefulWidget {
  const ProfileWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {

  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    _isOnline = ref.watch(networkStateProvider);
    return Column(
      children: [
        Text("Profile for user ${FirebaseAuth.instance.currentUser?.email ?? 'anon'}"),
        Text("Connection status: ${_isOnline ? "online" : "offline"}"),
      ],
    );
  }
}
