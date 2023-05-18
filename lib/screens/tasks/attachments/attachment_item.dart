import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const Map<String, String> fileTypeMap = {
'.pdf' : "application/pdf",
'.jpg' : "image/jpeg",
'.png' : "image/png",
'.docx': "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
'.doc' : "application/msword",
'.xlsx': "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
'.xls' : "application/vnd.ms-excel",
'.pptx': "application/vnd.openxmlformats-officedocument.presentationml.presentation",
'.ppt' : "application/vnd.ms-powerpoint",
};

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
        var ext = extension(path);
        ext = ext.substring(0, ext.indexOf('?'));
        OpenFilex.open(path, type: fileTypeMap[ext]);
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