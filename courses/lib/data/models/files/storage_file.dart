import 'package:courses/data/data.dart';
import 'package:courses/data/models/files/file_item.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageFile implements IFileItem {
  @override
  final FileItemType type = FileItemType.file;

  @override
  final Reference reference;

  late FullMetadata metadata;
  late String url;

  @override
  String get name => reference.name;

  StorageFile({required this.reference});

  @override
  delete() async {
    await Data.files.deleteFile(this);
  }

  @override
  int get hashCode => reference.fullPath.hashCode;

  @override
  bool operator ==(Object other) {
    return other is StorageFile &&
        reference.fullPath == other.reference.fullPath;
  }
}
