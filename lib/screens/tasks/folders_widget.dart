import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/firebase_functions/tasks.dart';

import '../../entities/folder.dart';
import '../../global_providers.dart';

class FoldersWidget extends ConsumerStatefulWidget {
  final Folder _initialFolder;

  const FoldersWidget(this._initialFolder, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return FoldersWidgetState(_initialFolder);
  }
}

class FoldersWidgetState extends ConsumerState<FoldersWidget> {
  Folder _current;
  late bool _isOnline;

  FoldersWidgetState(this._current);

  @override
  Widget build(BuildContext context) {
    _isOnline = ref.watch(authStateProvider);
    final children = ref.read(taskListStateProvider.notifier).firebaseTaskManager.getSubFolders(_current, _isOnline);
    return FutureBuilder(
        future: children,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Folders"),
            ),
            body: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            Theme.of(context).colorScheme.brightness ==
                                    Brightness.light
                                ? "graphics/background2.jpg"
                                : "graphics/background5.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        child: ClipRect(
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 16, bottom: 4),
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 2.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            ),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 12, 0),
                                          child: Center(
                                            child: Text(
                                              _current.name,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: snapshot.hasData &&
                                      snapshot.data!.isNotEmpty
                                  ? SingleChildScrollView(
                                      child: ListView.separated(
                                        physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              children: [

                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const Divider();
                                          },
                                          itemCount: snapshot.data!.length),
                                    )
                                  : const Center(
                                      child: Text("No subfolders."),
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
