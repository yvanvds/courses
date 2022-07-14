import 'package:courses/data/models/goals.dart';
import 'package:courses/data/models/periods.dart';
import 'package:courses/validators/validated_dropdown_field.dart';
import 'package:courses/validators/validated_text_field.dart';
import 'package:courses/validators/validation_models.dart';
import 'package:courses/widgets/app_dialog.dart';
import 'package:flutter/material.dart';

class GoalEditor extends StatefulWidget {
  final Goal? goal;
  final Periods periods;
  const GoalEditor({Key? key, this.goal, required this.periods})
      : super(key: key);

  @override
  State<GoalEditor> createState() => _GoalEditorState();
}

class _GoalEditorState extends State<GoalEditor> {
  final formKey = GlobalKey<FormState>();
  final GoalEditorValidator validator = GoalEditorValidator();

  @override
  void initState() {
    if (widget.goal != null) {
      validator.validateName(widget.goal!.name);
      validator.validatePeriodId(widget.goal!.periodId);
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
    Map<String, String> periods = {};
    for (var element in widget.periods.periods) {
      periods[element.id] = element.name;
    }

    return AppDialog(
      title: widget.goal == null ? 'Nieuw Doel' : 'Bewerk Doel',
      onConfirm: validator.validate
          ? () {
              Goal goal = Goal();
              goal.name = validator.name.value!;
              goal.periodId = validator.periodId.value!;
              Navigator.pop(context, goal);
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValidatedDropdownField(
                model: validator.periodId,
                onChanged: validator.validatePeriodId,
                items: periods,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalEditorValidator extends ChangeNotifier {
  StringValidationModel _name = StringValidationModel(null, null);
  StringValidationModel _periodId = StringValidationModel(null, null);

  StringValidationModel get name => _name;
  StringValidationModel get periodId => _periodId;

  void clear() {
    _name = StringValidationModel(null, null);
    _periodId = StringValidationModel(null, null);
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

  void validatePeriodId(String? val) {
    if (val == null) {
      _periodId = StringValidationModel(null, 'Kies een periode');
    } else {
      _periodId = StringValidationModel(val, null);
    }
    notifyListeners();
  }

  bool get validate {
    return _name.value != null && _periodId.value != null;
  }
}
