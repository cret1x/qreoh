import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/firebase_functions/friends.dart';
import 'package:qreoh/states/user_state.dart';

class FriendsState {
  final List<UserState> friends;
  final List<UserState> inRequests;
  final List<UserState> outRequests;

  FriendsState(
      {required this.friends,
      required this.inRequests,
      required this.outRequests});

  FriendsState copyWith({
    List<UserState>? friends,
    List<UserState>? inRequests,
    List<UserState>? outRequests,
  }) {
    return FriendsState(
        friends: friends ?? this.friends,
        inRequests: inRequests ?? this.inRequests,
        outRequests: outRequests ?? this.outRequests);
  }
}

class FriendListStateNotifier extends StateNotifier<FriendsState> {
  final firebaseFriendsManager = FirebaseFriendsManager();

  FriendListStateNotifier()
      : super(FriendsState(friends: [], inRequests: [], outRequests: [])) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseDatabase.instance
        .ref("requests/$uid")
        .onChildAdded
        .listen((event) async {
      final user = await firebaseFriendsManager.getUserByUid(
          (event.snapshot.value as Map<dynamic, dynamic>)['from']);
      if (user != null) {
        state = state.copyWith(inRequests: [...state.inRequests, user]);
      }
    });
    FirebaseDatabase.instance
        .ref("requests/$uid")
        .onChildRemoved
        .listen((event) async {
      final user = await firebaseFriendsManager.getUserByUid(
          (event.snapshot.value as Map<dynamic, dynamic>)['from']);
      if (user != null) {
        state = state.copyWith(
          inRequests: [
            for (var request in state.inRequests)
              if (request.uid != user.uid) request
          ],
        );
      }
    });
    getAllFriends(false);
  }

  Future<UserState?> searchFriend(String login, int tag) async {
    return firebaseFriendsManager.searchFriend(login, tag);
  }

  void sendRequest(UserState userTo) async {
    await firebaseFriendsManager.sendFriendRequest(userTo);
    state = state.copyWith(outRequests: [...state.outRequests, userTo]);
  }

  void acceptRequest(UserState userFrom) async {
    await firebaseFriendsManager.acceptFriendRequest(userFrom);
    state = state.copyWith(
      friends: [...state.friends, userFrom],
      inRequests: [
        for (var request in state.inRequests)
          if (request.uid != userFrom.uid) request
      ],
    );
  }

  void declineRequest(UserState userFrom) async {
    await firebaseFriendsManager.declineFriendRequest(userFrom);
    state = state.copyWith(
      inRequests: [
        for (var request in state.inRequests)
          if (request.uid != userFrom.uid) request
      ],
    );
  }

  void deleteFriend(UserState friend) async {
    await firebaseFriendsManager.deleteFriend(friend);
    state = state.copyWith(
      friends: [for (final fr in state.friends) if (fr.uid != friend.uid) fr],
    );
  }

  Future<List<UserState>> getAllFriends(bool desc) async {
    final friends = await firebaseFriendsManager.getAllFriends();
    friends.sort((UserState a, UserState b) {
      return desc ? b.login.compareTo(a.login) : a.login.compareTo(b.login);
    });
    state = state.copyWith(friends: friends);
    return friends;
  }
}
