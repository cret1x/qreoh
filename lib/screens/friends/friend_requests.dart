import 'package:flutter/material.dart';

class FriendRequestWidget extends StatefulWidget {
  const FriendRequestWidget({super.key});

  @override
  State<StatefulWidget> createState() => _FriendRequestWidgetState();
}

class _FriendRequestWidgetState extends State<FriendRequestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incoming requests"),
      ),
      body: const Text("Lol"),
    );
  }
}
