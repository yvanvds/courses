import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/models/content/title_content.dart';
import 'package:flutter/material.dart';

class TitleViewer extends StatelessWidget {
  final TitleContent content;
  const TitleViewer({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(content.title,
              style: AppTheme.text.headline1!.copyWith(fontSize: 200)),
          Text(
            content.subtitle,
            style: AppTheme.text.headline1!.copyWith(fontSize: 100),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
