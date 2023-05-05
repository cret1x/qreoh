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

  FoldersWidgetState(this._current);

  @override
  Widget build(BuildContext context) {
    final children = ref
        .read(taskListStateProvider.notifier)
        .firebaseTaskManager
        .getSubFolders(_current, true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Folders"),
      ),
      body: FutureBuilder(
        future: children,
        builder: (context, snapshot) {
          return Stack(
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
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
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
                      Flexible(
                        fit: FlexFit.loose,
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
                              child: SizedBox(
                                child: !snapshot.hasData
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: const [
                                            CircularProgressIndicator()
                                          ],
                                        ),
                                      )
                                    : snapshot.data!.isNotEmpty
                                        ? ClipRect(
                                            child: ListView.separated(
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Padding(
                                                    padding: EdgeInsets.all(20),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _current = snapshot
                                                            .data![index];
                                                        setState(() {});
                                                      },
                                                      child: SizedBox(
                                                        height: 20,
                                                        child: Text(snapshot
                                                            .data![index].name),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const Divider();
                                                },
                                                itemCount:
                                                    snapshot.data!.length),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: const [
                                                Text("No subfolders."),
                                              ],
                                            ),
                                          ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
