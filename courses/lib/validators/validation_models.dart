class StringValidationModel {
  String? value;
  String? error;
  bool renewKey = false;
  StringValidationModel(this.value, this.error, [this.renewKey = false]);
}

class DateValidationModel {
  DateTime? value;
  String? error;
  bool renewKey = false;
  DateValidationModel(this.value, this.error, [this.renewKey = false]);
}

class IntValidationModel {
  int? value;
  String? error;
  bool renewKey = false;
  IntValidationModel(this.value, this.error, [this.renewKey = false]);
}
