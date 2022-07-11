import 'package:courses/page_not_found.dart';
import 'package:courses/pages/course/goals/course_goals_page.dart';
import 'package:courses/pages/course/course_page.dart';
import 'package:courses/pages/course/course_settings_page.dart';
import 'package:courses/pages/dashboard/dashboard.dart';
import 'package:go_router/go_router.dart';

class Nav {
  static Nav? _instance;

  static get() {
    return _instance ??= Nav();
  }

  final router = GoRouter(
    errorBuilder: (context, state) => PageNotFound(
      text: 'Cannot find uri: ${state.location}',
    ),
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const DashboardPage(),
          routes: [
            GoRoute(
              path: 'course/:id',
              builder: (context, state) =>
                  CoursePage(courseID: state.params['id']!),
              routes: [
                GoRoute(
                  path: 'settings',
                  builder: (context, state) =>
                      CourseSettingsPage(courseID: state.params['id']!),
                ),
                GoRoute(
                  path: 'goals',
                  builder: (context, state) =>
                      CourseGoalsPage(courseID: state.params['id']!),
                ),
              ],
            ),
          ]),
    ],
  );
}
