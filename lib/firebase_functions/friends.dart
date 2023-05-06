import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qreoh/entities/user_entity.dart';


class FirebaseFriendsManager {
  final db = FirebaseFirestore.instance;
  static final FirebaseFriendsManager _singleton = FirebaseFriendsManager._internal();

  factory FirebaseFriendsManager() {
    return _singleton;
  }

  FirebaseFriendsManager._internal();


  Future<UserEntity?> searchFriend(String login, int tag) async {
    final usersRef = db.collection('users');
    final query =
    usersRef.where('login', isEqualTo: login).where('tag', isEqualTo: tag);
    final value = await query.get();
    if (value.size != 0) {
      final user = value.docs.first.data();
      if (value.docs.first.id == FirebaseAuth.instance.currentUser!.uid) {
        return null;
      }
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
  }

  Future<void> acceptFriendRequest(UserEntity userFrom) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
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

  Future<void> declineFriendRequest(UserEntity userFrom) async {
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

  Future<UserEntity?> getUserByUid(String uid) async {
    final db = FirebaseFirestore.instance;
    final usersRef = db.collection('users');
    final snapshot = await usersRef.doc(uid).get();
    if (snapshot.exists) {
      return UserEntity.fromFirestore(snapshot, null);
    }
    return null;
  }

  Future<List<UserEntity>> getAllFriends() async {
    List<UserEntity> friends = [];
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final user = await db.collection('users').doc(uid).get();
    final friendsIds = user.data()?['friends'] ?? [];
    if (friendsIds.isNotEmpty) {
      final friendsObj = await db.collection('users').where('__name__', whereIn: friendsIds).get();
      final docs = friendsObj.docs;
      for (var element in docs) {
        friends.add(UserEntity(element.id, element['login'], element['tag']));
      }
    }
    return friends;
  }

  Future<void> deleteFriend(UserEntity friend) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final userRef = db.collection('users').doc(uid);
    final friendRef = db.collection('users').doc(friend.uid);
    userRef.update({
      "friends": FieldValue.arrayRemove([friend.uid]),
    });
    friendRef.update({
      "friends": FieldValue.arrayRemove([uid]),
    });
  }
}