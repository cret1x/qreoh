import 'package:flutter/material.dart';

import '../strings.dart';

class DiscardConfirmation extends StatelessWidget {
  const DiscardConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(Strings.discardConfirmation),
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
            child: const Text(Strings.no)),
      ],
    );
  }
}