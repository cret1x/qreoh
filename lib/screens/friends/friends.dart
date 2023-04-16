import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

const List<String> _sortTypes = <String>['A - Z', 'Z - A', 'fav'];

class FriendsWidget extends StatefulWidget {
  const FriendsWidget({super.key});

  @override
  State<StatefulWidget> createState() => _FriendsWidgetState();
}

class _FriendsWidgetState extends State<FriendsWidget> {
  String _dropdownValue = _sortTypes.first;
  List<FriendItem> _friends = [];

  @override
  void initState() {
    super.initState();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('users/$uid/friends');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      if (data != null) {
        setState(() {
          _friends = data.map((e) => FriendItem(login: (e.value as Map)['login'], tag: (e.value as Map)['tag'])).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blue.shade100,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(20),
                isExpanded: true,
                value: _dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 24,
                ),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  setState(() {
                    _dropdownValue = value!;
                    _friends.sort((a, b) {
                      if (value == _sortTypes[0]) {
                        return a.login.toLowerCase().compareTo(b.login.toLowerCase());
                      } else if (value == _sortTypes[1]) {
                        return b.login.toLowerCase().compareTo(a.login.toLowerCase());
                      } else {
                        return a.login.toLowerCase().compareTo(b.login.toLowerCase());
                      }
                    });
                  });
                },
                items: _sortTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: _friends.isNotEmpty
                ? ListView(
                    children: _friends,
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "You have no fiends",
                          style: TextStyle(fontSize: 32),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class FriendItem extends StatelessWidget {
  final String login;
  final int tag;

  const FriendItem({super.key, required this.login, required this.tag});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: CircleAvatar(
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        radius: 32,
      ),
      title: Text(
        login,
        style: const TextStyle(fontSize: 22),
      ),
      subtitle: Text("#$tag"),
    );
  }
}
