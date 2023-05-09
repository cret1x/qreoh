import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/global_providers.dart';

import '../../firebase_functions/auth.dart';

class RegisterWidget extends ConsumerStatefulWidget {
  const RegisterWidget({super.key});

  @override
  ConsumerState<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends ConsumerState<RegisterWidget> with RestorationMixin {
  final _obscurePassword = RestorableBool(true);
  final _loginController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

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
    _loginController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _passwordCheckController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register form"),
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
                        controller: _loginController,
                        maxLength: 16,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Обязательное поле";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Введите ваш логин')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Обязательное поле";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Введите вашу почту')),
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
                            return "Обязательное поле";
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
                            labelText: 'Введите ваш пароль')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscurePassword.value,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: _passwordCheckController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Обязательное поле";
                          }
                          if (value != _passwordController.text) {
                            return "Пароли должны совпадать";
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
                            labelText: 'Повторный пароль')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          ref.read(authStateProvider.notifier).registerUser(_loginController.text, _emailController.text, _passwordController.text).then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                            if (value != null) {
                              if (value == "OK") {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Аккаунт создан")));
                                ref.read(authStateProvider.notifier).verifyUser();
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("произошла ошибка")));
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(64),),
                      icon: _isLoading
                          ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                          : const Icon(Icons.feedback),
                      label: const Text('Зарегестрироваться'),
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
