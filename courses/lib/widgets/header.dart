import 'package:courses/convienience/app_theme.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String text;
  final Widget? widget;
  const AppHeader({Key? key, required this.text})
      : widget = null,
        super(key: key);

  const AppHeader.custom({Key? key, required this.widget})
      : text = '',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: AppTheme.colorDark,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              widget == null
                  ? Text(text, style: AppTheme.text.headline2)
                  : widget!,
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
