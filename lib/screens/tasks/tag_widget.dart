import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../entities/tag.dart';

class TagItem extends StatelessWidget {
  final Tag _tag;

  const TagItem(this._tag, {super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(_tag.getIcon());
  }
}

class TagsWidget extends ConsumerWidget {
  final List<Tag> _tags;

  const TagsWidget(this._tags, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Expanded(
      child:  ListView.builder(
        itemCount: _tags.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
              return TagItem(_tags[index]);
          }
      )
    );
  }
}