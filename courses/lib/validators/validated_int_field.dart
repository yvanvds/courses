import 'package:courses/validators/validation_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ValidatedIntField extends StatelessWidget {
  const ValidatedIntField({
    Key? key,
    required this.labelText,
    required this.model,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.maxLines,
    this.maxLength,
  }) : super(key: key);

  final String labelText;
  final List<TextInputFormatter>? inputFormatters;
  final IntValidationModel model;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: model.value.toString(),
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(labelText: labelText, errorText: model.error),
    );
  }
}
