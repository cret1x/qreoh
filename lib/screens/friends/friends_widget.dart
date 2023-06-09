import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/common_widgets/friend_item.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/friends_list_state.dart';
import 'package:qreoh/states/user_state.dart';
import 'package:qreoh/strings.dart';

const List<String> _sortTypes = <String>['A - Z', 'Z - A'];

class FriendsWidget extends ConsumerStatefulWidget {
  const FriendsWidget({super.key});

  @override
  ConsumerState<FriendsWidget> createState() => _FriendsWidgetState();
}

class _FriendsWidgetState extends ConsumerState<FriendsWidget> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String _dropdownValue = _sortTypes.first;
  bool _descending = false;
  List<UserState>? _friends;

  @override
  void initState() {
    super.initState();
    ref.read(friendsListStateProvider.notifier).getAllFriends(_descending).then((value) {
      setState(() {
        _friends = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _friends = ref.watch(friendsListStateProvider).friends;
    if (_friends == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 2.0,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(20),
                  isExpanded: true,
                  value: _dropdownValue,
                  icon: Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).colorScheme.onBackground,
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
                    ref
                        .read(friendsListStateProvider.notifier)
                        .getAllFriends(_descending);
                  },
                  items: _sortTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  child: ClipRect(
                    child: _friends!.isNotEmpty
                        ? ListView.separated(
                            shrinkWrap: true,
                            itemCount: _friends!.length,
                            itemBuilder: (context, index) {
                              return FriendItem(_friends![index]);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  Strings.noFriends,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
