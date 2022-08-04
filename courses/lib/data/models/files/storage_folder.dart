import 'package:courses/data/models/files/file_item.dart';
import 'package:courses/data/models/files/storage_file.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageFolder implements IFileItem {
  @override
  final FileItemType type = FileItemType.folder;

  @override
  final Reference reference;

  @override
  String get name => reference.name;

  final StorageFolder? parent;

  List<StorageFolder> folders = [];
  List<StorageFile> files = [];

  StorageFolder({required this.reference, this.parent});

  bool nameExists(String name) {
    for (var folder in folders) {
      if (folder.name == name) return true;
    }

    for (var file in files) {
      if (file.name == name) return true;
    }

    return false;
  }
}
