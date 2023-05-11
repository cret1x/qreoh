import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/firebase_functions/user.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/profile/profile.dart';
import 'package:qreoh/states/user_state.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {

  @override
  Widget build(Object context) {
    var currentUser = ref.watch(userStateProvider);
    if (currentUser == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
          ],
        ),
      );
    } else {
      return ProfileWidget(profile: currentUser);
    }
  }
}