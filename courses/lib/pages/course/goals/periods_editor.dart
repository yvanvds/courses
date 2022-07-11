import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/models/periods.dart';
import 'package:courses/validators/validated_text_field.dart';
import 'package:courses/validators/validation_models.dart';
import 'package:courses/widgets/app_dialog.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeriodsEditor extends StatefulWidget {
  final Period? period;
  const PeriodsEditor({Key? key, this.period}) : super(key: key);

  @override
  State<PeriodsEditor> createState() => _PeriodsEditorState();
}

class _PeriodsEditorState extends State<PeriodsEditor> {
  final formKey = GlobalKey<FormState>();
  final PeriodEditorValidator validator = PeriodEditorValidator();

  @override
  void initState() {
    if (widget.period != null) {
      validator.validateName(widget.period!.name);
      validator.validateDate(widget.period!.date);
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
      title: widget.period == null ? 'Nieuwe Periode' : 'Bewerk Periode',
      onConfirm: validator.validate
          ? () {
              Period period = Period();
              period.name = validator.name.value!;
              period.date = validator.date.value!;
              Navigator.pop(context, period);
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Eindigt op:', style: AppTheme.text.bodyText2),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                icon: Icons.calendar_month,
                text: validator.date.value == null
                    ? 'Kies een datum'
                    : DateFormat.yMd().format(validator.date.value!),
                onPressed: () async {
                  DateTime date = DateTime.now();
                  if (validator.date.value != null &&
                      validator.date.value!.millisecondsSinceEpoch >
                          date.millisecondsSinceEpoch) {
                    date = validator.date.value!;
                  }
                  DateTime? result = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 1000)),
                  );
                  validator.validateDate(result);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PeriodEditorValidator extends ChangeNotifier {
  StringValidationModel _name = StringValidationModel(null, null);
  DateValidationModel _date = DateValidationModel(null, null);

  StringValidationModel get name => _name;
  DateValidationModel get date => _date;

  void clear() {
    _name = StringValidationModel(null, null, true);
    _date = DateValidationModel(null, null);
  }

  void validateName(String? val) {
    val = val?.trim();
    if (val == null) {
      _name = StringValidationModel(null, 'verplicht');
    } else if (val.length < 3) {
      _name = StringValidationModel(null, 'minimum 3 characters');
    } else if (val.length > 20) {
      _name = StringValidationModel(null, 'maximum 20 characters');
    } else {
      _name = StringValidationModel(val, null);
    }
    notifyListeners();
  }

  DateTime? validateDate(DateTime? val) {
    if (val == null) {
      _date = DateValidationModel(null, 'verplicht');
    } else if (val.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch) {
      _date = DateValidationModel(null, 'deze datum is voorbij');
    } else {
      _date = DateValidationModel(val, null);
    }
    notifyListeners();
    return _date.value;
  }

  bool get validate {
    return _name.value != null && _date.value != null;
  }
}
