import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/models/files/storage_folder.dart';
import 'package:courses/widgets/cards/glass_card.dart';
import 'package:flutter/material.dart';

class FolderWidget extends StatelessWidget {
  final StorageFolder folder;
  final Function onSelect;
  final Function onDoubleTap;
  final bool selected;
  final bool isParent;

  const FolderWidget(
      {Key? key,
      required this.folder,
      required this.selected,
      required this.isParent,
      required this.onSelect,
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
              isParent ? Icons.arrow_back : Icons.folder,
              size: 48,
              color: AppTheme.colorLightest,
            ),
            Text(
              isParent ? 'Terug' : folder.name,
              textAlign: TextAlign.center,
              style: AppTheme.text.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
