import 'package:courses/data/services/course_service.dart';
import 'package:courses/data/services/goals_service.dart';
import 'package:courses/data/services/periods_service.dart';
import 'package:get_it/get_it.dart';

class Data {
  static final GetIt _locator = GetIt.instance;

  static void init() {
    _locator.registerLazySingleton(() => CourseService());
    _locator.registerLazySingleton(() => PeriodsService());
    _locator.registerLazySingleton(() => GoalsService());
  }

  static CourseService get courses => _locator<CourseService>();
  static PeriodsService get periods => _locator<PeriodsService>();
  static GoalsService get goals => _locator<GoalsService>();
}
