import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/models/topic.dart';
import 'package:courses/pages/course/topics/content_card.dart';
import 'package:courses/pages/course/topics/content_type_picker.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:courses/widgets/loading.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TopicContentLoader extends StatelessWidget {
  final String courseID;
  final Topic topic;
  const TopicContentLoader(
      {Key? key, required this.courseID, required this.topic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<IContent>?>(
      create: (_) => Data.content.get(courseID, topic.id),
      initialData: null,
      builder: (context, widget) {
        List<IContent>? content = Provider.of<List<IContent>?>(context);
        if (content == null) return const Loading();
        return TopicContentTab(
          courseID: courseID,
          topic: topic,
          content: content,
        );
      },
    );
  }
}

class TopicContentTab extends StatefulWidget {
  final String courseID;
  final Topic topic;
  final List<IContent> content;

  const TopicContentTab(
      {Key? key,
      required this.courseID,
      required this.topic,
      required this.content})
      : super(key: key);

  @override
  State<TopicContentTab> createState() => _TopicContentTabState();
}

class _TopicContentTabState extends State<TopicContentTab> {
  final List<DragAndDropItem> _contents = [];

  @override
  void initState() {
    for (int i = 0; i < widget.content.length; i++) {
      IContent currentContent = widget.content[i];
      _contents.add(
        DragAndDropItem(
          child: ContentCard(
            content: currentContent,
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: Column(
            children: [
              Expanded(
                child: DragAndDropLists(
                  children: [
                    DragAndDropList(
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
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: Icon(
                        Icons.menu,
                        color: AppTheme.colorDarkest,
                      ),
                    ),
                  ),
                ),
              ),
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
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }

  _createContent(ContentType type) {
    context.go(
        '/course/${widget.courseID}/topic/${widget.topic.id}/newcontent/${type.name}');
  }

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,
      int newListIndex) async {
    setState(() {
      var movedItem = _contents.removeAt(oldItemIndex);
      _contents.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) async {}
}
