import 'package:courses/convienience/app_theme.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppFooter extends StatelessWidget {
  final Function? onSave;
  const AppFooter({Key? key, this.onSave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorLightest.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: onSave != null
                ? AppButton(
                    color: AppTheme.colorLightest,
                    text: 'Annuleren',
                    icon: Icons.cancel,
                    onPressed: () {
                      context.pop();
                    })
                : Container(),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: onSave != null
                  ? AppButton(
                      text: 'Bewaren',
                      icon: Icons.save,
                      onPressed: () async {
                        onSave!();
                        context.pop();
                      },
                    )
                  : AppButton(
                      icon: Icons.arrow_back,
                      text: 'Terug',
                      onPressed: () async {
                        context.pop();
                      })),
        ],
      ),
    );
  }
}

class NavigationFooter extends StatelessWidget {
  final int index;
  final int length;
  final Function(int) onIndexChange;

  const NavigationFooter(
      {Key? key,
      required this.index,
      required this.length,
      required this.onIndexChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorLightest.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: index == 0
                ? AppButton(
                    color: AppTheme.colorLightest,
                    text: 'Afsluiten',
                    icon: Icons.close,
                    onPressed: () {
                      onIndexChange(-1);
                    },
                  )
                : AppButton(
                    color: AppTheme.colorLightest,
                    text: 'Vorige',
                    icon: Icons.arrow_back,
                    onPressed: () {
                      onIndexChange(index - 1);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: index < length - 1
                ? AppButton(
                    text: 'Volgende',
                    icon: Icons.arrow_forward,
                    onPressed: () async {
                      onIndexChange(index + 1);
                    },
                  )
                : AppButton(
                    color: AppTheme.colorLightest,
                    text: 'Afsluiten',
                    icon: Icons.close,
                    onPressed: () {
                      onIndexChange(-1);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
