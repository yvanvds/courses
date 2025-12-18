import 'dart:io';
import 'dart:typed_data';

import 'package:courses/data/models/files/storage_file.dart';
import 'package:courses/data/models/files/storage_folder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FileService {
  StorageFolder getCourseRoot(String courseID) {
    return StorageFolder(reference: FirebaseStorage.instance.ref(courseID));
  }

  loadChildren(StorageFolder folder) async {
    folder.folders.clear();
    folder.files.clear();
    final result = await folder.reference.listAll();
    for (var ref in result.prefixes) {
      folder.folders.add(StorageFolder(reference: ref, parent: folder));
    }
    for (var ref in result.items) {
      if (ref.name != '.ghostfile') {
        var file = StorageFile(reference: ref);
        await getMetaData(file);
        await getDownloadUrl(file);
        folder.files.add(file);
      }
    }
  }

  getMetaData(StorageFile file) async {
    file.metadata = await file.reference.getMetadata();
  }

  getDownloadUrl(StorageFile file) async {
    file.url = await file.reference.getDownloadURL();
  }

  Future<StorageFolder> loadCourseRoot(String courseID) async {
    var folder = getCourseRoot(courseID);
    await loadChildren(folder);
    return folder;
  }

  createFolder(StorageFolder parent, String name) async {
    // firebase API cannot create empty folders, so we put a file in it
    Reference child = parent.reference.child('$name/.ghostfile');
    Uint8List data = Uint8List(0);
    await child.putData(data);
  }

  uploadFile(StorageFolder folder, File file) async {
    Reference ref = folder.reference.child(file.uri.pathSegments.last);
    await ref.putFile(file);
  }

  uploadData(StorageFolder folder, String name, Uint8List data) async {
    Reference ref = folder.reference.child(name);
    await ref.putData(data);
  }

  deleteFile(StorageFile file) async {
    await file.reference.delete();
  }

  deleteFolder(StorageFolder folder) async {
    await loadChildren(folder);
    for (var item in folder.folders) {
      await deleteFolder(item);
    }
    for (var file in folder.files) {
      await deleteFile(file);
    }
    Reference ghostfile = folder.reference.child('.ghostfile');
    try {
      await ghostfile.delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
