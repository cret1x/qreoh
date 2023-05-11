import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/folder.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/user_state.dart';
import 'package:uuid/uuid.dart';

import '../../../entities/task.dart';

class ShareTaskWidget extends ConsumerStatefulWidget {
  final Task? _task;

  const ShareTaskWidget(this._task, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ShareTaskState(_task);
  }
}

class ShareTaskState extends ConsumerState<ShareTaskWidget> {
  final uuid = const Uuid();
  final Task? _task;
  final firebaseTaskManager = FirebaseTaskManager();
  late final TextEditingController _textEditingController;
  DateTime? _deadline;
  bool _haveTime = false;
  Duration? _timeRequired;
  int _daysRequired = 0;
  Priority _priority = Priority.none;
  String? _location;
  String? _description;
  List<UserState> _receievers = [];

  String _durationToString(Duration? duration) {
    if (duration == null) {
      return "Add";
    }
    StringBuffer stringBuffer = StringBuffer();
    if (duration.inHours == 0) {
      stringBuffer.write('0');
    }
    stringBuffer.write(duration.toString());
    return stringBuffer.toString().substring(0, stringBuffer.length - 10);
  }

  ShareTaskState(this._task) {
    _textEditingController =
        TextEditingController(text: _task != null ? _task!.name : null);
    if (_task != null) {
      _deadline = _task!.deadline;
      _haveTime = _task!.haveTime;
      _daysRequired =
          _task!.timeRequired == null ? 0 : _task!.timeRequired!.inDays;
      _timeRequired = _task!.timeRequired == null
          ? null
          : _task!.timeRequired! - Duration(days: _daysRequired);
      _priority = _task!.priority;
      _location = _task!.place;
      _description = _task!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отправить задание другу'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Wrap(
            runSpacing: 12,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3, right: 3, bottom: 12),
                child: TextFormField(
                  maxLength: 30,
                  controller: _textEditingController,
                  onChanged: (_) {
                    setState(() {});
                  },
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                    hintText: "Имя задачи",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "Deadline",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                Row(
                  children: [
                    TextButton(
                      child: Text(
                        _deadline == null
                            ? "Add"
                            : _deadline
                                .toString()
                                .substring(0, _haveTime ? 16 : 10),
                      ),
                      onPressed: () async {
                        _deadline = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 2 * 365)),
                        );
                        if (_deadline == null) {
                          return;
                        }
                        TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 0, minute: 0),
                            cancelText: "SKIP");
                        _haveTime = time != null;
                        if (time != null) {
                          _deadline = _deadline!.add(
                              Duration(hours: time.hour, minutes: time.minute));
                        }
                        setState(() {});
                      },
                    ),
                    Visibility(
                      visible: _deadline != null,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        iconSize: 20,
                        onPressed: () {
                          _haveTime = false;
                          _deadline = null;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                )
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Required time",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground)),
                  Row(children: [
                    Visibility(
                        visible: _timeRequired == null,
                        child: TextButton(
                          child: const Text("Add"),
                          onPressed: () {
                            _timeRequired = Duration.zero;
                            setState(() {});
                          },
                        )),
                    Visibility(
                      visible: _timeRequired != null,
                      child: Row(
                        children: [
                          TextButton(
                            child: Text("${_daysRequired} days"),
                            onPressed: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) => Container(
                                  height: 216,
                                  padding: const EdgeInsets.only(top: 6.0),
                                  // The bottom margin is provided to align the popup above the system
                                  // navigation bar.
                                  margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  // Provide a background color for the popup.
                                  color: CupertinoColors.systemBackground
                                      .resolveFrom(context),
                                  // Use a SafeArea widget to avoid system overlaps.
                                  child: SafeArea(
                                    top: false,
                                    child: CupertinoPicker(
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: _daysRequired),
                                      itemExtent: 32,
                                      onSelectedItemChanged: (int value) {
                                        _daysRequired = value;
                                        setState(() {});
                                      },
                                      children: List<Widget>.generate(
                                          61,
                                          (index) => Center(
                                              child: Text(index.toString()))),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          TextButton(
                            child: Text(_durationToString(_timeRequired)),
                            onPressed: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) => Container(
                                  height: 216,
                                  padding: const EdgeInsets.only(top: 6.0),
                                  // The bottom margin is provided to align the popup above the system
                                  // navigation bar.
                                  margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  // Provide a background color for the popup.
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  // Use a SafeArea widget to avoid system overlaps.
                                  child: SafeArea(
                                    top: false,
                                    child: CupertinoTimerPicker(
                                      initialTimerDuration: _timeRequired!,
                                      mode: CupertinoTimerPickerMode.hm,
                                      // This is called when the user changes the timer's
                                      // duration.
                                      onTimerDurationChanged:
                                          (Duration newDuration) {
                                        setState(
                                            () => _timeRequired = newDuration);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            iconSize: 20,
                            onPressed: () {
                              _timeRequired = null;
                              _daysRequired = 0;
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    )
                  ])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Priority",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground)),
                  DropdownButtonHideUnderline(
                      child: DropdownButton<Priority>(
                    iconEnabledColor: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    value: _priority,
                    items:
                        List<DropdownMenuItem<Priority>>.generate(4, (index) {
                      String text;
                      switch (Priority.values[index]) {
                        case Priority.high:
                          text = "High";
                          break;
                        case Priority.medium:
                          text = "Medium";
                          break;
                        case Priority.low:
                          text = "Low";
                          break;
                        case Priority.none:
                          text = "None";
                          break;
                      }
                      return DropdownMenuItem(
                          value: Priority.values[index],
                          child: Container(
                              alignment: Alignment.center,
                              width: 60,
                              child: Text(
                                text,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )));
                    }),
                    onChanged: (Priority? value) {
                      _priority = value!;
                      setState(() {});
                    },
                  )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text("Location",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 50,
                        maxLength: 120,
                        initialValue: _location,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        ),
                        onChanged: (String? value) {
                          _location = value;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text("Description",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 50,
                        maxLength: 500,
                        initialValue: _description,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        ),
                        onChanged: (String? value) {
                          _description = value;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                runSpacing: 12,
                children: [
                  for (var friend in ref.read(friendsListStateProvider).friends)
                    InkWell(
                      onTap: () {
                        if (_receievers.contains(friend)) {
                          _receievers.remove(friend);
                        } else {
                          _receievers.add(friend);
                        }
                        setState(() {});
                      },
                      child: SizedBox(
                        height: 85,
                        width: 60,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 64,
                              width: 64,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        (friend.profileImageUrl != null)
                                            ? NetworkImage(friend.profileImageUrl!)
                                            : null,
                                    radius: 32,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(
                                            _receievers.contains(friend)
                                                ? 0.7
                                                : 0),
                                    radius: 32,
                                  ),
                                  Visibility(
                                      visible: _receievers.contains(friend),
                                      child: Center(
                                          child: Icon(
                                        Icons.done,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        size: 40,
                                      ))),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                friend.login,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(right: 6),
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(12),
                            )),
                            child: const Text(
                              "Сбросить",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              bool result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                          "Вы уверены, что хотите сбросить все изменения?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: const Text("Да")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text("Нет")),
                                      ],
                                    );
                                  });
                              if (result) {
                                Navigator.pop(context, 0);
                              }
                            },
                          )),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 6),
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(12),
                          )),
                          onPressed: _textEditingController.text.isNotEmpty
                              ? () {
                                  final fff =
                                      Folder(id: "friends", name: "От друзей");
                                  for (final reciever in _receievers) {
                                    var taskToSend = Task(
                                      id: uuid.v1(),
                                      parent: fff,
                                      name: _textEditingController.text,
                                      priority: _priority,
                                      done: false,
                                      haveTime: _haveTime,
                                      tags: [],
                                      from: reciever.uid,
                                      deadline: _deadline,
                                      description: _description,
                                      timeRequired: _timeRequired,
                                      place: _location,
                                    );
                                    firebaseTaskManager.sendTaskToFriend(
                                        taskToSend, reciever);
                                  }
                                  Navigator.pop(context);
                                }
                              : null,
                          child: const Text(
                            "Отправить",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
