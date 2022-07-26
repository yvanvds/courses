import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/names.dart';

class ContentService {
  Stream<List<IContent>?> get(String courseID, String topicID) {
    return FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .doc(topicID)
        .collection(FB.collections.content)
        .snapshots()
        .map(ContentFactory.fromFirebase);
  }

  Future<void> create(
      {required String courseID,
      required String topicID,
      required IContent content}) async {
    await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .doc(topicID)
        .collection(FB.collections.content)
        .add(content.toMap());
  }

  Future<void> update(
      {required String courseID,
      required String topicID,
      required IContent content}) async {
    await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .doc(topicID)
        .collection(FB.collections.content)
        .doc(content.id)
        .update(content.toMap());
  }

  Future<void> delete(
      {required String courseID,
      required String topicID,
      required String contentID}) async {
    await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .doc(topicID)
        .collection(FB.collections.content)
        .doc(contentID)
        .delete();
  }
}
