import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/names.dart';
import 'package:courses/data/models/periods.dart';

class PeriodsService {
  Stream<Periods?> get(String courseID) {
    return FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.settings)
        .doc(FB.documents.periods)
        .snapshots()
        .map((event) {
      if (event.exists && event.data() != null) {
        return Periods.fromMap(event.data()!);
      }
      return null;
    });
  }

  Future<void> set(String courseID, Periods periods) async {
    await FirebaseFirestore.instance
        .collection(FB.collections.courses)
        .doc(courseID)
        .collection(FB.collections.settings)
        .doc(FB.documents.periods)
        .set(periods.toMap());
  }
}
