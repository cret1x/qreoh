import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/profile/profile.dart';
import 'package:qreoh/states/user_state.dart';

class FriendProfile extends ConsumerStatefulWidget {
  final UserState profile;

  const FriendProfile({super.key, required this.profile});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FriendProfileState();
}

class _FriendProfileState extends ConsumerState<FriendProfile> {
  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile.login),
      ),
      body: ProfileWidget(profile: widget.profile),
    );
  }
}
