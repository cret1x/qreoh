import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../firebase_functions/storage.dart';

class EditAttachmentsWidget extends StatefulWidget {
  final String taskId;
  final List<String> _attachments = ['https://zagorie.ru/upload/iblock/4ea/4eae10bf98dde4f7356ebef161d365d5.pdf'];
  final firebaseStorageManager = FirebaseStorageManager();

  EditAttachmentsWidget(this.taskId, List<String> attachments, {super.key}) {
    _attachments.addAll(attachments);
  }

  @override
  State<StatefulWidget> createState() {
    return EditAttachmentsState();
  }
}

class EditAttachmentsState extends State<EditAttachmentsWidget> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Приложения"),
        actions: [
          IconButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.custom,
                  allowedExtensions: [
                    'pdf',
                    'jpg',
                    'png',
                    'docx',
                    'doc',
                    'xlsx',
                    'xls',
                    'pptx',
                    'ppt',
                    'pdf',
                    'txt'
                  ]);

              if (result != null) {
                List<File> files = [];
                for (var file in result.files) {
                  files.add(File(file.path!));
                }
                List<String> urls = await widget.firebaseStorageManager
                    .uploadAttachments(widget.taskId, files);
                widget._attachments.addAll(urls);
                setState(() {});
              } else {
                // User canceled the picker
              }
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          ListView.separated(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  final path = await createFileOfPdfUrl(widget._attachments[index]).then((f) => f.path);
                  OpenFilex.open(path);
                },
                child: Text(
                  widget._attachments[index],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: widget._attachments.length,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}
