import 'dart:async';
import 'dart:convert';

import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum AuthStatus {
  init,
  waitingForInput,
  signinWithMicrosoft,
  signinForTesting,

  authorized,
  loadAccount,
  goToDestination,
  done,
}

class AuthService {
  StreamController<AuthStatus> status = StreamController.broadcast();
  AuthStatus currentStatus = AuthStatus.init;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String?
      _firstName; // temporary storage to pass firstname from credentials to account

  AuthService() {
    status.stream.listen(evaluateStatus);
    _setStatus(AuthStatus.init);

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _user = null;
        _setStatus(AuthStatus.waitingForInput);
      } else {
        _user = user;
        _setStatus(AuthStatus.authorized);
      }
    });
  }

  void dispose() {
    status.close();
  }

  void _setStatus(AuthStatus status) {
    currentStatus = status;
    this.status.add(status);
  }

  Future<void> evaluateStatus(AuthStatus status) async {
    if (kDebugMode) {
      print('\x1B[31m[auth status] $status\x1B[0m');
    }
    switch (status) {
      case AuthStatus.init:
        return;

      case AuthStatus.signinWithMicrosoft:
        _signInWithMicrosoft();
        return;

      case AuthStatus.signinForTesting:
        _signInForTesting();
        return;

      case AuthStatus.authorized:
        _setStatus(AuthStatus.loadAccount);
        return;

      case AuthStatus.loadAccount:
        if (_user == null) {
          // i don't think this can happen at this point
          _setStatus(AuthStatus.waitingForInput);
        } else {
          await Data.account.setup(_user!, _firstName);
          _setStatus(AuthStatus.goToDestination);
        }
        return;

      case AuthStatus.goToDestination:
        _setStatus(AuthStatus.done);
        return;

      default:
        return;
    }
  }

  void signInWithMicrosoft() {
    _setStatus(AuthStatus.signinWithMicrosoft);
  }

  void signInForTesting() {
    _setStatus(AuthStatus.signinForTesting);
  }

  Future<void> _signInWithMicrosoft() async {
    try {
      OAuthProvider provider = OAuthProvider("microsoft.com");
      provider.setCustomParameters(
          {"tenant": "8ee90830-e251-45a0-bf95-abdf72738b07"});
      var credential = await _auth.signInWithPopup(provider);
      print(credential);
      _user = credential.user;
      _firstName = credential.additionalUserInfo?.profile?['givenName'];
    } catch (e) {
      Fluttertoast.showToast(msg: 'Login Failed: $e');
      _user = null;
      _setStatus(AuthStatus.waitingForInput);
    }

    if (_user != null) {
      _setStatus(AuthStatus.authorized);
    }
  }

  Future<void> _signInForTesting() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'yvan@mail.com',
        password: '',
      );

      _user = credential.user!;
      _setStatus(AuthStatus.authorized);
    } catch (error) {
      Fluttertoast.showToast(
        backgroundColor: AppTheme.colorWarning,
        textColor: AppTheme.colorLightest,
        msg: const HtmlEscape().convert(error.toString()),
        toastLength: Toast.LENGTH_LONG,
      );
      if (kDebugMode) {
        print(const HtmlEscape().convert(error.toString()));
      }
      _user = null;
      _setStatus(AuthStatus.waitingForInput);
    }
  }

  void backToStart() {
    _setStatus(AuthStatus.waitingForInput);
  }

  Future signOut() async {
    try {
      await _signOutProviders(FirebaseAuth.instance.currentUser?.providerData);
      await _auth.signOut();
      Data.account.clear();
      _setStatus(AuthStatus.waitingForInput);
    } catch (e) {
      Fluttertoast.showToast(
        backgroundColor: AppTheme.colorWarning,
        textColor: AppTheme.colorLightest,
        msg: 'Sign Out Failed: $e',
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
  }

  Future<dynamic> _signOutProviders(List<UserInfo>? providers) async {
    if (providers == null) {
      return;
    }
    return Future.forEach(providers, (UserInfo p) async {
      switch (p.providerId) {
        case 'apple.com':
          break;
      }
    });
  }
}
