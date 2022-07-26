import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/widgets/app_dialog.dart';
import 'package:flutter/material.dart';

class ContentTypePickerDialog extends StatefulWidget {
  const ContentTypePickerDialog({Key? key}) : super(key: key);

  @override
  State<ContentTypePickerDialog> createState() =>
      _ContentTypePickerDialogState();
}

class _ContentTypePickerDialogState extends State<ContentTypePickerDialog> {
  ContentType? selected;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Nieuwe Inhoud',
      onConfirm: selected != null
          ? () {
              Navigator.pop(context, selected);
            }
          : null,
      content: SizedBox(
        width: 300,
        height: 500,
        child: ListView(
          //shrinkWrap: true,
          children: getTypes(),
        ),
      ),
    );
  }

  List<Widget> getTypes() {
    List<Widget> result = [];
    result.add(createButton(ContentType.textContent, 'Tekst'));
    return result;
  }

  Widget createButton(ContentType type, String name) {
    return RadioListTile(
      value: type,
      groupValue: selected,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              ContentFactory.getIcon(type),
              color: AppTheme.colorAccent,
              size: 28,
            ),
          ),
          Text(name),
        ],
      ),
      onChanged: (ContentType? value) {
        setState(() {
          selected = value;
        });
      },
    );
  }
}
