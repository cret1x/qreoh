import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:qreoh/entities/user_entity.dart';

class FriendItem extends StatelessWidget {
  late final String? login;
  late final int? tag;
  late final Function()? actionAccept;
  late final Function()? actionDeny;

  FriendItem(UserEntity user, {Key? key}) : super(key: key) {
    login = user.login;
    tag = user.tag;
    actionAccept = null;
    actionDeny = null;
  }

  FriendItem.withAction(UserEntity user, this.actionAccept, this.actionDeny,
      {Key? key})
      : super(key: key) {
    login = user.login;
    tag = user.tag;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: null,
      leading: CircleAvatar(
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        radius: 32,
      ),
      title: Text(
        login ?? "test",
        style: const TextStyle(fontSize: 22),
      ),
      subtitle: Text("#$tag"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (actionAccept != null)
            IconButton(
              onPressed: actionAccept,
              icon: const Icon(Icons.person_add),
            ),
          if (actionDeny != null)
            IconButton(
              onPressed: actionDeny,
              icon: const Icon(Icons.block),
            )
        ],
      ),
    );
  }
}
