import 'dart:io';

import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/files/file_item.dart';
import 'package:courses/data/models/files/storage_file.dart';
import 'package:courses/data/models/files/storage_folder.dart';
import 'package:courses/pages/file_manager/file_widget.dart';
import 'package:courses/pages/file_manager/folder_widget.dart';
import 'package:courses/pages/file_manager/new_folder_dialog.dart';
import 'package:courses/pages/file_manager/new_folder_validator.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:courses/widgets/cards/glass_card.dart';
import 'package:courses/widgets/header.dart';
import 'package:courses/widgets/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FileManagerWidget extends StatefulWidget {
  final StorageFolder root;
  final Function(StorageFile) onFileSelect;
  const FileManagerWidget(
      {Key? key, required this.root, required this.onFileSelect})
      : super(key: key);

  @override
  State<FileManagerWidget> createState() => _FileManagerWidgetState();
}

class _FileManagerWidgetState extends State<FileManagerWidget> {
  IFileItem? selectedItem;
  late StorageFolder currentFolder;
  List<IFileItem> items = [];
  bool working = false;

  @override
  void initState() {
    currentFolder = widget.root;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (working) return const Loading();

    items.clear();
    if (currentFolder.parent != null) {
      items.add(currentFolder.parent!);
    }
    items.addAll(currentFolder.folders);
    items.addAll(currentFolder.files);

    return Column(
      children: [
        buildToolbar(),
        Expanded(child: buildGrid()),
      ],
    );
  }

  Widget buildToolbar() {
    return AppHeader.custom(
        widget: Row(
      children: [
        AppButton(
          icon: FontAwesomeIcons.folderPlus,
          onPressed: () async {
            await createFolder();
          },
        ),
        AppButton(
          icon: FontAwesomeIcons.fileArrowUp,
          onPressed: () async {
            await uploadFile();
          },
        ),
        selectedItem != null && selectedItem! != currentFolder.parent
            ? AppButton(
                icon: FontAwesomeIcons.trashCan,
                color: AppTheme.colorWarning,
                onPressed: () async {
                  setState(() => working = true);
                  await selectedItem?.delete();

                  selectedItem = null;
                  await currentFolder.reload();
                  setState(() => working = false);
                },
              )
            : Container(),
      ],
    ));
  }

  GridView buildGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, index) {
        var element = items[index];
        if (element.type == FileItemType.file) {
          return FileWidget(
            file: element as StorageFile,
            selected: element == selectedItem,
            onSelect: () {
              selectedItem = element;
              setState(() {});
            },
            onDoubleTap: () {
              widget.onFileSelect(element);
            },
          );
        } else {
          return FolderWidget(
            folder: element as StorageFolder,
            selected: element == selectedItem,
            isParent: element == currentFolder.parent,
            onSelect: () {
              selectedItem = element;
              setState(() {});
            },
            onDoubleTap: () async {
              if (currentFolder.parent == element) {
                currentFolder = currentFolder.parent!;
              } else {
                currentFolder = element;
              }
              setState(() => working = true);
              await currentFolder.reload();
              setState(() => working = false);
            },
          );
        }
      },
    );
  }

  Widget createFileWidget(StorageFile file) {
    return const GlassCard(content: Icon(Icons.file_download));
  }

  createFolder() async {
    NewFolderValidator validator = NewFolderValidator(parent: currentFolder);

    String? result = await showDialog(
      context: context,
      builder: (c) => NewFolderDialog(validator: validator),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => working = true);
      await currentFolder.addFolder(result);
      await currentFolder.reload();
      setState(() => working = false);
    }
  }

  uploadFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(dialogTitle: 'Kies een bestand', allowCompression: false);

    if (result != null && result.files.isNotEmpty) {
      if (kIsWeb) {
        final bytes = result.files.first.bytes;
        final name = result.files.first.name;
        if (bytes == null) {
          Fluttertoast.showToast(msg: 'No Valid File');
          return;
        }
        setState(() => working = true);
        await currentFolder.addFileFromData(name, bytes);
        await currentFolder.reload();
        setState(() => working = false);
      } else {
        File file = File(result.files.first.path!);
        if (file.existsSync()) {
          setState(() => working = true);
          await currentFolder.addFile(file);
          await currentFolder.reload();
          setState(() => working = false);
        }
      }
    }
  }
}
