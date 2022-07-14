import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/topic.dart';
import 'package:courses/pages/course/content/topic_editor.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:courses/widgets/cards/app_card.dart';
import 'package:flutter/material.dart';

class TopicsWidget extends StatefulWidget {
  final List<Topic>? topics;
  final String courseID;

  const TopicsWidget({Key? key, required this.courseID, this.topics})
      : super(key: key);

  @override
  State<TopicsWidget> createState() => _TopicsWidgetState();
}

class _TopicsWidgetState extends State<TopicsWidget> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 400,
      maximize: true,
      title: Row(
        children: [
          Text('Onderwerpen', style: AppTheme.text.subtitle1),
          const Spacer(),
          AppButton(
            icon: Icons.add_circle,
            text: 'Nieuw',
            onPressed: () async {
              Topic? result = await showDialog(
                context: context,
                builder: (_) {
                  return const TopicEditor();
                },
              );
              if (result != null) {
                await Data.topics
                    .create(courseID: widget.courseID, name: result.name);
              }
            },
          ),
        ],
      ),
      content: widget.topics != null
          ? ListView.builder(
              itemCount: widget.topics?.length,
              itemBuilder: (context, index) {
                return topicCard(index);
              },
            )
          : Container(),
    );
  }

  Card topicCard(int index) {
    return Card(
      color: AppTheme.colorDarkest,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.topics![index].name,
                  style: AppTheme.text.subtitle1,
                ),
              ],
            ),
            const Spacer(),
            AppButton(
              icon: Icons.edit,
              onPressed: () async {
                Topic? result = await showDialog(
                  context: context,
                  builder: (_) {
                    return TopicEditor(topic: widget.topics![index]);
                  },
                );
                if (result != null) {
                  Data.topics.update(widget.courseID, result);
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: AppButton(
                color: AppTheme.colorWarning,
                onPressed: () async {
                  Data.topics.delete(widget.courseID, widget.topics![index].id);
                },
                icon: Icons.delete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
