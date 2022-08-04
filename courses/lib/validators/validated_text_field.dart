import 'package:courses/convienience/app_theme.dart';
import 'package:courses/convienience/random_key.dart';
import 'package:courses/validators/validation_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ValidatedTextField extends StatefulWidget {
  const ValidatedTextField({
    Key? key,
    required this.labelText,
    required this.model,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.maxLines,
    this.maxLength,
    this.autoFocus,
    this.fontSize = 24,
  }) : super(key: key);

  final String labelText;
  final List<TextInputFormatter>? inputFormatters;
  final StringValidationModel model;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;
  final bool? autoFocus;
  final double fontSize;

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    if (widget.model.renewKey) {
      fieldKey = RandomValues.getKey();
      widget.model.renewKey = false;
    }

    return TextFormField(
      key: fieldKey ?? widget.key,
      initialValue: widget.model.value,
      onChanged: widget.onChanged,
      validator: widget.validator,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      style: AppTheme.text.bodyText1!.copyWith(
        fontSize: widget.fontSize,
      ),
      inputFormatters: widget.inputFormatters,
      autofocus: widget.autoFocus ?? false,
      cursorColor: AppTheme.colorLightest,
      decoration: InputDecoration(
          labelText: widget.labelText,
          errorText: widget.model.error,
          counterStyle: AppTheme.text.bodyText2),
    );
  }
}
