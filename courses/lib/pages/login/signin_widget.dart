import 'package:courses/data/data.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: Data.useEmulator
              ? [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppButton(
                      icon: Icons.login,
                      text: 'Sign In',
                      onPressed: onEmulatorPressed,
                    ),
                  ),
                ]
              : [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppButton(
                      icon: Icons.login,
                      text: 'Log In',
                      onPressed: onMicrosoftPressed,
                    ),
                  ),
                ],
        ),
      ),
    );
  }

  void onMicrosoftPressed() async {
    Data.auth.signInWithMicrosoft();
  }

  void onEmulatorPressed() async {
    Data.auth.signInForTesting();
  }
}
