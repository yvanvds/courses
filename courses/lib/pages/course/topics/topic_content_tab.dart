import 'package:courses/convienience/app_theme.dart';
import 'package:courses/convienience/random_key.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/models/topic.dart';
import 'package:courses/pages/course/topics/content_card.dart';
import 'package:courses/pages/course/topics/content_type_picker.dart';
import 'package:courses/widgets/app_dialog.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:courses/widgets/loading.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TopicContentLoader extends StatelessWidget {
  final String courseID;
  final String topicID;
  const TopicContentLoader(
      {Key? key, required this.courseID, required this.topicID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Topic?>(
      create: (_) => Data.topics.getSingle(courseID, topicID),
      initialData: null,
      builder: (context, widget) {
        Topic? topic = Provider.of<Topic?>(context);
        if (topic == null) return const Loading();
        return TopicContentTab(
          key: RandomValues.getKey(),
          courseID: courseID,
          topic: topic,
        );
      },
    );
  }
}

class TopicContentTab extends StatefulWidget {
  final String courseID;
  final Topic topic;

  const TopicContentTab({
    Key? key,
    required this.courseID,
    required this.topic,
  }) : super(key: key);

  @override
  State<TopicContentTab> createState() => _TopicContentTabState();
}

class _TopicContentTabState extends State<TopicContentTab> {
  final List<DragAndDropItem> _contents = [];

  @override
  void initState() {
    for (int i = 0; i < widget.topic.contents.length; i++) {
      ContentLink link = widget.topic.contents[i];
      _contents.add(
        DragAndDropItem(
          child: ContentCard(
            content: link,
            onEdit: () {
              context.push(
                  '/course/${widget.courseID}/topics/${widget.topic.id}/edit/${link.id}');
            },
            onDelete: () async {
              await showDialog(
                context: context,
                builder: (_) => AppDialog(
                  title: 'Ben je zeker?',
                  content: const Text('Je kan dit niet ongedaan maken'),
                  confirmText: 'Verwijder',
                  onConfirm: () async {
                    await Data.content.delete(
                        courseID: widget.courseID,
                        topicID: widget.topic.id,
                        contentID: link.id);
                    widget.topic.contents.remove(link);
                    await Data.topics.update(widget.courseID, widget.topic);
                    context.pop();
                  },
                ),
              );
            },
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 400,
                child: buildList(),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                icon: Icons.add_circle,
                text: 'Inhoud Toevoegen',
                onPressed: () async {
                  ContentType? result = await showDialog(
                    context: context,
                    builder: (_) {
                      return const ContentTypePickerDialog();
                    },
                  );
                  if (result != null) {
                    _createContent(result);
                  }
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                icon: Icons.view_carousel,
                text: 'Onderwerp Tonen',
                onPressed: () {
                  context.push(
                      '/course/${widget.courseID}/topics/${widget.topic.id}/view');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  DragAndDropLists buildList() {
    return DragAndDropLists(
      children: [
        DragAndDropList(
          header: const Text(' '),
          children: _contents,
          contentsWhenEmpty: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: AppTheme.colorDark,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Geen Inhouden',
                        style: AppTheme.text.subtitle2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      onItemReorder: _onItemReorder,
      onListReorder: _onListReorder,
      itemDragHandle: DragHandle(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, right: 16),
          child: Icon(
            Icons.menu,
            color: AppTheme.colorLightest,
          ),
        ),
      ),
    );
  }

  _createContent(ContentType type) {
    context.push(
        '/course/${widget.courseID}/topics/${widget.topic.id}/create/${type.name}');
  }

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,
      int newListIndex) async {
    setState(() {
      var movedItem = _contents.removeAt(oldItemIndex);
      _contents.insert(newItemIndex, movedItem);
    });

    widget.topic.contents.clear();
    for (var element in _contents) {
      var child = element.child as ContentCard;
      widget.topic.contents.add(child.content);
    }
    await Data.topics.update(widget.courseID, widget.topic);
  }

  _onListReorder(int oldListIndex, int newListIndex) async {}
}
