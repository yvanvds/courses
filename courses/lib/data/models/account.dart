import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/names.dart';
import 'package:flutter/foundation.dart';

class Account {
  final String id;
  late String _email;
  String get email => _email;

  late String _photoURL;
  String get photoURL => _photoURL;
  late String _displayName;
  String get displayName => _displayName;
  late String _firstName;
  String get firstName => _firstName;
  late String _currentProject;
  String get currentProject => _currentProject;

  late List<String> _courses;
  List<String> get courses => _courses;

  Account.fromMap({required this.id, Map<String, dynamic>? map}) {
    if (map == null) return;
    _email = map.containsKey(FB.account.email) && map[FB.account.email] != null
        ? map[FB.account.email]
        : '';
    _photoURL =
        map.containsKey(FB.account.picture) && map[FB.account.picture] != null
            ? map[FB.account.picture]
            : '';
    _displayName =
        map.containsKey(FB.account.display) && map[FB.account.display] != null
            ? map[FB.account.display]
            : 'no name set';
    _firstName = map.containsKey(FB.account.firstname) &&
            map[FB.account.firstname] != null
        ? map[FB.account.firstname]
        : 'xxx';
    _currentProject = map.containsKey(FB.account.currentCourse)
        ? map[FB.account.currentCourse]
        : '';
    _courses =
        map.containsKey(FB.account.courses) && map[FB.account.courses] != null
            ? map[FB.account.courses].cast<String>()
            : <String>[];
  }

  static Account fromFirebase(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (kDebugMode) {
      print('id: ${snapshot.id}');
      print('data: ${snapshot.data.toString()}');
    }

    return Account.fromMap(id: snapshot.id, map: snapshot.data());
  }

  static Future<bool?> update(
      String accountID, Map<String, dynamic> updates) async {
    if (kDebugMode) {
      print(' *** account updates *** ');
      print(updates);
    }

    if (updates.isEmpty) return false;

    return FirebaseFirestore.instance
        .runTransaction((Transaction tx) async {
          final DocumentSnapshot ds = await tx.get(
              FirebaseFirestore.instance.collection('accounts').doc(accountID));
          tx.update(ds.reference, updates);
          return {'updated': true};
        })
        .then((result) => result['updated'])
        .catchError((error) {
          if (kDebugMode) {
            print('account update error: $error');
            print(updates);
          }

          return false;
        });
  }
}
