import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/screens/tasks/tags/create_edit_tag.dart';
import 'package:qreoh/states/app_theme_state.dart';
import 'package:qreoh/states/user_tags_state.dart';

import '../../../entities/tag.dart';
import '../../../global_providers.dart';

class TagsWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return TagsState();
  }
}

class TagsState extends ConsumerState<TagsWidget> {
  List<Tag> _allTags = [];
  AppThemeState _appThemeState = AppThemeState.base();

  @override
  Widget build(BuildContext context) {
    _allTags = ref.watch(userTagsProvider);
    _appThemeState = ref.watch(appThemeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Tags"),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Theme.of(context).colorScheme.brightness == Brightness.light
                      ? _appThemeState.lightBackground
                      : _appThemeState.darkBackground,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const CreateEditTagWidget(null),
                    );
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Create Tag'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                key: UniqueKey(),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          CreateEditTagWidget(_allTags[index]),
                                    );
                                    return false;
                                  }
                                  return true;
                                },
                                onDismissed: (direction) => ref
                                    .read(userTagsProvider.notifier)
                                    .deleteTag(_allTags[index]),
                                secondaryBackground: const Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                background: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Icon(
                                      Icons.mode_edit_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _allTags[index].icon,
                                        color: _allTags[index].color,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Text(_allTags[index].name),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemCount: _allTags.length,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
