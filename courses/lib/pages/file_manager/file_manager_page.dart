import 'package:courses/data/data.dart';
import 'package:courses/data/models/files/storage_folder.dart';
import 'package:courses/pages/file_manager/file_manager_widget.dart';
import 'package:courses/widgets/footer.dart';
import 'package:courses/widgets/loading.dart';
import 'package:courses/widgets/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileManagerPage extends StatefulWidget {
  final String courseID;

  const FileManagerPage({Key? key, required this.courseID}) : super(key: key);

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
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

        return Column(
          children: [
            root == null
                ? const Loading()
                : Expanded(
                    child: FileManagerWidget(
                      root: root,
                      onFileSelect: (file) {},
                    ),
                  ),
            const AppFooter(),
          ],
        );
      },
    );
  }
}
