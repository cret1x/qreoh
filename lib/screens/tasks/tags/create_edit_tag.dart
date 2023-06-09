import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/tag.dart';
import 'package:qreoh/global_providers.dart';
import 'package:uuid/uuid.dart';

const List<IconData> icons = [
  Icons.ac_unit,
  Icons.access_alarm,
  Icons.access_time,
  //TODO: add icons
];

class CreateEditTagWidget extends ConsumerStatefulWidget {
  final Tag? _tag;

  const CreateEditTagWidget(this._tag, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateEditTagState(_tag);
}

class _CreateEditTagState extends ConsumerState<CreateEditTagWidget> {
  late final TextEditingController _controller;
  final uuid = const Uuid();
  Color _selectedColor = Colors.red;
  IconData _selectedIcon = icons.first;

  _CreateEditTagState(Tag? tag) {
    if (tag != null) {
      _selectedColor = tag.color;
      _selectedIcon = tag.icon;
      _controller = TextEditingController(text: tag.name);
    } else {
      _controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Создание тега",
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      content: Wrap(
        children: [
          TextFormField(
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
              labelText: "Название тэга",
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Цвет",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  content: BlockPicker(
                                    pickerColor: _selectedColor,
                                    onColorChanged: (Color color) {
                                      setState(() {
                                        _selectedColor = color;
                                      });
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                  title: Text(
                                    "Цвет тега",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text("Выбрать"),
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Иконка",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 5,
                  children: [
                    for (var icon in icons)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        },
                        child: Icon(
                          icon,
                          size: 32,
                          color: _selectedIcon == icon
                              ? _selectedColor
                              : Theme.of(context).iconTheme.color,
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: _controller.text.isNotEmpty
                ? () {
                    if (widget._tag == null) {
                      ref.read(userTagsProvider.notifier).addTag(Tag(
                          id: uuid.v1(),
                          icon: _selectedIcon,
                          name: _controller.text,
                          color: _selectedColor));
                    } else {
                      widget._tag!.update(
                          name: _controller.text,
                          color: _selectedColor,
                          icon: _selectedIcon);
                      ref
                          .read(userTagsProvider.notifier)
                          .updateTag(widget._tag!);
                    }
                    Navigator.pop(context);
                  }
                : null,
            child: const Text("Сохранить")),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Отменить"),
        )
      ],
    );
  }
}
