import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/reward_item.dart';
import 'package:qreoh/firebase_functions/rewards.dart';


class RewardsStateNotifier extends StateNotifier<List<RewardItem>> {
  final firebaseRewardsManager = FirebaseRewardsManager();
  RewardsStateNotifier() : super([]);

  void loadItems() async {
    state = await firebaseRewardsManager.getRewardsItems();
  }
}