import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/tasks/create_edit_tag.dart';
import 'package:uuid/uuid.dart';

import '../../firebase_functions/tasks.dart';
import 'task_manager_widget.dart';
import '../../entities/tag.dart';
import '../../entities/folder.dart';
import '../../entities/task.dart';

class EditCreateTaskWidget extends ConsumerStatefulWidget {
  final uuid = const Uuid();
  final Folder _folder;
  final Task? _task;

  const EditCreateTaskWidget(this._folder, this._task, {super.key});

  @override
  ConsumerState<EditCreateTaskWidget> createState() {
    return EditCreateTaskWidgetState(_task);
  }
}

class EditCreateTaskWidgetState extends ConsumerState<EditCreateTaskWidget> {
  String? _name;
  DateTime? _deadline;
  bool _haveTime = false;
  Duration? _timeRequired;
  int _daysRequired = 0;
  Priority _priority = Priority.none;
  String? _location;
  String? _description;
  List<Tag> _allTags = [];
  List<String> _selectedTags = [];

  EditCreateTaskWidgetState(Task? task) {
    if (task != null) {
      _name = task.name;
      _deadline = task.deadline;
      _haveTime = task.haveTime;
      _daysRequired = task.timeRequired == null ? 0 : task.timeRequired!.inDays;
      _timeRequired = task.timeRequired == null
          ? null
          : task.timeRequired! - Duration(days: _daysRequired);
      _priority = task.priority;
      _location = task.place;
      _description = task.description;
      for (String tag in task.tags) {
        _selectedTags.add(tag);
      }
    }
  }

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

  void _showCreateTagDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const CreateEditTagWidget(),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedTags = _selectedTags;
  }

  @override
  Widget build(BuildContext context) {
    _allTags = ref.watch(userTagsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Task"),
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
                  initialValue: _name,
                  onChanged: (String? value) {
                    _name = value;
                  },
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                    hintText: "Task name",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                          height: 40,
                          padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius:
                                      BorderRadiusDirectional.circular(12)),
                              child:
                                  Center(child: Text(widget._folder.name))))),
                  SizedBox(
                      height: 40,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  BorderRadiusDirectional.circular(12)),
                          child: Center(
                              child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.folder_open),
                            color: Colors.white,
                          ))))
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Deadline",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground)),
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
                        ))
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
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
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
                                                    child: Text(
                                                        index.toString()))),
                                          ),
                                        ),
                                      ));
                            },
                          ),
                          TextButton(
                            child: Text(_durationToString(_timeRequired)),
                            onPressed: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => Container(
                                        height: 216,
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        // The bottom margin is provided to align the popup above the system
                                        // navigation bar.
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        // Provide a background color for the popup.
                                        color: Theme.of(context).colorScheme.background,
                                        // Use a SafeArea widget to avoid system overlaps.
                                        child: SafeArea(
                                          top: false,
                                          child: CupertinoTimerPicker(
                                            initialTimerDuration:
                                                _timeRequired!,
                                            mode: CupertinoTimerPickerMode.hm,
                                            // This is called when the user changes the timer's
                                            // duration.
                                            onTimerDurationChanged:
                                                (Duration newDuration) {
                                              setState(() =>
                                                  _timeRequired = newDuration);
                                            },
                                          ),
                                        ),
                                      ),);
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Tags",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),
              Wrap(
                spacing: 10,
                children: [
                  ..._allTags
                      .map(
                        (tag) => InputChip(
                            avatar: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              foregroundColor: tag.color,
                              child: Icon(
                                tag.icon,
                                size: 20,
                              ),
                            ),
                            label: Text(
                              tag.name,
                              style: TextStyle(
                                color: _selectedTags.contains(tag.id)
                                    ? Colors.white
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                              ),
                            ),
                            onDeleted: () {
                              ref
                                  .read(userTagsProvider.notifier)
                                  .deleteTag(tag);
                            },
                            onPressed: () {
                              if (!_selectedTags.contains(tag.id)) {
                                setState(() {
                                  _selectedTags.add(tag.id);
                                });
                              } else {
                                setState(() {
                                  _selectedTags.remove(tag.id);
                                });
                              }
                            },
                            backgroundColor: _selectedTags.contains(tag.id)
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).chipTheme.backgroundColor),
                      )
                      .toList(),
                  ActionChip(
                    avatar: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    label: const Text('Добавить'),
                    onPressed: _showCreateTagDialog,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(right: 6),
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(12),
                          )),
                          child: const Text(
                            "Discard",
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
                                        "Are you sure you want to discard all changes?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text("YES")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text("NO")),
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
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (_name == null || _name!.isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content:
                                          const Text("Name must not be empty."),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("OK"))
                                      ],
                                    );
                                  });
                              return;
                            }
                            if (widget._task == null) {
                              final newTask = Task(
                                  id: widget.uuid.v1(),
                                  parent: widget._folder,
                                  name: _name!,
                                  done: false,
                                  priority: _priority,
                                  tags: _selectedTags,
                                  deadline: _deadline,
                                  haveTime: _haveTime,
                                  timeRequired: _timeRequired != null
                                      ? _timeRequired! +
                                          Duration(days: _daysRequired)
                                      : null,
                                  description: _description,
                                  place: _location);
                              ref
                                  .read(taskListStateProvider.notifier)
                                  .addTask(newTask);
                            } else {
                              widget._task!.update(
                                  name: _name!,
                                  priority: _priority,
                                  tags: _selectedTags,
                                  deadline: _deadline,
                                  haveTime: _haveTime,
                                  timeRequired: _timeRequired,
                                  description: _description,
                                  place: _location);
                              ref
                                  .read(taskListStateProvider.notifier)
                                  .updateTask(widget._task!);
                            }

                            Navigator.pop(
                                context, widget._task == null ? 1 : 0);
                          },
                        )),
                  ),
                ],
              ),
              Visibility(
                visible: widget._task != null,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.red[500],
                            borderRadius: BorderRadiusDirectional.circular(12),
                          ),
                          child: TextButton(
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              bool result = await showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  content: const Text(
                                      "Are you sure you want to delete task?\n"
                                      "You will not be able to restore it."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text("YES")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text("NO")),
                                  ],
                                ),
                              );
                              if (result) {
                                ref
                                    .read(taskListStateProvider.notifier)
                                    .deleteTask(widget._task!);
                                Navigator.pop(context, -1);
                              }
                            },
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
