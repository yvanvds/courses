import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/models/goals.dart';
import 'package:courses/data/models/topic.dart';
import 'package:courses/pages/course/topics/topic_content_tab.dart';
import 'package:courses/pages/course/topics/topic_goals_tab.dart';
import 'package:flutter/material.dart';

class TopicContentWidget extends StatefulWidget {
  final String courseID;
  final Topic topic;
  final Goals goals;

  const TopicContentWidget(
      {Key? key,
      required this.courseID,
      required this.topic,
      required this.goals})
      : super(key: key);

  @override
  State<TopicContentWidget> createState() => _TopicContentWidgetState();
}

class _TopicContentWidgetState extends State<TopicContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorDarkest,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Inhoud'),
                Tab(text: 'Doelen'),
                Tab(text: 'Instellingen'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TopicContentLoader(
                    courseID: widget.courseID,
                    topic: widget.topic,
                  ),
                  TopicGoalsTab(
                    courseID: widget.courseID,
                    topic: widget.topic,
                    goals: widget.goals,
                  ),
                  Text('instellingen'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
