import 'package:courses/convienience/app_theme.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Color? color;
  final Color? background;
  final String? text;
  final IconData icon;
  final int height;
  final void Function()? onPressed;

  const AppButton({
    Key? key,
    this.color,
    this.background,
    this.text,
    required this.icon,
    this.height = 28,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: background != null
          ? ElevatedButton.styleFrom(primary: background)
          : ElevatedButton.styleFrom(),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: color ?? AppTheme.colorAccent,
              size: height.toDouble(),
            ),
          ),
          text != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: Text(
                    text!,
                    style: AppTheme.text.subtitle2,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
