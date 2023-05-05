import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/firebase_functions/folders.dart';

import '../../entities/folder.dart';

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
    final children = getSubFolders(_current);
    return FutureBuilder(
        future: children,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Filters"),
            ),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
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
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Wrap(runSpacing: 12, children: []))))),
                )
          );

        });
  }
}
