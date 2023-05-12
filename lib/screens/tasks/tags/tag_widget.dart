import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../entities/tag.dart';

class TagItem extends StatelessWidget {
  final Tag _tag;

  const TagItem(this._tag, {super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(_tag.icon, color: _tag.color,);
  }
}

class TagsListWidget extends ConsumerWidget {
  final List<Tag> _tags;

  const TagsListWidget(this._tags, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return ListView.builder(
        itemCount: _tags.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
              return TagItem(_tags[index]);
          }
    );
  }
}