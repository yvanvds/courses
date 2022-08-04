import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/names.dart';

class ContentLink {
  late String id;
  late String name;

  ContentLink({required this.id, required this.name});
  ContentLink.fromMap(Map<String, dynamic> map) {
    id = map.containsKey(FB.topic.contentId) ? map[FB.topic.contentId] : '';
    name =
        map.containsKey(FB.topic.contentName) ? map[FB.topic.contentName] : '';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    result[FB.topic.contentId] = id;
    result[FB.topic.contentName] = name;
    return result;
  }
}

class Topic {
  String id;
  late String name;
  List<String> goals = [];
  List<ContentLink> contents = [];

  Topic({this.id = '0'});

  Topic.fromMap(this.id, Map<String, dynamic> map) {
    name = map.containsKey(FB.topic.name) ? map[FB.topic.name] : '';
    if (map.containsKey(FB.topic.goals)) {
      var list = map[FB.topic.goals];
      for (String element in list) {
        goals.add(element);
      }
    }
    if (map.containsKey(FB.topic.contents)) {
      var list = map[FB.topic.contents];
      for (Map<String, dynamic> map in list) {
        contents.add(ContentLink.fromMap(map));
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    result[FB.topic.name] = name;
    result[FB.topic.goals] = goals;
    result[FB.topic.contents] = contentsToList();
    return result;
  }

  List<Map<String, dynamic>> contentsToList() {
    List<Map<String, dynamic>> result = [];
    for (var element in contents) {
      result.add(element.toMap());
    }
    return result;
  }

  static List<Topic> fromFirebase(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    var list = snapshot.docs.map((e) => Topic.fromMap(e.id, e.data())).toList();
    list.sort(((a, b) => a.name.compareTo(b.name)));
    return list;
  }
}
