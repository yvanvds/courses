import 'package:courses/convienience/random_key.dart';
import 'package:courses/validators/validation_models.dart';
import 'package:flutter/material.dart';

class ValidatedDateField extends StatefulWidget {
  final DateValidationModel model;
  final DateTime? Function(DateTime?) onChanged;

  const ValidatedDateField(
      {Key? key, required this.model, required this.onChanged})
      : super(key: key);

  @override
  State<ValidatedDateField> createState() => _ValidatedDateFieldState();
}

class _ValidatedDateFieldState extends State<ValidatedDateField> {
  Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    if (widget.model.renewKey) {
      fieldKey = RandomValues.getKey();
      widget.model.renewKey = false;
    }

    DateTime? initialDate = widget.model.value;
    if (initialDate != null &&
        initialDate.millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch) {
      initialDate = null;
    }

    return InputDatePickerFormField(
        key: fieldKey ?? widget.key,
        initialDate: initialDate,
        onDateSubmitted: widget.onChanged,
        errorFormatText: 'geen geldige datum',
        errorInvalidText: widget.model.error,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 1000)));
  }
}
