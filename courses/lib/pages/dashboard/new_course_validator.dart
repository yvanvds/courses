import 'package:courses/validators/validation_models.dart';
import 'package:flutter/material.dart';

class NewCourseValidator extends ChangeNotifier {
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
      _name = StringValidationModel(null, 'maximum 20 characters');
    } else {
      _name = StringValidationModel(val, null);
    }
    notifyListeners();
  }

  bool get validate {
    return _name.value != null;
  }
}
