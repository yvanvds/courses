import 'package:courses/convienience/app_theme.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String text;
  const AppHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: AppTheme.colorDarkest,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(text, style: AppTheme.text.headline2),
            ],
          ),
        ),
      ),
    );
  }
}
