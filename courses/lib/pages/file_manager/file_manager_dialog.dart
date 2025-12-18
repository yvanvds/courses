import 'package:courses/data/models/files/storage_file.dart';
import 'package:courses/data/models/files/storage_folder.dart';
import 'package:courses/pages/file_manager/file_manager_widget.dart';
import 'package:courses/widgets/app_dialog.dart';
import 'package:flutter/material.dart';

class FileManagerDialog extends StatefulWidget {
  final StorageFolder root;
  const FileManagerDialog({Key? key, required this.root}) : super(key: key);

  @override
  State<FileManagerDialog> createState() => _FileManagerDialogState();
}

class _FileManagerDialogState extends State<FileManagerDialog> {
  StorageFile? file;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Kies een bestand',
      content: SizedBox(
        height: 600,
        width: 1000,
        child: FileManagerWidget(
          onFileSelect: (StorageFile file) {
            this.file = file;
          },
          root: widget.root,
        ),
      ),
      onConfirm: file != null
          ? () {
              Navigator.pop(context, file!.url);
            }
          : null,
    );
  }
}
