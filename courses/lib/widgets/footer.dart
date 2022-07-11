import 'package:courses/convienience/app_theme.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppFooter extends StatelessWidget {
  final Function onSave;
  const AppFooter({Key? key, required this.onSave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorLightest.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppButton(
                color: AppTheme.colorLightest,
                text: 'Annuleren',
                icon: Icons.cancel,
                onPressed: () {
                  context.pop();
                }),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                text: 'Bewaren',
                icon: Icons.save,
                onPressed: () async {
                  onSave();
                  context.pop();
                },
              )),
        ],
      ),
    );
  }
}
