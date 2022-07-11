import 'package:courses/convienience/random_key.dart';
import 'package:courses/data/names.dart';

class Goal {
  String id;
  late String name;
  late String periodId;

  Goal({this.id = '0'});

  Goal.fromMap(this.id, Map<String, dynamic> map) {
    name = map.containsKey(FB.goal.name) ? map[FB.goal.name] : '';
    periodId = map.containsKey(FB.goal.periodId) ? map[FB.goal.periodId] : '';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FB.goal.objectType: FB.goal.goal,
      FB.goal.name: name,
      FB.goal.periodId: periodId,
    };
  }
}

class GoalSection {
  String id;
  late String name;
  late String objectType;
  List<Goal> goals = [];

  GoalSection({this.id = '0'});

  GoalSection.fromMap(this.id, Map<String, dynamic> map) {
    map.forEach((key, value) {
      if (key == FB.goal.name) {
        name = value;
      } else if (key == FB.goal.objectType) {
        objectType = value;
      } else if (key == FB.goal.goals) {
        Map<String, dynamic> list = value;
        list.forEach((key, value) {
          goals.add(Goal.fromMap(key, value));
        });
      }
    });
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    result[FB.goal.name] = name;
    result[FB.goal.objectType] = FB.goal.goalSection;
    Map<String, Map<String, dynamic>> list = {};
    for (int i = 0; i < goals.length; i++) {
      if (goals[i].id == '0') {
        goals[i].id = RandomValues.getString(20);
      }
      list[goals[i].id] = goals[i].toMap();
      result[FB.goal.goals] = list;
    }
    return result;
  }
}

class Goals {
  List<GoalSection> goalSections = [];
  List<Goal> goals = []; // for goals not assigned to a section

  Goals();

  Goals.fromMap(Map<String, dynamic> map) {
    map.forEach((key, value) {
      Map<String, dynamic> objectMap = value;
      String objectType = objectMap.containsKey(FB.goal.objectType)
          ? objectMap[FB.goal.objectType]
          : '';
      if (objectType == FB.goal.goal) {
        goals.add(Goal.fromMap(key, objectMap));
      } else if (objectType == FB.goal.goalSection) {
        goalSections.add(GoalSection.fromMap(key, objectMap));
      }
    });
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    for (int i = 0; i < goalSections.length; i++) {
      if (goalSections[i].id == '0') {
        goalSections[i].id = RandomValues.getString(20);
      }
      result[goalSections[i].id] = goalSections[i].toMap();
    }
    for (int i = 0; i < goals.length; i++) {
      if (goals[i].id == '0') {
        goals[i].id = RandomValues.getString(20);
      }
      result[goals[i].id] = goals[i].toMap();
    }
    return result;
  }
}
