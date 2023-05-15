import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/common_widgets/friend_item.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/user_state.dart';
import 'package:qreoh/strings.dart';

class AddFriendWidget extends ConsumerStatefulWidget {
  const AddFriendWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddFriendWidgetState();
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
    final outRequests = ref.watch(friendsListStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.addFriend),
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
                            if ((value == null || value.isEmpty) &&
                                _tagController.text.isEmpty) {
                              return Strings.requiredField;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: Strings.friendLogin),
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
                            if ((value == null || value.isEmpty) &&
                                (_loginController.text.isEmpty)) {
                              return Strings.requiredField;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: Strings.friendTag),
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
                        String? login = _loginController.text.isEmpty
                            ? null
                            : _loginController.text;
                        int? tag = _tagController.text.isEmpty
                            ? null
                            : int.parse(_tagController.text);
                        ref
                            .read(friendsListStateProvider.notifier)
                            .searchFriend(login, tag)
                            .then((value) {
                              setState(() {
                                _foundFriend.clear();
                              });
                          if (value != null) {
                            setState(() {

                              _foundFriend.addAll(value);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(Strings.friendNotFound)));
                          }
                        });
                      }
                    },
                    icon: const Icon(Icons.search),
                    label: const Text(Strings.search),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Theme.of(context).colorScheme.primary),
                      minimumSize: const MaterialStatePropertyAll<Size>(
                          Size.fromHeight(48)),
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
                  child: FriendItem.withAction(
                      _foundFriend[id],
                      outRequests.outRequests
                                  .map((e) => e.uid)
                                  .contains(_foundFriend[id].uid) ||
                              outRequests.friends
                                  .map((e) => e.uid)
                                  .contains(_foundFriend[id].uid)
                          ? null
                          : () {
                              ref
                                  .read(friendsListStateProvider.notifier)
                                  .sendRequest(_foundFriend[id]);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text(Strings.sentFriendRequest)));
                            },
                      null),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
