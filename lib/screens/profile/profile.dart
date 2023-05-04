import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("Profile for user ${FirebaseAuth.instance.currentUser?.email ?? 'anon'}");
  }
}
