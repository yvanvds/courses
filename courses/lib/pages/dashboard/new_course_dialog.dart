import 'package:courses/pages/dashboard/new_course_validator.dart';
import 'package:courses/validators/validated_text_field.dart';
import 'package:courses/widgets/app_dialog.dart';
import 'package:flutter/material.dart';

class NewCourseDialog extends StatefulWidget {
  final NewCourseValidator validator;
  const NewCourseDialog({Key? key, required this.validator}) : super(key: key);

  @override
  State<NewCourseDialog> createState() => _NewCourseDialogState();
}

class _NewCourseDialogState extends State<NewCourseDialog> {
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
      title: 'Nieuwe Cursus',
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
