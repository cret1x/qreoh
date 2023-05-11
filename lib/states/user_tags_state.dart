
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/firebase_functions/tags.dart';

class TagListStateNotifier extends StateNotifier<List<Tag>> {
  TagListStateNotifier() : super([]) {
    loadTags();
  }
  final firebaseTagManager = FirebaseTagManager();

  void addTag(Tag tag) async {
    await firebaseTagManager.createTag(tag);
    state = [...state, tag];
  }

  void deleteTag(Tag tag) async {
    await firebaseTagManager.deleteTag(tag);
    state = [
      for (final tg in state)
        if (tg.id != tag.id) tg
    ];
  }

  void updateTag(Tag tag) async {
    await firebaseTagManager.updateTag(tag);
    state = [
      for (final tg in state)
        if (tg.id == tag.id) tag else tg
    ];
  }

  void loadTags() async {
    state = await firebaseTagManager.getAllTags();
  }
}