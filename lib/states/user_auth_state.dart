import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/firebase_functions/auth.dart';
import 'package:qreoh/firebase_functions/user.dart';
import 'package:qreoh/global_providers.dart';

enum AuthState { anonymous, registered, verified }

class UserAuthState {
  final AuthState state;
  final User? user = FirebaseAuth.instance.currentUser;

  UserAuthState(this.state);

  factory UserAuthState.anonymous() => UserAuthState(AuthState.anonymous);

  factory UserAuthState.registered() => UserAuthState(AuthState.registered);

  factory UserAuthState.verified() => UserAuthState(AuthState.verified);
}

class UserAuthStateNotifier extends StateNotifier<UserAuthState> {
  final firebaseAuthManager = FirebaseAuthManager();
  final Ref ref;

  UserAuthStateNotifier(this.ref) : super(UserAuthState.anonymous()) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null || user.isAnonymous) {
        state = UserAuthState.anonymous();
      } else if (!user.emailVerified) {
        state = UserAuthState.registered();
      } else {
        state = UserAuthState.verified();
        ref.read(userStateProvider.notifier).loadFromDB();
      }
    });
  }

  Future<String?> registerUser(
      String login, String email, String password) async {
    String? response =
        await firebaseAuthManager.registerUser(login, email, password);
    if (response == "OK") {
      state = UserAuthState.registered();
    }
    return response;
  }

  Future<String?> loginUser(String email, String password) async {
    String? response = await firebaseAuthManager.loginUser(email, password);
    if (response == "OK") {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        state = UserAuthState.verified();
        await FirebaseAuth.instance.currentUser?.reload();
        ref.read(userStateProvider.notifier).loadFromDB();
        ref.read(friendsListStateProvider.notifier).loadFromDB();
      } else {
        state = UserAuthState.registered();
      }
    }
    return response;
  }

  Future<void> resetPassword(String email) async {
    await firebaseAuthManager.resetPassword(email);
  }

  void verifyUser() async {
    await firebaseAuthManager.verifyUser();
  }

  void setUserAsVerified() async {
    state = UserAuthState.verified();
    await FirebaseAuth.instance.currentUser?.reload();
    ref.read(userStateProvider.notifier).loadFromDB();
    ref.read(friendsListStateProvider.notifier).loadFromDB();
  }

  void signOutUser() {
    state = UserAuthState.anonymous();
    firebaseAuthManager.signOutUser();
  }

  void deleteUserAccount() {
    state = UserAuthState.anonymous();
  }
}
