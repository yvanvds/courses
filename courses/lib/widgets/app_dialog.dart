import 'package:courses/convienience/app_theme.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  final Widget content;
  final void Function()? onConfirm;

  const AppDialog(
      {Key? key,
      required this.title,
      required this.content,
      this.onConfirm,
      this.confirmText = 'OK'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 20,
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.colorDark,
                AppTheme.colorLight,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                  color: AppTheme.colorDarkest,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(title),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: content,
              ),
              Divider(color: AppTheme.colorLight),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: AppButton(
                        color: AppTheme.colorLightest,
                        text: 'Annuleer',
                        icon: Icons.cancel,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    AppButton(
                      text: confirmText,
                      icon: Icons.check,
                      onPressed: onConfirm,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
