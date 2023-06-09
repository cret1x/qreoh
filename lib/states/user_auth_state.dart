import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/firebase_functions/auth.dart';

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

  UserAuthStateNotifier() : super(UserAuthState.anonymous()) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null || user.isAnonymous) {
        state = UserAuthState.anonymous();
      } else if (!user.emailVerified) {
        state = UserAuthState.registered();
      } else {
        state = UserAuthState.verified();
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
  }

  void signOutUser() {
    state = UserAuthState.anonymous();
    firebaseAuthManager.signOutUser();
  }

  void deleteUserAccount() {
    state = UserAuthState.anonymous();
  }
}
