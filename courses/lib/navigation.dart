import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/page_not_found.dart';
import 'package:courses/pages/course/content/editor_factory.dart';
import 'package:courses/pages/course/topics/topics_page.dart';
import 'package:courses/pages/course/goals/course_goals_page.dart';
import 'package:courses/pages/course/course_page.dart';
import 'package:courses/pages/course/settings/course_settings_page.dart';
import 'package:courses/pages/course/viewer/viewer_page.dart';
import 'package:courses/pages/dashboard/dashboard.dart';
import 'package:courses/pages/file_manager/file_manager_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Nav {
  static Nav? _instance;

  static get() {
    return _instance ??= Nav();
  }

  final router = GoRouter(
    debugLogDiagnostics: true,
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
                  path: 'topics',
                  builder: (context, state) =>
                      CourseContentPage(courseID: state.params['id']!),
                  routes: [
                    GoRoute(
                      path: ':topicID',
                      builder: (content, state) =>
                          CoursePage(courseID: state.params['id']!),
                      routes: [
                        GoRoute(
                          path: 'create/:type',
                          builder: (context, state) {
                            Widget? result = EditorFactory.forNewContent(
                              state.params['id']!,
                              state.params['topicID']!,
                              ContentFactory.getType(state.params['type']!),
                            );
                            if (result != null) return result;
                            return PageNotFound(
                              text: 'Cannot find uri: ${state.location}',
                            );
                          },
                        ),
                        GoRoute(
                          path: 'edit/:contentID',
                          builder: (context, state) {
                            Widget? result = EditorFactory.forExistingContent(
                              state.params['id']!,
                              state.params['topicID']!,
                              state.params['contentID']!,
                            );
                            if (result != null) return result;
                            return PageNotFound(
                              text: 'Cannot find uri: ${state.location}',
                            );
                          },
                        ),
                        GoRoute(
                          path: 'view',
                          builder: (context, state) => ViewerPageLoader(
                            courseID: state.params['id']!,
                            topicID: state.params['topicID']!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: 'files',
                  builder: (context, state) =>
                      FileManagerPage(courseID: state.params['id']!),
                ),
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
