import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'folder.dart';
import 'tag.dart';

enum Priority { high, medium, low, none }

enum Notification { week, threeDays, aDay, threeHours, anHour, atm }

class Task {
  String id;
  String? from;
  Folder parent;
  bool done;
  String name;
  Priority priority;
  DateTime? deadline;
  String? description;
  Duration? timeRequired;
  String? place;
  bool haveTime;
  List<String> tags;
  List<Notification>? notifications;

  Task({
    required this.id,
    required this.parent,
    required this.name,
    required this.priority,
    required this.done,
    required this.haveTime,
    required this.tags,
    this.from,
    this.deadline,
    this.description,
    this.timeRequired,
    this.place,
    this.notifications,
  });

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "parentId": parent.id,
      "name": name,
      "priority": priority.index,
      "done": done,
      "haveTime": haveTime,
      "from": from,
      if (deadline != null) "deadline": deadline,
      if (description != null) "description": description,
      if (timeRequired != null) "timeRequired": timeRequired!.inMinutes,
      if (place != null) "place": place,
      "tags": tags,
    };
  }

  factory Task.fromFirestore(
    Map<String, dynamic> data,
    Folder parent,
  ) {
    return Task(
      id: data['id'],
      parent: parent,
      name: data['name'],
      from: data['from'],
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
      tags: List.from(data['tags']),
    );
  }

  Task copyWith(
      {Folder? parent,
      String? name,
      Priority? priority,
      bool? done,
      bool? haveTime,
      String? from,
      DateTime? deadline,
      Duration? timeRequired,
      String? description,
      String? place,
      List<String>? tags}) {
    return Task(
      id: id,
      parent: parent ?? this.parent,
      name: name ?? this.name,
      priority: priority ?? this.priority,
      done: done ?? this.done,
      haveTime: haveTime ?? this.haveTime,
      from: from ?? this.from,
      tags: tags ?? this.tags,
      deadline: deadline ?? this.deadline,
      timeRequired: timeRequired ?? this.timeRequired,
      description: description ?? this.description,
      place: place ?? this.place,
    );
  }

  void update(
      {required Folder parent,
      required String name,
      required Priority priority,
      required List<String> tags,
      DateTime? deadline,
      bool? haveTime,
      Duration? timeRequired,
      String? description,
      String? from,
      String? place}) {
    this.parent = parent;
    this.name = name;
    this.priority = priority;
    this.tags = tags;
    this.deadline = deadline;
    this.haveTime = haveTime != null && haveTime;
    this.timeRequired = timeRequired;
    this.description = description;
    this.place = place;
    this.from = from;
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
      return "$measure д.";
    }
    measure = duration.inMinutes - duration.inHours * 60;
    return "${duration.inHours} ч. $measure м.";
  }

  String? get stringTimeRequired {
    if (timeRequired == null) {
      return null;
    }
    StringBuffer stringBuffer = StringBuffer();
    if (timeRequired!.inDays != 0) {
      stringBuffer.write("${timeRequired!.inDays} д. ");
    }
    if (timeRequired!.inMinutes - 60 * 24 * timeRequired!.inDays == 0) {
      return stringBuffer.toString().substring(0, stringBuffer.length - 1);
    }
    int hours = timeRequired!.inHours - 24 * timeRequired!.inDays;
    int minutes = timeRequired!.inMinutes - 60 * timeRequired!.inHours;
    if (hours < 10) {
      stringBuffer.write('0');
    }
    stringBuffer.write(hours);
    stringBuffer.write(":");
    if (minutes < 10) {
      stringBuffer.write('0');
    }
    stringBuffer.write(minutes);

    return stringBuffer.toString();
  }

  DateTime? get estimation {
    if (deadline == null || timeRequired == null) {
      return null;
    }
    return deadline!.subtract(timeRequired!);
  }

  String get path {
    return "${parent.getStringPath()}$name";
  }
}
