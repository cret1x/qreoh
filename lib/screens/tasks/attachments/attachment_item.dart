import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

Future<File> createFileOfPdfUrl(String url) async {
  Completer<File> completer = Completer();
  try {
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$filename");
    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }

  return completer.future;
}

String getName(String url) {
  return url.substring(url.lastIndexOf('%') + 3, url.lastIndexOf('?'));
}

class AttachmentWidget extends StatelessWidget {
  final String _attachment;

  const AttachmentWidget(this._attachment, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final path = await createFileOfPdfUrl(_attachment).then((f) => f.path);
        OpenFilex.open(path);
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          getName(_attachment),
        ),
      ),
    );
  }
}