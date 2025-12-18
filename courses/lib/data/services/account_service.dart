import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/models/account.dart';
import 'package:courses/data/names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AccountService {
  User? user;
  String? firstName;
  Account? _account;
  Account? _oldAccount;
  bool lock = false;

  Account? get account {
    if (lock) {
      return _oldAccount;
    } else {
      return _account;
    }
  }

  set account(Account? value) {
    _oldAccount = _account;
    lock = true;
    _account = value;
    lock = false;
  }

  StreamSubscription? subscription;

  Future<void> setup(User user, String? firstName) async {
    this.user = user;
    this.firstName = firstName;

    account = await getInitialAccount(user);
    if (account != null) {
      await updateAccount();
    } else {
      await createAccount();
      account = await getInitialAccount(user);
    }

    subscription = FirebaseFirestore.instance
        .collection('accounts')
        .doc(user.uid)
        .snapshots()
        .map(Account.fromFirebase)
        .listen((onData) {
      account = onData;
    });
  }

  Future<Account?> getInitialAccount(User user) async {
    DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
        .instance
        .collection('accounts')
        .doc(user.uid)
        .get();
    if (snap.exists) {
      return Account.fromMap(id: snap.id, map: snap.data());
    } else {
      return null;
    }
  }

  void clear() {
    if (subscription != null) subscription?.cancel();
    account = null;
  }

  Future<void> updateAccount() async {
    Map<String, dynamic> updates = {};

    if (account?.displayName != user!.displayName && user!.displayName != '') {
      updates[FB.account.display] = user!.displayName;
    }
    if (account?.email != user!.email) {
      updates[FB.account.email] = user!.email;
    }
    if (account?.photoURL != user!.photoURL && user!.photoURL != '') {
      updates[FB.account.picture] = user!.photoURL;
    }

    if (account?.firstName != firstName && firstName != null) {
      updates[FB.account.firstname] = firstName;
    }

    await Account.update(account!.id, updates);
    if (kDebugMode) {
      print('Account updated');
    }
  }

  Future<void> createAccount() async {
    if (user != null) {
      FirebaseFirestore.instance.runTransaction((Transaction tx) async {
        final DocumentSnapshot ds = await tx.get(
            FirebaseFirestore.instance.collection('accounts').doc(user?.uid));

        var dataMap = <String, dynamic>{};
        dataMap[FB.account.email] = user?.email;
        dataMap[FB.account.display] = user?.displayName;
        dataMap[FB.account.picture] = user?.photoURL;
        dataMap[FB.account.firstname] = firstName;

        tx.set(ds.reference, dataMap);
        return dataMap;
      }).then((mapData) {
        account = Account.fromMap(id: user!.uid, map: mapData);
        if (kDebugMode) {
          print('Account created');
        }
        return;
      }).catchError((error) {
        if (kDebugMode) {
          print('error: $error');
        }
      });
    }
  }
}
