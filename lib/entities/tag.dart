import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tag {
  IconData _icon;
  String _name;

  Tag(this._icon, this._name);

  IconData getIcon() {
    return _icon;
  }

  Map<String, dynamic> toFirestore() {
    return {
      "icon": _icon.codePoint,
      "name": _name,
    };
  }

  factory Tag.fromFirestore(Map<String, dynamic> data) {
    return Tag(
      IconData(data['icon'], fontFamily: 'MaterialIcons'),
      data['name'],
    );
  }

  String getName() {
    return _name;
  }
}
