import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/filter.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/entities/task.dart';
import 'package:qreoh/states/friends_list_state.dart';
import 'package:qreoh/states/network_state.dart';
import 'package:qreoh/states/task_list_state.dart';
import 'package:qreoh/states/user_auth_state.dart';
import 'package:qreoh/states/user_tags_state.dart';

class Baner{

  final String name;
  final AssetImage image;
  final int cost;
  bool bought = false;

  Baner(this.name, this.image, this.cost);
}

class Avatar{

  final String name;
  final AssetImage image;
  final int cost;
  bool bought = false;

  Avatar(this.name, this.image, this.cost);
}

List<Baner> banners = [
  Baner("baner1", AssetImage("graphics/background1.jpg"), 0),
  Baner("baner2", AssetImage("graphics/background2.jpg"), 20),
  Baner("baner3", AssetImage("graphics/background4.jpg"), 30),
  Baner("baner4", AssetImage("graphics/background5.jpg"), 40),
];

List<Avatar> avatars = [
  Avatar("avatar1", AssetImage("avatars/av1.jpg"), 0),
  Avatar("avatar2", AssetImage("avatars/av3.jpg"), 0),
  Avatar("avatar3", AssetImage("avatars/av2.jpg"), 20),
  Avatar("avatar4", AssetImage("avatars/av4.jpg"), 20),
  Avatar("avatar5", AssetImage("avatars/av5.jpg"), 40),
  Avatar("avatar6", AssetImage("avatars/av6.jpg"), 40),
];