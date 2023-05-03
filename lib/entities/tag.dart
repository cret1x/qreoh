import 'package:flutter/cupertino.dart';

class Tag {
  IconData _icon;
  String _name;

  Tag(this._icon, this._name);

  IconData getIcon() {
    return _icon;
  }

  String getName() {
    return _name;
  }
}