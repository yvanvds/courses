import 'package:courses/convienience/random_key.dart';
import 'package:courses/data/names.dart';

class Goal {
  String id;
  late String name;
  late String periodId;
  int order = 0;

  Goal({this.id = '0'});

  Goal.fromMap(this.id, Map<String, dynamic> map) {
    name = map.containsKey(FB.goal.name) ? map[FB.goal.name] : '';
    periodId = map.containsKey(FB.goal.periodId) ? map[FB.goal.periodId] : '';
    order = map.containsKey(FB.goal.order) ? map[FB.goal.order] : 0;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FB.goal.name: name,
      FB.goal.periodId: periodId,
      FB.goal.order: order,
    };
  }
}

class GoalSection {
  String id;
  late String name;
  int order = 0;
  List<Goal> goals = [];

  GoalSection({this.id = '0'});

  GoalSection.fromMap(this.id, Map<String, dynamic> map) {
    name = map.containsKey(FB.goal.name) ? map[FB.goal.name] : '';
    order = map.containsKey(FB.goal.order) ? map[FB.goal.order] : 0;
    if (map.containsKey(FB.goal.goals)) {
      Map<String, dynamic> goalMap = map[FB.goal.goals];
      goalMap.forEach((key, value) {
        goals.add(Goal.fromMap(key, value));
      });
    }
    goals.sort((a, b) => a.order.compareTo(b.order));
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    result[FB.goal.name] = name;
    result[FB.goal.order] = order;
    Map<String, Map<String, dynamic>> map = {};
    for (int i = 0; i < goals.length; i++) {
      if (goals[i].id == '0') {
        goals[i].id = RandomValues.getString(20);
      }
      map[goals[i].id] = goals[i].toMap();

      result[FB.goal.goals] = map;
    }
    return result;
  }

  Goal? getGoal(String id) {
    for (var goal in goals) {
      if (goal.id == id) return goal;
    }
    return null;
  }
}

class Goals {
  List<GoalSection> goalSections = [];
  Goals();

  Goals.fromMap(Map<String, dynamic> map) {
    map.forEach((key, value) {
      goalSections.add(GoalSection.fromMap(key, value));
    });
    goalSections.sort((a, b) => a.order.compareTo(b.order));
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    for (int i = 0; i < goalSections.length; i++) {
      if (goalSections[i].id == '0') {
        goalSections[i].id = RandomValues.getString(20);
      }
      result[goalSections[i].id] = goalSections[i].toMap();
    }
    return result;
  }

  Goal? getGoal(String id) {
    for (var section in goalSections) {
      Goal? result = section.getGoal(id);
      if (result != null) return result;
    }
    return null;
  }
}
