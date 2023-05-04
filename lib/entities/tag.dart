import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tag {
  String id;
  IconData _icon;
  String _name;

  Tag(this.id, this._icon, this._name);

  IconData getIcon() {
    return _icon;
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "icon": _icon.codePoint,
      "name": _name,
    };
  }

  factory Tag.fromFirestore(Map<String, dynamic> data) {
    return Tag(data['id'],
      IconData(data['icon'], fontFamily: 'MaterialIcons'),
      data['name'],
    );
  }

  String getName() {
    return _name;
  }

  @override
  bool operator ==(Object other) {
    return id == (other as Tag).id;
  }
}
