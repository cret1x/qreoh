import 'dart:math' as math;
import 'package:flutter/material.dart';

class FriendItem extends StatelessWidget {
  final String login;
  final int tag;

  const FriendItem({super.key, required this.login, required this.tag});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: CircleAvatar(
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        radius: 32,
      ),
      title: Text(
        login,
        style: const TextStyle(fontSize: 22),
      ),
      subtitle: Text("#$tag"),
    );
  }
}
