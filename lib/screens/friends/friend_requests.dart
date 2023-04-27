import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qreoh/common_widgets/friend_item.dart';
import 'package:qreoh/entities/user_entity.dart';
import 'package:qreoh/firebase_functions/friends.dart';
import 'package:qreoh/firebase_functions/users.dart';

class FriendRequestWidget extends StatefulWidget {
  const FriendRequestWidget({super.key});

  @override
  State<StatefulWidget> createState() => _FriendRequestWidgetState();
}

class _FriendRequestWidgetState extends State<FriendRequestWidget> {
  final Set<UserEntity> _incomingRequests = {};
  late final String _uid;

  Future<void> _updateRequests() async {
    _uid = FirebaseAuth.instance.currentUser!.uid;
    final userRequestsRef = FirebaseDatabase.instance.ref("requests/$_uid");
    userRequestsRef.onChildAdded.listen((event) async {
      final user = await getUserByUid(
          (event.snapshot.value as Map<dynamic, dynamic>)['from']);
      if (user != null) {
        setState(() {
          _incomingRequests.add(user);
        });
      }
      print(_incomingRequests);
    });
    userRequestsRef.onChildRemoved.listen((event) async {
      final user = await getUserByUid(
          (event.snapshot.value as Map<dynamic, dynamic>)['from']);
      if (user != null) {
        setState(() {
          _incomingRequests.remove(user);
        });
      }
      print(_incomingRequests);
    });
  }

  @override
  void initState() {
    super.initState();
    _updateRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incoming requests"),
      ),
      body: _incomingRequests.isNotEmpty
          ? ListView.builder(
              itemCount: _incomingRequests.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FriendItem.withAction(
                      _incomingRequests.elementAt(index), () {
                    acceptFriendRequest(_incomingRequests.elementAt(index));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Accepted!")));
                  }, () {
                    denyFriendRequest(_incomingRequests.elementAt(index));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Denied!")));
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
