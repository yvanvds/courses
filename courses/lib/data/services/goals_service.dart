import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/models/goals.dart';
import 'package:courses/data/names.dart';

class GoalsService {
  Stream<Goals?> get(String courseID) {
    return FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.settings)
        .doc(FB.documents.goals)
        .snapshots()
        .map((event) {
      if (event.exists && event.data() != null) {
        return Goals.fromMap(event.data()!);
      }
      return null;
    });
  }

  Future<void> set(String courseID, Goals goals) async {
    await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.settings)
        .doc(FB.documents.goals)
        .set(goals.toMap());
  }
}
