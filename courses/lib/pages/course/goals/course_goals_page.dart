import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/course.dart';
import 'package:courses/data/models/goals.dart';
import 'package:courses/data/models/periods.dart';
import 'package:courses/pages/course/goals/goals_widget.dart';
import 'package:courses/pages/course/goals/periods_editor.dart';
import 'package:courses/pages/course/goals/periods_widget.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:courses/widgets/cards/app_card.dart';
import 'package:courses/widgets/footer.dart';
import 'package:courses/widgets/loading.dart';
import 'package:courses/widgets/page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CourseGoalsPage extends StatefulWidget {
  final String courseID;
  const CourseGoalsPage({Key? key, required this.courseID}) : super(key: key);

  @override
  State<CourseGoalsPage> createState() => _CourseGoalsPageState();
}

class _CourseGoalsPageState extends State<CourseGoalsPage> {
  Periods? _periods;
  Goals? _goals;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Doelen',
      providers: [
        StreamProvider<Course?>(
            create: (_) => Data.courses.get(widget.courseID),
            initialData: null),
        StreamProvider<Periods?>(
            create: (_) => Data.periods.get(widget.courseID),
            initialData: null),
        StreamProvider<Goals?>(
            create: (_) => Data.goals.get(widget.courseID), initialData: null),
      ],
      builder: (BuildContext context) {
        Course? course = Provider.of<Course?>(context);
        _periods = Provider.of<Periods?>(context);
        _goals = Provider.of<Goals?>(context);

        if (course == null) return const Loading();

        return buildContent(course);
      },
    );
  }

  Widget buildContent(Course course) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${course.name} doelen', style: AppTheme.text.headline1),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PeriodsWidget(
                courseID: widget.courseID,
                periods: _periods,
              ),
              _periods != null
                  ? GoalsWidget(
                      courseID: widget.courseID,
                      periods: _periods!,
                      goals: _goals,
                    )
                  : Container(),
            ],
          ),
        ),
        AppFooter(
          onSave: () {},
        ),
      ],
    );
  }
}
