import 'package:courses/data/models/goals.dart';
import 'package:courses/validators/validated_text_field.dart';
import 'package:courses/validators/validation_models.dart';
import 'package:courses/widgets/app_dialog.dart';
import 'package:flutter/material.dart';

class GoalSectionEditor extends StatefulWidget {
  final GoalSection? goalSection;
  const GoalSectionEditor({Key? key, this.goalSection}) : super(key: key);

  @override
  State<GoalSectionEditor> createState() => _GoalSectionEditorState();
}

class _GoalSectionEditorState extends State<GoalSectionEditor> {
  final formKey = GlobalKey<FormState>();
  final GoalSectionEditorValidator validator = GoalSectionEditorValidator();

  @override
  void initState() {
    if (widget.goalSection != null) {
      validator.validateName(widget.goalSection!.name);
    }
    validator.addListener(listenToValidator);

    super.initState();
  }

  @override
  void dispose() {
    validator.removeListener(listenToValidator);
    super.dispose();
  }

  void listenToValidator() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: widget.goalSection == null ? 'Nieuwe Sectie' : 'Bewerk Sectie',
      onConfirm: validator.validate
          ? () {
              GoalSection section = GoalSection();
              section.name = validator.name.value!;
              Navigator.pop(context, section);
            }
          : null,
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValidatedTextField(
                labelText: 'Naam',
                model: validator.name,
                onChanged: validator.validateName,
                maxLength: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalSectionEditorValidator extends ChangeNotifier {
  StringValidationModel _name = StringValidationModel(null, null);

  StringValidationModel get name => _name;

  void clear() {
    _name = StringValidationModel(null, null);
  }

  void validateName(String? val) {
    val = val?.trim();
    if (val == null) {
      _name = StringValidationModel(null, 'verplicht');
    } else if (val.length < 3) {
      _name = StringValidationModel(null, 'minimum 3 characters');
    } else if (val.length > 20) {
      _name = StringValidationModel(null, 'maximum 30 characters');
    } else {
      _name = StringValidationModel(val, null);
    }
    notifyListeners();
  }

  bool get validate {
    return _name.value != null;
  }
}
