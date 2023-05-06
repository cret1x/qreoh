import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/global_providers.dart';

import '../../firebase_functions/auth.dart';

class VerifyEmailWidget extends ConsumerStatefulWidget {
  const VerifyEmailWidget({super.key});

  @override
  ConsumerState<VerifyEmailWidget> createState() => _VerifyEmailWidgetState();
}

class _VerifyEmailWidgetState extends ConsumerState<VerifyEmailWidget> {
  final _emailController = TextEditingController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        ref.read(authStateProvider.notifier).setUserAsVerified();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Сброс пароля"),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Вам было отправлено письмо на ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(FirebaseAuth.instance.currentUser!.email ?? "email", style: TextStyle(fontSize: 20),),
                const Text("для подтверждения почты",
                  style: TextStyle(fontSize: 20),),
                const Text("Возможно оно попало в папку спам",
                  style: TextStyle(fontSize: 20),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(64),
                    ),
                    onPressed: () {
                      ref.read(authStateProvider.notifier).verifyUser();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Вам было отправлено письмо для подтверждения"),
                        ),
                      );
                    },
                    child: const Text(
                      "Отправить еще раз",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(64),
                    ),
                    onPressed: () async {
                      ref.read(authStateProvider.notifier).signOutUser();
                      await FirebaseAuth.instance.currentUser!.reload();
                    },
                    child: const Text(
                      "Войти в другой аккаунт",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
