import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qreoh/entities/user_entity.dart';

Future<UserEntity?> searchFriend(String login, int tag) async {
  final db = FirebaseFirestore.instance;
  final usersRef = db.collection('users');
  final query =
      usersRef.where('login', isEqualTo: login).where('tag', isEqualTo: tag);
  final value = await query.get();
  if (value.size != 0) {
    final user = value.docs.first.data();
    return UserEntity(value.docs.first.id, user['login'], user['tag']);
  } else {
    return null;
  }
}

Future<void> sendFriendRequest(UserEntity userTo) async {
  String fromUid = FirebaseAuth.instance.currentUser!.uid;
  final userRequestsRef = FirebaseDatabase.instance.ref("requests/${userTo.uid}");
  final newRequestRef = userRequestsRef.push();
  newRequestRef.set({
    "from": fromUid,
  });
  print('send request to ${userTo.uid}');
}

Future<void> acceptFriendRequest(UserEntity userFrom) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  final userRef = db.collection('users').doc(uid);
  final friendRef = db.collection('users').doc(userFrom.uid);
  final requestRef = await FirebaseDatabase.instance.ref("requests/$uid").get();
  if (requestRef.exists) {
    for (var element in requestRef.children) {
      if ((element.value as Map<dynamic, dynamic>)['from'] == userFrom.uid) {
        userRef.update({
          "friends": FieldValue.arrayUnion([userFrom.uid]),
        });
        friendRef.update({
          "friends": FieldValue.arrayUnion([uid]),
        });
        FirebaseDatabase.instance.ref("requests/$uid/${element.key}").remove();
        break;
      }
    }
  }
}

Future<void> denyFriendRequest(UserEntity userFrom) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final requestRef = await FirebaseDatabase.instance.ref("requests/$uid").get();
  if (requestRef.exists) {
    for (var element in requestRef.children) {
      if ((element.value as Map<dynamic, dynamic>)['from'] == userFrom.uid) {
        FirebaseDatabase.instance.ref("requests/$uid/${element.key}").remove();
        break;
      }
    }
  }
}

Future<List<UserEntity>> getAllFriends(bool descending) async {
  final db = FirebaseFirestore.instance;
  List<UserEntity> friends = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final user = await db.collection('users').doc(uid).get();
  final friendsIds = user.data()?['friends'];
  if (friendsIds.isNotEmpty) {
    final friendsObj = await db.collection('users').where('__name__', whereIn: friendsIds).get();
    final docs = friendsObj.docs;
    docs.sort((a, b) {
      final val = (a['login'] as String)
          .toLowerCase()
          .compareTo((b['login'] as String).toLowerCase());
      if (descending) {
        return val * -1;
      }
      return val;
    });
    for (var element in docs) {
      friends.add(UserEntity(element.id, element['login'], element['tag']));
    }
  }
  return friends;
}
