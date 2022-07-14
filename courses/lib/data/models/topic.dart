import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/names.dart';

class Topic {
  String id;
  late String name;
  List<String> goals = [];

  Topic({this.id = '0'});

  Topic.fromMap(this.id, Map<String, dynamic> map) {
    name = map.containsKey(FB.topic.name) ? map[FB.topic.name] : '';
    if (map.containsKey(FB.topic.goals)) {
      var list = map[FB.topic.goals];
      for (String element in list) {
        goals.add(element);
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    result[FB.topic.name] = name;
    result[FB.topic.goals] = goals;

    return result;
  }

  static List<Topic> fromFirebase(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    var list = snapshot.docs.map((e) => Topic.fromMap(e.id, e.data())).toList();
    list.sort(((a, b) => a.name.compareTo(b.name)));
    return list;
  }
}
