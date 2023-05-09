import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/global_providers.dart';

import '../entities/folder.dart';

class FolderStateNotifier extends StateNotifier<Folder> {
  final firebaseTaskManager = FirebaseTaskManager();
  FolderStateNotifier() : super(Folder(id: "root", name: "Общее", parent: null));

  void changeFolder(Folder newFolder) {
    state = newFolder;
  }

  void reload() async {
    final folder = await firebaseTaskManager.reloadFolder(state);
    state = Folder(id: folder.id, name: folder.name, parent: folder.parent);
  }
}