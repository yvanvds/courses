import 'dart:io';

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
import 'package:courses/widgets/footer.dart';
import 'package:courses/widgets/header.dart';
import 'package:courses/widgets/loading.dart';
import 'package:courses/widgets/page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FileManagerPage extends StatefulWidget {
  final String courseID;

  const FileManagerPage({Key? key, required this.courseID}) : super(key: key);

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  StorageFolder? selectedFolder;
  StorageFolder? currentFolder;
  List<IFileItem> items = [];

  @override
  Widget build(BuildContext context) {
    return AppPage(
        title: 'Bestanden',
        providers: [
          // the initial data is provided with getCourseRoot. This returns an empty storage folder which will be
          // replaced later with the one provided by loadCourseRoot
          FutureProvider(
              create: (context) => Data.files.loadCourseRoot(widget.courseID),
              initialData: null),
        ],
        builder: (BuildContext context) {
          StorageFolder? root = Provider.of<StorageFolder?>(context);

          items.clear();
          if (root != null && currentFolder == null) {
            currentFolder = root;
          }

          if (currentFolder != null) {
            if (currentFolder!.parent != null) {
              items.add(currentFolder!.parent!);
            }
            items.addAll(currentFolder!.folders);
            items.addAll(currentFolder!.files);
          }

          return Column(
            children: [
              currentFolder != null ? buildToolbar(context) : Container(),
              Expanded(
                  child: currentFolder == null
                      ? const Loading()
                      : buildGrid(items)),
              const AppFooter(),
            ],
          );
        });
  }

  Widget buildToolbar(BuildContext context) {
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
      ],
    ));
  }

  GridView buildGrid(List<IFileItem> items) {
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
            onSelect: () {},
          );
        } else {
          return FolderWidget(
            folder: element as StorageFolder,
            selected: element.reference.fullPath ==
                selectedFolder?.reference.fullPath,
            isParent: element.reference.fullPath ==
                currentFolder?.parent?.reference.fullPath,
            onSelect: () {
              selectedFolder = element;
              setState(() {});
            },
            onDoubleTap: () async {
              if (currentFolder!.parent?.reference.fullPath ==
                  element.reference.fullPath) {
                currentFolder = currentFolder!.parent!;
              } else {
                currentFolder = element;
              }
              await Data.files.loadChildren(currentFolder!);
              setState(() {});
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
    NewFolderValidator validator = NewFolderValidator(parent: currentFolder!);

    String? result = await showDialog(
      context: context,
      builder: (c) => NewFolderDialog(validator: validator),
    );

    if (result != null && result.isNotEmpty) {
      await Data.files.createFolder(currentFolder!, result);
      await Data.files.loadChildren(currentFolder!);
      setState(() {});
    }
  }

  uploadFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(dialogTitle: 'Kies een bestand', allowCompression: false);

    if (result != null && result.files.first.path != null) {
      File file = File(result.files.first.path!);
      if (file.existsSync()) {
        await Data.files.uploadFile(currentFolder!, file);
        await Data.files.loadChildren(currentFolder!);
        setState(() {});
      }
    }
  }
}
