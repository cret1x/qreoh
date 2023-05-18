import 'package:flutter/material.dart';

import '../../../common_widgets/discard_confirmation.dart';
import '../../../entities/folder.dart';

class CreateEditFolderWidget extends StatefulWidget {
  final List<Folder> _folders;
  final String? _oldName;

  CreateEditFolderWidget(this._oldName, this._folders, {super.key});

  @override
  State<StatefulWidget> createState() {
    return CreateEditFolderState(_oldName);
  }
}

class CreateEditFolderState extends State<CreateEditFolderWidget> {
  late TextEditingController _controller;

  CreateEditFolderState(String? oldName) {
    _controller = TextEditingController(text: oldName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget._oldName == null ? "Создание папки" : "Изменение папки",
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      content: TextFormField(
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
          onPressed: () async {
            bool? result = await showDialog(
                context: context, builder: (_) => const DiscardConfirmation());
            if (result == null || !result) {
              return;
            }
            Navigator.pop(context);
          },
          child: const Text("Отменить"),
        ),
        TextButton(
          onPressed: _controller.text.isNotEmpty
              ? () {
                  final res = widget._folders
                      .where((element) => element.name == _controller.text);
                  if (res.isNotEmpty &&
                      (widget._oldName == null ||
                          widget._oldName != _controller.text)) {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: const Text(
                                  "Папка с таким именем уже существует"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('ОК'),
                                )
                              ],
                            ));
                    return;
                  }
                  Navigator.pop(context, _controller.text);
                }
              : null,
          child: const Text("Сохранить"),
        ),
      ],
    );
  }
}
