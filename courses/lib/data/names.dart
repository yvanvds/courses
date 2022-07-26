class FB {
  static final collections = CollectionNames();
  static final documents = DocumentNames();
  static final course = CourseNames();
  static final period = PeriodNames();
  static final goal = GoalNames();
  static final topic = TopicNames();
  static final content = ContentNames();
}

class CollectionNames {
  final String courses = 'courses';
  final String settings = 'settings';
  final String topics = 'topics';
  final String content = 'content';
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
  final String goal = 'goal';
  final String goals = 'goals';
  final String order = 'order';
}

class TopicNames {
  final String name = 'name';
  final String goals = 'goals';
  final String content = 'content';
}

class ContentNames {
  final String content = 'content';
  final String contentType = 'contentType';
  final String name = 'name';
}
