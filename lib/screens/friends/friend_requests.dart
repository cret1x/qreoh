import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/common_widgets/friend_item.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/user_state.dart';

class FriendRequestWidget extends ConsumerStatefulWidget {
  const FriendRequestWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FriendRequestWidgetState();
}

class _FriendRequestWidgetState extends ConsumerState<FriendRequestWidget> {
  List<UserState> _requests = [];
  @override
  Widget build(BuildContext context) {
    _requests = ref.watch(friendsListStateProvider).inRequests;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incoming requests"),
      ),
      body: _requests.isNotEmpty
          ? ListView.builder(
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FriendItem.withAction(
                      _requests[index], () {
                    ref.read(friendsListStateProvider.notifier).acceptRequest(_requests[index]);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Accepted!")));
                  }, () {
                    ref.read(friendsListStateProvider.notifier).declineRequest(_requests[index]);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Declined!")));
                  }),
                );
              },
            )
          : const Center(
              child: Text("No friend requests", style: TextStyle(fontSize: 32)),
            ),
    );
  }
}
