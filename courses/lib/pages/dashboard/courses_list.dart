import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/models/course.dart';
import 'package:courses/data/data.dart';
import 'package:courses/pages/dashboard/new_course_dialog.dart';
import 'package:courses/pages/dashboard/new_course_validator.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:courses/widgets/cards/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CoursesList extends StatefulWidget {
  final List<Course> courses;
  const CoursesList({Key? key, required this.courses}) : super(key: key);

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Mijn Cursussen',
                style: AppTheme.text.headline3,
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: widget.courses.length + 1,
              itemBuilder: (BuildContext ctx, index) {
                // last item: add button to create course
                if (index == widget.courses.length) {
                  return GestureDetector(
                    onTap: () {
                      createCourse();
                    },
                    child: Card(
                      color: AppTheme.colorDarkest,
                      child: Icon(
                        Icons.add_circle_outline,
                        size: 64,
                        color: AppTheme.colorAccent,
                      ),
                    ),
                  );
                }
                return Card(
                  color: AppTheme.colorDarkest,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.courses[index].name,
                        style: AppTheme.text.titleSmall,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AppButton(
                            icon: Icons.folder_open,
                            text: 'Open',
                            onPressed: () {
                              context.go('/course/${widget.courses[index].id}');
                            },
                          ),
                        ),
                      ],
                    ),
                  ]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void createCourse() async {
    NewCourseValidator validator = NewCourseValidator();

    String? result = await showDialog(
      context: context,
      builder: (c) => NewCourseDialog(validator: validator),
    );
    if (result != null && result.isNotEmpty) {
      await Data.courses.create(name: result);
    }
  }
}
