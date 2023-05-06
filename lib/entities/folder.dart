import 'package:cloud_firestore/cloud_firestore.dart';

import 'task.dart';

class Folder {
  String id;
  String name;
  Folder? parent;

  Folder({required this.id, required this.name, this.parent});

  factory Folder.fromFirestore(String id, String name, Folder parent) {
    return Folder(id: id, name: name, parent: parent);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      if (parent != null) "parent": parent!.id,
    };
  }

  String getStringPath() {
    if (parent == null) {
      return "$name/";
    }
    return "${parent!.getStringPath()}$name/";
  }

  void rename(String name) {
    this.name = name;
  }
}