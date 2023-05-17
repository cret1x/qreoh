import 'package:flutter/material.dart';

import 'attachment_item.dart';

class AttachmentList extends StatelessWidget {
  final List<String> _attachments;

  const AttachmentList(this._attachments, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Приложения"),
      ),
      body: Column(
        children: [
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            itemBuilder: (context, index) {
              return AttachmentWidget(_attachments[index]);
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: _attachments.length,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}
