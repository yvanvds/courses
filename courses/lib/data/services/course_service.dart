import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/models/course.dart';
import 'package:courses/data/names.dart';

class CourseService {
  Stream<List<Course>?> get stream {
    return FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .snapshots()
        .map(Course.fromFirebase);
  }

  Stream<Course?> get(String courseID) {
    return FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .snapshots()
        .map((event) {
      if (event.exists && event.data() != null) {
        return Course.fromMap(event.id, event.data()!);
      }
      return null;
    });
  }

  Future<void> create({required String name}) async {
    Map<String, dynamic> data = <String, dynamic>{};
    data[FB.course.name] = name;

    await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .add(data);
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(id)
        .update(data);
  }

  Future<void> delete(String id) async {
    await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(id)
        .delete();
  }
}
