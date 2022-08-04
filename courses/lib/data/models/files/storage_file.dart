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
}
