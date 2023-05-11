import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/customisation/reward_item.dart';
import 'package:qreoh/firebase_functions/rewards.dart';


class RewardsStateNotifier extends StateNotifier<List<RewardItem>> {
  final firebaseRewardsManager = FirebaseRewardsManager();
  RewardsStateNotifier() : super([]) {
    loadFromDB();
  }

  void loadFromDB() async {
    state = await firebaseRewardsManager.getRewardsItems();
  }
}