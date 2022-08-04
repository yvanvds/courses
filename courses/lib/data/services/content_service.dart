import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/names.dart';

class ContentService {
  Stream<List<IContent>?> getAll(String courseID, String topicID) {
    return FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .doc(topicID)
        .collection(FB.collections.content)
        .snapshots()
        .map(ContentFactory.fromFirebase);
  }

  Stream<IContent?> getSingle(
      String courseID, String topicID, String contentID) {
    return FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .doc(topicID)
        .collection(FB.collections.content)
        .doc(contentID)
        .snapshots()
        .map((event) {
      if (event.exists && event.data() != null) {
        return ContentFactory.fromMap(event.id, event.data()!);
      }
      return null;
    });
  }

  Future<String> create(
      {required String courseID,
      required String topicID,
      required IContent content}) async {
    var result = await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.topics)
        .doc(topicID)
        .collection(FB.collections.content)
        .add(content.toMap());
    return result.id;
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
