import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/models/topic.dart';
import 'package:courses/data/names.dart';

class TopicService {
  Stream<List<Topic>?> getAll(String courseID) {
    return FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .snapshots()
        .map(Topic.fromFirebase);
  }

  Stream<Topic?> getSingle(String courseID, String topicID) {
    return FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .doc(topicID)
        .snapshots()
        .map((event) {
      if (event.exists && event.data() != null) {
        return Topic.fromMap(event.id, event.data()!);
      }
      return null;
    });
  }

  Future<void> create({required String courseID, required String name}) async {
    Map<String, dynamic> data = <String, dynamic>{};
    data[FB.topic.name] = name;

    await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .add(data);
  }

  Future<void> update(String courseID, Topic topic) async {
    await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .doc(topic.id)
        .update(topic.toMap());
  }

  Future<void> delete(String courseID, String topicID) async {
    await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .doc(topicID)
        .delete();
  }
}
