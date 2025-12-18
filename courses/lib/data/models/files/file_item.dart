import 'package:firebase_storage/firebase_storage.dart';

enum FileItemType {
  file,
  folder,
}

abstract class IFileItem {
  FileItemType get type;
  Reference get reference;
  String get name;

  delete();

  @override
  int get hashCode;

  @override
  bool operator ==(Object other);
}
