import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qreoh/common_widgets/delete_confimation.dart';

import '../../../firebase_functions/storage.dart';
import 'attachment_item.dart';

class EditAttachmentsWidget extends StatefulWidget {
  final String taskId;
  final List<String> _attachments;
  final firebaseStorageManager = FirebaseStorageManager();

  EditAttachmentsWidget(this.taskId, this._attachments, {super.key});

  @override
  State<StatefulWidget> createState() {
    return EditAttachmentsState();
  }
}

class EditAttachmentsState extends State<EditAttachmentsWidget> {

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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            itemBuilder: (context, index) {
              return Dismissible(
                background: const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  bool? result = await showDialog(context: context, builder: (_) => DeleteConfirmation("приложение"));
                  if (result == null || !result) {
                    return false;
                  }
                  return true;
                },
                onDismissed: (_) => setState(() {
                  widget._attachments.removeAt(index);
                }),
                key: UniqueKey(),
                child: AttachmentWidget(widget._attachments[index]),);
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
