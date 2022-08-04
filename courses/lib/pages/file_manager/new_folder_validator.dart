import 'package:courses/data/models/files/storage_folder.dart';
import 'package:courses/validators/validation_models.dart';
import 'package:flutter/cupertino.dart';

class NewFolderValidator extends ChangeNotifier {
  final StorageFolder parent;

  NewFolderValidator({required this.parent});

  StringValidationModel _name = StringValidationModel(null, null);
  StringValidationModel get name => _name;

  void clear() {
    _name = StringValidationModel(null, null);
  }

  void validateName(String? val) {
    val = val?.trim();
    if (val == null) {
      _name = StringValidationModel(null, 'verplicht veld');
    } else if (val.isEmpty) {
      _name = StringValidationModel(null, 'minimum 1 character');
    } else if (val.length > 20) {
      _name = StringValidationModel(null, 'maximum 20 characters');
    } else if (parent.nameExists(val)) {
      _name = StringValidationModel(null, 'This name is in use');
    } else {
      _name = StringValidationModel(val, null);
    }
    notifyListeners();
  }

  bool get validate {
    return _name.value != null;
  }
}
