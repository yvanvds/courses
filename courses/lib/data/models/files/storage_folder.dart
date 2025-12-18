import 'dart:io';
import 'dart:typed_data';

import 'package:courses/data/data.dart';
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

  addFolder(String name) async {
    await Data.files.createFolder(this, name);
  }

  addFile(File file) async {
    await Data.files.uploadFile(this, file);
  }

  addFileFromData(String name, Uint8List data) async {
    await Data.files.uploadData(this, name, data);
  }

  reload() async {
    await Data.files.loadChildren(this);
  }

  @override
  delete() async {
    await Data.files.deleteFolder(this);
  }

  @override
  int get hashCode => reference.fullPath.hashCode;

  @override
  bool operator ==(Object other) {
    return other is StorageFolder &&
        reference.fullPath == other.reference.fullPath;
  }
}
