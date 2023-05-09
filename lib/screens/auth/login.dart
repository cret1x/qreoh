import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/auth/reset_password.dart';
import 'package:qreoh/strings.dart';


class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({super.key});

  @override
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget>
    with RestorationMixin {
  final _obscurePassword = RestorableBool(true);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  String? get restorationId => "password_field";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_obscurePassword, 'obscure_text');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.loginLabel),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return Strings.requiredField;
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: Strings.enterEmail)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscurePassword.value,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return Strings.requiredField;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword.value =
                                      !_obscurePassword.value;
                                });
                              },
                              hoverColor: Colors.transparent,
                              icon: Icon(
                                _obscurePassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            border: const OutlineInputBorder(),
                            labelText: Strings.enterPassword)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResetPassword()));
                      },
                      child: const Text(Strings.forgotPassword),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(64),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .read(authStateProvider.notifier)
                              .loginUser(_emailController.text,
                                  _passwordController.text)
                              .then((value) {
                            if (value != null) {
                              if (value == "OK") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(Strings.successLogin)));
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(value)));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(Strings.errorOccurred)));
                            }
                          });
                        }
                      },
                      child: const Text(
                        Strings.actionLogin,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
