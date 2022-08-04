import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/models/course.dart';
import 'package:courses/data/data.dart';
import 'package:courses/pages/dashboard/courses_list.dart';
import 'package:courses/widgets/loading.dart';
import 'package:courses/widgets/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "Dashboard",
      providers: [
        StreamProvider<List<Course>?>.value(
            value: Data.courses.stream, initialData: null),
      ],
      builder: (BuildContext context) {
        List<Course>? courses = Provider.of<List<Course>?>(context);

        if (courses == null) return const Loading();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text('Welkom terug!', style: AppTheme.text.headline1),
            ),
            CoursesList(courses: courses),
          ],
        );
      },
    );
  }
}
