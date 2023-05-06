import 'package:flutter/material.dart';

class CreateEditFolderWidget extends StatefulWidget {
  final String? _oldName;
  const CreateEditFolderWidget(this._oldName, {super.key});

  @override
  State<StatefulWidget> createState() {
    return CreateEditFolderState();
  }
}

class CreateEditFolderState extends State<CreateEditFolderWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      content: TextFormField(
        initialValue: widget._oldName,
        controller: _controller,
        maxLength: 20,
        onChanged: (String? value) {
          setState(() {});
        },
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary),
          ),
          labelText: "Название папки",
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Discard"),
        ),
        TextButton(
          onPressed: _controller.text.isNotEmpty
              ? () {
                  Navigator.pop(context, _controller.text);
                }
              : null,
          child: const Text("Save"),
        ),
      ],
    );
  }
}
