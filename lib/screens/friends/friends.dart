import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/friend_item.dart';
import '../../entities/user_entity.dart';
import '../../firebase_functions/friends.dart';

const List<String> _sortTypes = <String>['A - Z', 'Z - A', 'fav'];

class FriendsWidget extends StatefulWidget {
  const FriendsWidget({super.key});

  @override
  State<StatefulWidget> createState() => _FriendsWidgetState();
}

class _FriendsWidgetState extends State<FriendsWidget> {
  String _dropdownValue = _sortTypes.first;
  bool _descending = false;

  @override
  void initState() {
    super.initState();
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
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(20),
                isExpanded: true,
                value: _dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                ),
                underline: Container(
                  height: 2,
                ),
                onChanged: (String? value) {
                  setState(() {
                    _dropdownValue = value!;
                    if (value == _sortTypes[0]) {
                      _descending = false;
                    } else if (value == _sortTypes[1]) {
                      _descending = true;
                    } else {
                      _descending = false;
                    }
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
              child: FutureBuilder(
            future: getAllFriends(_descending),
            builder: (context, data) {
              if (data.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (data.hasData && data.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: data.data!.length,
                    itemBuilder: (context, index) {
                      return FriendItem(data.data!.elementAt(index));
                    });
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "You have no friends",
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                );
              }
            },
          )),
        ],
      ),
    );
  }
}
