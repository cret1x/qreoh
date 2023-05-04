import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'folder.dart';
import 'tag.dart';

enum Priority { high, medium, low, none }

enum Notification { week, threeDays, aDay, threeHours, anHour, atm }

class Task {
  String id;
  Folder parent;
  bool done;
  String name;
  Priority priority;
  DateTime? deadline;
  String? description;
  Duration? timeRequired;
  String? place;
  bool haveTime;
  List<Tag> tags;
  List<Notification>? notifications;

  Task({
    required this.id,
    required this.parent,
    required this.name,
    required this.priority,
    required this.done,
    required this.haveTime,
    required this.tags,
    this.deadline,
    this.description,
    this.timeRequired,
    this.place,
    this.notifications,
  });


  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "priority": priority.index,
      "done": done,
      "haveTime": haveTime,
      if (deadline != null) "deadline": deadline,
      if (description != null) "description": description,
      if (timeRequired != null) "timeRequired": timeRequired!.inMinutes,
      if (place != null) "place": place,
      "tags": tags.map((e) => e.toFirestore()),
    };
  }

  factory Task.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    Folder parent,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    List<Tag> tags = [];
    if (data['tags'] != null) {
      for (var element in data['tags']) {
        tags.add(Tag.fromFirestore(element));
      }
    }
    return Task(
      id: data['id'],
      parent: parent,
      name: data['name'],
      priority: Priority.values[data['priority']],
      done: data['done'],
      haveTime: data['haveTime'],
      deadline: data['deadline'] != null
          ? (data['deadline'] as Timestamp).toDate()
          : null,
      description: data['description'],
      timeRequired: data['timeRequired'] != null
          ? Duration(minutes: data['timeRequired'])
          : null,
      place: data['place'],
      tags: tags,
    );
  }

  void update(
      String name,
      Priority priority,
      List<Tag> tags,
      DateTime? deadline,
      bool? haveTime,
      Duration? timeRequired,
      String? description) {
    this.name = name;
    this.priority = priority;
    this.tags = tags;
    this.deadline = deadline;
    this.haveTime = haveTime != null && haveTime;
    this.timeRequired = timeRequired;
    this.description = description;
  }


  void markAsDone() {
    done = true;
  }

  void markAsNotDone() {
    done = false;
  }

  Text get textPriority {
    String name;
    Color? color;
    switch (priority) {
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

  String get stringDate {
    if (deadline == null) {
      return '';
    }
    String date = deadline!.toString();
    if (!haveTime) {
      date = date.substring(0, 10);
    } else {
      date = date.substring(0, 16);
    }
    return date;
  }

  String get stringTimeLeft {
    if (deadline == null) {
      return "";
    }
    Duration duration = deadline!.difference(DateTime.now());
    int measure = duration.inDays;
    if (measure.abs() > 0) {
      return "$measure days";
    }
    measure = duration.inMinutes - duration.inHours * 60;
    return "${duration.inHours} hours $measure minutes";
  }

  String? get stringTimeRequired {
    if (timeRequired == null) {
      return null;
    }
    StringBuffer stringBuffer = StringBuffer();
    if (timeRequired!.inDays != 0) {
      stringBuffer.write("${timeRequired!.inDays} days ");
    }
    stringBuffer.write(timeRequired.toString().substring(0, 5));
    return stringBuffer.toString().substring(0, stringBuffer.length - 1);
  }

  DateTime? get estimation {
    if (deadline == null || timeRequired == null) {
      return null;
    }
    return deadline!.subtract(timeRequired!);
  }

  String get path {
    return "${parent.getPath()}$name";
  }
}
