import 'package:flutter/material.dart';
import 'folder.dart';
import 'tag.dart';

enum Priority { high, medium, low, none }

enum Notification { week, threeDays, aDay, threeHours, anHour, atm }

class Task {
  Folder _parent;
  bool _done = false;
  String _name;
  Priority _priority;
  DateTime? _deadline;
  String? _description;
  Duration? _timeRequired;
  String? _place;
  bool _haveTime = false;
  late List<Tag> _tags = <Tag>[];
  List<Notification> _notifications = [];

  Task(this._parent, this._name, this._priority,
      [List<Tag>? tags,
      this._deadline,
      bool? haveTime,
      this._timeRequired,
      this._description,
      this._place]) {
    if (tags != null) {
      for (var tag in tags) {
        _tags.add(tag);
      }
    }
    _haveTime = haveTime != null && haveTime;
  }

  void update(
      String name,
      Priority priority,
      List<Tag> tags,
      DateTime? deadline,
      bool? haveTime,
      Duration? timeRequired,
      String? description) {
    _name = name;
    _priority = priority;
    _tags = [];
    for (var tag in tags) {
      _tags.add(tag);
    }
    _deadline = deadline;
    _haveTime = haveTime != null && haveTime;
    _timeRequired = timeRequired;
    _description = description;
  }

  void setState(bool? state) {
    _done = state!;
  }

  bool getState() {
    return _done;
  }

  String getName() {
    return _name;
  }

  Priority getPriority() {
    return _priority;
  }

  Text getTextPriority() {
    String name;
    Color? color;
    switch (_priority) {
      case Priority.high:
        name = "High";
        color = Colors.red[500];
        break;
      case Priority.medium:
        name = "Medium";
        color = Colors.orange[400];
        break;
      case Priority.low:
        name = "Low";
        color = Colors.green[500];
        break;
      case Priority.none:
        name = "None";
        color = Colors.grey[700];
        break;
    }
    return Text(name, style: TextStyle(color: color));
  }

  List<Tag> getTags() {
    return _tags;
  }

  String getDate() {
    if (_deadline == null) {
      return '';
    }
    String date = _deadline!.toString();
    if (!_haveTime) {
      date = date.substring(0, 10);
    } else {
      date = date.substring(0, 16);
    }
    return date;
  }

  DateTime? getDeadline() {
    return _deadline;
  }

  Folder getParent() {
    return _parent;
  }

  String getTimeLeft() {
    if (_deadline == null) {
      return "";
    }
    Duration duration = _deadline!.difference(DateTime.now());
    int measure = duration.inDays;
    if (measure.abs() > 0) {
      return "$measure days";
    }
    measure = duration.inMinutes - duration.inHours * 60;
    return "${duration.inHours} hours $measure minutes";
  }

  String? getDescription() {
    return _description;
  }

  String? getLocation() {
    return _place;
  }

  void setLocation(String location) {
    _place = location;
  }

  String? getStringTimeRequired() {
    if (_timeRequired == null) {
      return null;
    }
    StringBuffer stringBuffer = StringBuffer();
    if (_timeRequired!.inDays != 0) {
      stringBuffer.write("${_timeRequired!.inDays} days ");
    }
    stringBuffer.write(_timeRequired.toString().substring(0, 5));
    return stringBuffer.toString().substring(0, stringBuffer.length - 1);
  }

  Duration? getTimeRequired() {
    return _timeRequired;
  }

  DateTime? getEstimation() {
    if (_deadline == null || _timeRequired == null) {
      return null;
    }
    return _deadline!.subtract(_timeRequired!);
  }

  String getPath() {
    return "${_parent.getPath()}$_name";
  }

  bool getHaveTime() {
    return _haveTime;
  }
}
