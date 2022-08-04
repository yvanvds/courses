import 'package:courses/data/data.dart';
import 'package:courses/data/models/course.dart';
import 'package:courses/widgets/footer.dart';
import 'package:courses/widgets/header.dart';
import 'package:courses/widgets/loading.dart';
import 'package:courses/widgets/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseSettingsPage extends StatefulWidget {
  final String courseID;
  const CourseSettingsPage({Key? key, required this.courseID})
      : super(key: key);

  @override
  State<CourseSettingsPage> createState() => _CourseSettingsPageState();
}

class _CourseSettingsPageState extends State<CourseSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Instellingen',
      providers: [
        StreamProvider<Course?>(
            create: (_) => Data.courses.get(widget.courseID),
            initialData: null),
      ],
      builder: (BuildContext context) {
        Course? course = Provider.of<Course?>(context);

        if (course == null) return const Loading();

        return buildContent(course);
      },
    );
  }

  Widget buildContent(Course course) {
    return Column(
      children: [
        AppHeader(text: course.name),
        const Spacer(),
        const AppFooter(),
      ],
    );
  }
}
