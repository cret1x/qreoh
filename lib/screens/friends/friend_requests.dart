import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/common_widgets/friend_item.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/user_state.dart';
import 'package:qreoh/strings.dart';

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
        title: const Text(Strings.incomingRequests),
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
                        const SnackBar(content: Text(Strings.requestAccept)));
                  }, () {
                    ref.read(friendsListStateProvider.notifier).declineRequest(_requests[index]);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(Strings.requestDecline)));
                  }),
                );
              },
            )
          : const Center(
              child: Text(Strings.noIncomingRequests, style: TextStyle(fontSize: 20)),
            ),
    );
  }
}
