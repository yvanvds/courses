import 'package:courses/data/data.dart';
import 'package:courses/data/models/course.dart';
import 'package:courses/data/models/goals.dart';
import 'package:courses/data/models/topic.dart';
import 'package:courses/pages/course/topics/topic_content_widget.dart';
import 'package:courses/pages/course/topics/topics_list_widget.dart';
import 'package:courses/widgets/footer.dart';
import 'package:courses/widgets/header.dart';
import 'package:courses/widgets/loading.dart';
import 'package:courses/widgets/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseContentPage extends StatefulWidget {
  final String courseID;
  const CourseContentPage({Key? key, required this.courseID}) : super(key: key);

  @override
  State<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> {
  List<Topic>? topics;
  Topic? selected;
  Goals? goals;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Cursus Inhoud',
      providers: [
        StreamProvider<Course?>(
            create: (_) => Data.courses.get(widget.courseID),
            initialData: null),
        StreamProvider<List<Topic>?>(
            create: (_) => Data.topics.getAll(widget.courseID),
            initialData: null),
        StreamProvider<Goals?>(
            create: (_) => Data.goals.get(widget.courseID), initialData: null),
      ],
      builder: (BuildContext context) {
        Course? course = Provider.of<Course?>(context);
        topics = Provider.of<List<Topic>?>(context);
        goals = Provider.of<Goals?>(context);

        if (course == null) return const Loading();

        return buildContent(course);
      },
    );
  }

  Widget buildContent(Course course) {
    return Column(
      children: [
        AppHeader(text: course.name),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopicsListWidget(
                courseID: widget.courseID,
                topics: topics,
                onSelect: (topic) {
                  selected = topic;
                  setState(() {});
                }),
            selected != null && goals != null
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TopicContentWidget(
                        courseID: widget.courseID,
                        topic: selected!,
                        goals: goals!,
                      ),
                    ),
                  )
                : Container(),
          ],
        )),
        const AppFooter(),
      ],
    );
  }
}
