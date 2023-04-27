import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String? uid;
  final String? login;
  final int? tag;

  UserEntity(this.uid, this.login, this.tag);

  factory UserEntity.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserEntity(snapshot.id, data?['login'], data?['tag']);
  }
}