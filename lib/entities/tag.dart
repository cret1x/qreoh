import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tag {
  String id;
  IconData icon;
  String name;
  Color color;

  Tag({
    required this.id,
    required this.icon,
    required this.name,
    required this.color,
  });

  Map<String, dynamic> toFirestore() {
    return {
      "icon": icon.codePoint,
      "name": name,
      "color": color.value,
    };
  }

  factory Tag.fromFirestore(String id, Map<String, dynamic> data) {
    return Tag(
      id: id,
      icon: IconData(data['icon'], fontFamily: 'MaterialIcons'),
      name: data['name'],
      color: Color(data['color']),
    );
  }

  @override
  bool operator ==(Object other) {
    return id == (other as Tag).id;
  }

  @override
  int get hashCode => id.hashCode;

  void update({required String name,
               required Color color,
               required IconData icon}) {
    this.name = name;
    this.color = color;
    this.icon = icon;
  }
}
