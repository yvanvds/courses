import 'package:courses/data/services/account_service.dart';
import 'package:courses/data/services/auth_service.dart';
import 'package:courses/data/services/content_service.dart';
import 'package:courses/data/services/course_service.dart';
import 'package:courses/data/services/course_topic_service.dart';
import 'package:courses/data/services/file_service.dart';
import 'package:courses/data/services/goals_service.dart';
import 'package:courses/data/services/periods_service.dart';
import 'package:get_it/get_it.dart';

class Data {
  static final GetIt _locator = GetIt.instance;

  static bool useEmulator = false;

  static void init() {
    _locator.registerLazySingleton(() => CourseService());
    _locator.registerLazySingleton(() => AccountService());
    _locator.registerLazySingleton(() => AuthService());
    _locator.registerLazySingleton(() => PeriodsService());
    _locator.registerLazySingleton(() => GoalsService());
    _locator.registerLazySingleton(() => TopicService());
    _locator.registerLazySingleton(() => ContentService());
    _locator.registerLazySingleton(() => FileService());
  }

  static AuthService get auth => _locator<AuthService>();
  static AccountService get account => _locator<AccountService>();
  static CourseService get courses => _locator<CourseService>();
  static PeriodsService get periods => _locator<PeriodsService>();
  static GoalsService get goals => _locator<GoalsService>();
  static TopicService get topics => _locator<TopicService>();
  static ContentService get content => _locator<ContentService>();
  static FileService get files => _locator<FileService>();
}
