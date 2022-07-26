import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/names.dart';

class Topic {
  String id;
  late String name;
  List<String> goals = [];
  List<String> content = [];

  Topic({this.id = '0'});

  Topic.fromMap(this.id, Map<String, dynamic> map) {
    name = map.containsKey(FB.topic.name) ? map[FB.topic.name] : '';
    if (map.containsKey(FB.topic.goals)) {
      var list = map[FB.topic.goals];
      for (String element in list) {
        goals.add(element);
      }
    }
    if (map.containsKey(FB.topic.content)) {
      var list = map[FB.topic.content];
      for (String element in list) {
        content.add(element);
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    result[FB.topic.name] = name;
    result[FB.topic.goals] = goals;
    result[FB.topic.content] = content;

    return result;
  }

  static List<Topic> fromFirebase(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    var list = snapshot.docs.map((e) => Topic.fromMap(e.id, e.data())).toList();
    list.sort(((a, b) => a.name.compareTo(b.name)));
    return list;
  }
}
