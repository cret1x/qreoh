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

  String getStringPath() {
    if (parent == null) {
      return "$name/";
    }
    return "${parent!.getStringPath()}$name/";
  }

  List<String> getIdPath() {
    List<String> ids = [id];
    Folder? current = parent;
    while (current != null) {
      ids.add(id);
      current = current.parent;
    }
    return ids.reversed.toList();
  }
}