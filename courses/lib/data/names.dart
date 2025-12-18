class FB {
  static final collections = CollectionNames();
  static final documents = DocumentNames();
  static final course = CourseNames();
  static final period = PeriodNames();
  static final goal = GoalNames();
  static final topic = TopicNames();
  static final content = ContentNames();
  static final account = AccountNames();
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
  final String contents = 'contents';
  final String contentId = 'contentId';
  final String contentName = 'contentName';
}

class ContentNames {
  final String content = 'content';
  final String contentType = 'contentType';
  final String name = 'name';
}

class AccountNames {
  final String email = 'email';
  final String picture = 'photoURL';
  final String display = 'displayName';
  final String firstname = 'firstName';
  final String currentCourse = 'currentCourse';
  final String courses = 'courses';
}
