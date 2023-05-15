import 'package:flutter/material.dart';

import '../strings.dart';

class DeleteConfirmation extends StatelessWidget {
  final String object;
  const DeleteConfirmation(this.object, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(Strings.deleteConfirmationText(object)),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(Strings.yes)),
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text(Strings.no),
        ),
      ],
    );
  }
}
