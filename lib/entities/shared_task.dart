import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'action.dart' as my_action;
import 'receiver_info.dart';
import 'task.dart';

class SharedTask {
  String id;
  String name;
  Priority priority;
  DateTime? deadline;
  String? description;
  Duration? timeRequired;
  String? place;
  bool haveTime;
  List<String> attachments;
  List<ReceiverInfo> receivers;

  SharedTask({
    required this.id,
    required this.name,
    required this.priority,
    required this.haveTime,
    required this.attachments,
    required this.receivers,
    this.deadline,
    this.description,
    this.timeRequired,
    this.place,
  });

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "priority": priority.index,
      "haveTime": haveTime,
      if (deadline != null) "deadline": deadline,
      if (description != null) "description": description,
      if (timeRequired != null) "timeRequired": timeRequired!.inMinutes,
      if (place != null) "place": place,
      "attachments": attachments,
      "receivers": receivers.map((e) => e.toFirestore()),
    };
  }

  factory SharedTask.fromFirestore(
      Map<String, dynamic> data,
      ) {
    return SharedTask(
      id: data['id'],
      name: data['name'],
      priority: Priority.values[data['priority']],
      haveTime: data['haveTime'],
      deadline: data['deadline'] != null
          ? (data['deadline'] as Timestamp).toDate()
          : null,
      description: data['description'],
      timeRequired: data['timeRequired'] != null
          ? Duration(minutes: data['timeRequired'])
          : null,
      place: data['place'],
      attachments: List.from(data['attachments']),
      receivers: data['receivers'],
    );
  }

  SharedTask copyWith(
      {String? name,
        Priority? priority,
        bool? haveTime,
        DateTime? deadline,
        Duration? timeRequired,
        String? description,
        String? place,
        List<String>? attachments,
        List<ReceiverInfo>? receivers}) {
    return SharedTask(
      id: id,
      name: name ?? this.name,
      priority: priority ?? this.priority,
      haveTime: haveTime ?? this.haveTime,
      deadline: deadline ?? this.deadline,
      timeRequired: timeRequired ?? this.timeRequired,
      description: description ?? this.description,
      place: place ?? this.place,
      attachments: attachments ?? this.attachments,
      receivers: receivers ?? this.receivers,
    );
  }

  void addAction(String id, my_action.Action action) {
    final receiver = receivers.where((element) => element.receiverId == id);
    if (receiver.isNotEmpty) {
      receiver.first.addAction(action);
    }
  }

  Text get textPriority {
    String name;
    Color? color;
    switch (priority) {
      case Priority.high:
        name = "Высокий";
        color = Colors.red[500];
        break;
      case Priority.medium:
        name = "Средний";
        color = Colors.orange[400];
        break;
      case Priority.low:
        name = "Низкий";
        color = Colors.green[500];
        break;
      case Priority.none:
        name = "Без приоритета";
        color = Colors.grey;
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
}