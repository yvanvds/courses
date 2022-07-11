import 'package:courses/convienience/random_key.dart';
import 'package:courses/validators/validation_models.dart';
import 'package:flutter/material.dart';

class ValidatedDropdownField extends StatefulWidget {
  final StringValidationModel model;
  final Function(String?)? onChanged;
  final Map<String, String> items;

  const ValidatedDropdownField(
      {Key? key,
      required this.model,
      required this.onChanged,
      required this.items})
      : super(key: key);

  @override
  State<ValidatedDropdownField> createState() => _ValidatedDropdownFieldState();
}

class _ValidatedDropdownFieldState extends State<ValidatedDropdownField> {
  Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    if (widget.model.renewKey) {
      fieldKey = RandomValues.getKey();
      widget.model.renewKey = false;
    }

    List<DropdownMenuItem<String>> items = [];
    widget.items.forEach((key, value) {
      items.add(DropdownMenuItem<String>(
        value: key,
        child: Text(value),
      ));
    });

    return DropdownButtonFormField(
      key: fieldKey ?? widget.key,
      items: items,
      onChanged: widget.onChanged,
    );
  }
}
