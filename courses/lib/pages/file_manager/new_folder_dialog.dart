import 'package:courses/pages/file_manager/new_folder_validator.dart';
import 'package:courses/validators/validated_text_field.dart';
import 'package:courses/widgets/app_dialog.dart';
import 'package:flutter/material.dart';

class NewFolderDialog extends StatefulWidget {
  final NewFolderValidator validator;
  const NewFolderDialog({Key? key, required this.validator}) : super(key: key);

  @override
  State<NewFolderDialog> createState() => _NewFolderDialogState();
}

class _NewFolderDialogState extends State<NewFolderDialog> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.validator.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Nieuwe Folder',
      content: Form(
        key: formKey,
        child: ValidatedTextField(
          labelText: 'Naam',
          autoFocus: true,
          onChanged: widget.validator.validateName,
          model: widget.validator.name,
        ),
      ),
      onConfirm: widget.validator.validate
          ? () {
              Navigator.pop(context, widget.validator.name.value);
            }
          : null,
    );
  }
}
