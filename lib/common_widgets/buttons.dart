import 'package:flutter/material.dart';

class ButtonDanger extends StatelessWidget {
  final String warningText;
  final String buttonText;
  final Function()? action;

  const ButtonDanger(
      {super.key,
      required this.buttonText,
      required this.warningText,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size.fromHeight(48)),
        onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(buttonText),
                content: Text(warningText),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.of(context).pop();
                    if (action != null) {
                      action!();
                    }
                  }, child: const Text("Yes")),
                  TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text("No")),
                ],
              );
            }),
        child: Text(buttonText));
  }
}

class ButtonDefault extends StatelessWidget {
  final String buttonText;
  final Function()? action;

  const ButtonDefault(
      {super.key, required this.buttonText, required this.action});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size.fromHeight(48)),
        onPressed: action,
        child: Text(buttonText));
  }
}
