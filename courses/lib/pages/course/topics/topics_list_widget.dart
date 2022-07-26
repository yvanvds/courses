import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/topic.dart';
import 'package:courses/pages/course/topics/topic_editor.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:courses/widgets/cards/app_card.dart';
import 'package:flutter/material.dart';

class TopicsListWidget extends StatefulWidget {
  final List<Topic>? topics;
  final String courseID;
  final Function(Topic) onSelect;

  const TopicsListWidget(
      {Key? key, required this.courseID, this.topics, required this.onSelect})
      : super(key: key);

  @override
  State<TopicsListWidget> createState() => _TopicsListWidgetState();
}

class _TopicsListWidgetState extends State<TopicsListWidget> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 300,
      maximize: true,
      title: Row(
        children: [
          Text('Onderwerpen', style: AppTheme.text.subtitle1),
          const Spacer(),
          AppButton(
            icon: Icons.add_circle,
            //text: 'Nieuw',
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

  Widget topicCard(int index) {
    return ElevatedButton(
      style: ElevatedButtonTheme.of(context).style?.copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return AppTheme.colorDarkest;
        }),
      ),
      onPressed: () => widget.onSelect(widget.topics![index]),
      child: Text(
        widget.topics![index].name,
        style: AppTheme.text.subtitle1,
      ),
    );
  }
}
