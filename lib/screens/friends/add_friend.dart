import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/common_widgets/friend_item.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/user_state.dart';

class AddFriendWidget extends ConsumerStatefulWidget {
  const AddFriendWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddFriendWidgetState();
}

class _AddFriendWidgetState extends ConsumerState<AddFriendWidget> {
  final _loginController = TextEditingController();
  final _tagController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<UserState> _foundFriend = [];

  @override
  void dispose() {
    super.dispose();
    _loginController.dispose();
    _tagController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add friend"),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _loginController,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Login is required";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Friend login'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _tagController,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Tag is required";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Friend tag'),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref.read(friendsListStateProvider.notifier).searchFriend(_loginController.text, int.parse(_tagController.text)).then((value) {
                          if (value != null) {
                            setState(() {
                              _foundFriend.clear();
                              _foundFriend.add(value);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not found")));
                          }
                        });
                      }
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                     // backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _foundFriend.length,
              itemBuilder: (context, id) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FriendItem.withAction(_foundFriend.first, () {
                    ref.read(friendsListStateProvider.notifier).sendRequest(_foundFriend.first);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sent request")));
                  }, null),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
