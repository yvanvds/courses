import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/course.dart';
import 'package:courses/widgets/buttons/big_button.dart';
import 'package:courses/widgets/loading.dart';
import 'package:courses/widgets/page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CoursePage extends StatefulWidget {
  final String courseID;
  const CoursePage({Key? key, required this.courseID}) : super(key: key);

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '',
      providers: [
        StreamProvider<Course?>(
            create: (_) => Data.courses.get(widget.courseID),
            initialData: null),
      ],
      builder: (BuildContext context) {
        Course? course = Provider.of<Course?>(context);

        if (course == null) return const Loading();

        return buildContent(context, course);
      },
    );
  }

  Widget buildContent(BuildContext context, Course course) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(course.name, style: AppTheme.text.headline1),
        ),
        GridView(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          children: [
            BigButton(
                label: 'Instellingen',
                icon: Icons.settings,
                onPressed: () {
                  context.go('/course/${course.id}/settings');
                }),
            BigButton(
                label: 'Doelen',
                icon: Icons.task,
                onPressed: () {
                  context.go('/course/${course.id}/goals');
                }),
          ],
        ),
      ],
    );
  }
}
