import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/profile/profile.dart';
import 'package:qreoh/states/user_state.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  late UserState _currentUser;
  List<Achievement> _achievements = [];
  @override
  void initState() {
    super.initState();
    ref.read(userStateProvider.notifier).getUser();
    ref.read(achievementsProvider.notifier).loadAchievements();
  }
  @override
  Widget build(Object context) {
    _currentUser = ref.watch(userStateProvider);
    _achievements = ref.watch(achievementsProvider);
    return ProfileWidget(profile: _currentUser, achievements: _achievements);
  }

}