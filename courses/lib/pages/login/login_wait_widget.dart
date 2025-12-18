import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class LoginWaitWidget extends StatefulWidget {
  final String text;

  const LoginWaitWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<LoginWaitWidget> createState() => LoginWaitWidgetState();
}

class LoginWaitWidgetState extends State<LoginWaitWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colorDark),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.text,
            style: TextStyle(
              color: AppTheme.colorDarkest,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          width: 200,
          child: AppButton(
            icon: Icons.cancel,
            text: 'Cancel',
            onPressed: () {
              Data.auth.backToStart();
            },
          ),
        ),
      ],
    );
  }
}
