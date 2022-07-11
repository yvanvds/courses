class FB {
  static final collections = CollectionNames();
  static final documents = DocumentNames();
  static final course = CourseNames();
  static final period = PeriodNames();
  static final goal = GoalNames();
}

class CollectionNames {
  final String courses = 'courses';
  final String settings = 'settings';
}

class DocumentNames {
  final String goals = 'goals';
  final String periods = 'periods';
}

class CourseNames {
  final String name = 'name';
}

class PeriodNames {
  final String name = 'name';
  final String date = 'date';
}

class GoalNames {
  final String name = 'name';
  final String periodId = 'periodId';
  final String objectType = 'objectType';
  final String goal = 'goal';
  final String goals = 'goals';
  final String goalSection = 'goalSection';
}
