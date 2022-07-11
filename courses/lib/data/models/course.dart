import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String _id;
  late String _name;

  String get id => _id;
  String get name => _name;

  Course.fromMap(this._id, Map<String, dynamic> map) {
    _name = map.containsKey('name') ? map['name'] : '';
  }

  static List<Course> fromFirebase(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((e) => Course.fromMap(e.id, e.data())).toList();
  }
}
