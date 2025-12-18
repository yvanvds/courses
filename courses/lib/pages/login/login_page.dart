import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/services/auth_service.dart';
import 'package:courses/pages/login/login_wait_widget.dart';
import 'package:courses/pages/login/signin_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String message = '';
  bool firstRender = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: header(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder(
              stream: Data.auth.status.stream,
              initialData: Data.auth.currentStatus,
              builder: (context, snapshot) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: getLoginWidget(context, snapshot),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    final offsetAnimation = Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: const Offset(0.0, 0.0))
                        .animate(animation);
                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset('images/logo.png', height: 80),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Courses',
                  style: TextStyle(
                    color: AppTheme.colorDarkest,
                    fontSize: 30,
                  ),
                  //style: TextStyle(fontFamily: 'Dosis', fontSize: 40, color: Color(0x0075B4))
                ),
              ),
            ),
            Center(
              child: Text(
                'Login',
                style: TextStyle(
                  color: AppTheme.colorDarkest,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getLoginWidget(context, snapshot) {
    // AuthStatus might be set to waitingforinput before
    // we started listening.
    if (firstRender) {
      firstRender = false;
      return const SignInWidget();
    }

    switch (snapshot.data as AuthStatus) {
      case AuthStatus.waitingForInput:
        return const SignInWidget();

      case AuthStatus.signinWithMicrosoft:
        return const LoginWaitWidget(text: 'waiting for microsoft ...');

      case AuthStatus.init:
      case AuthStatus.authorized:
        return const LoginWaitWidget(text: 'loading ...');

      case AuthStatus.loadAccount:
        return const LoginWaitWidget(text: 'loading account ...');

      case AuthStatus.goToDestination:
        return const LoginWaitWidget(text: 'loading course ...');

      case AuthStatus.done:
        return const LoginWaitWidget(text: 'Done loading. Displaying App...');

      default:
        return const LoginWaitWidget(text: 'not implemented');
    }
  }
}
