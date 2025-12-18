import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/models/files/storage_file.dart';
import 'package:courses/widgets/cards/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FileWidget extends StatelessWidget {
  final StorageFile file;
  final Function onSelect;
  final Function onDoubleTap;
  final bool selected;

  const FileWidget(
      {Key? key,
      required this.file,
      required this.onSelect,
      required this.selected,
      required this.onDoubleTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(),
      onDoubleTap: () => onDoubleTap(),
      child: GlassCard(
        highlight: selected,
        content: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.file,
              size: 48,
              color: AppTheme.colorLightest,
            ),
            Text(
              file.name,
              textAlign: TextAlign.center,
              style: AppTheme.text.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
