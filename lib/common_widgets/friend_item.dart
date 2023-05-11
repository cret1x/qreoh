import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qreoh/screens/friends/friend_profile.dart';
import 'package:qreoh/states/user_state.dart';
import 'package:transparent_image/transparent_image.dart';

class FriendItem extends StatelessWidget {
  final UserState friendState;
  late final Function()? actionAccept;
  late final Function()? actionDeny;

  FriendItem(this.friendState, {Key? key}) : super(key: key) {
    actionAccept = null;
    actionDeny = null;
  }

  FriendItem.withAction(this.friendState, this.actionAccept, this.actionDeny,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: friendState.banner.asset,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const FractionalOffset(0.4, 0),
            end: FractionalOffset.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
              Theme.of(context).colorScheme.surface.withOpacity(0),
            ],
          ),
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendProfile(
                  profile: friendState,
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor:
                Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1.0),
            foregroundImage: (friendState.profileImageUrl != null)
                ? NetworkImage(friendState.profileImageUrl!)
                : null,
            radius: 32,
          ),
          title: Text(
            friendState.login,
            style: const TextStyle(fontSize: 22),
          ),
          subtitle: Text("#${friendState.tag}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (actionAccept != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadiusDirectional.circular(12)),
                    child: Center(
                      child: IconButton(
                        onPressed: actionAccept,
                        icon: const Icon(Icons.person_add),
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              if (actionDeny != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadiusDirectional.circular(12)),
                    child: Center(
                      child: IconButton(
                        onPressed: actionDeny,
                        icon: const Icon(Icons.block),
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
