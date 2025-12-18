import 'dart:io';

import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/models/content/text_content.dart';
import 'package:courses/data/models/files/storage_folder.dart';
import 'package:courses/data/models/topic.dart';
import 'package:courses/pages/course/content/rich_text/styles.dart';
import 'package:courses/pages/file_manager/file_manager_dialog.dart';
import 'package:courses/validators/validated_text_field.dart';
import 'package:courses/validators/validation_models.dart';
import 'package:courses/widgets/footer.dart';
import 'package:courses/widgets/header.dart';
import 'package:courses/widgets/loading.dart';
import 'package:courses/widgets/page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class RichTextEditor extends StatefulWidget {
  final String courseID;
  final String topicID;
  final TextContent? content;
  const RichTextEditor(
      {Key? key, required this.courseID, required this.topicID, this.content})
      : super(key: key);

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final RichTextValidator validator = RichTextValidator();
  Topic? topic;

  @override
  void initState() {
    if (widget.content != null) {
      validator.validateName(widget.content!.name);
      _controller = QuillController(
        document: widget.content!.toEditor(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    validator.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: widget.content == null ? 'Nieuwe Inhoud' : 'Inhoud Aanpassen',
      providers: [
        StreamProvider<Topic?>(
          create: (_) => Data.topics.getSingle(widget.courseID, widget.topicID),
          initialData: null,
        ),
      ],
      builder: (BuildContext context) {
        topic = Provider.of<Topic?>(context);
        if (topic == null) return const Loading();

        return Column(
          children: [
            Form(
              key: formKey,
              child: AppHeader.custom(
                widget: SizedBox(
                  width: 300,
                  height: 90,
                  child: ValidatedTextField(
                    labelText: 'Naam',
                    autoFocus: true,
                    onChanged: validator.validateName,
                    model: validator.name,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16),
              child: buildEditor(context),
            )),
            AppFooter(
              onSave: validator.validate && _controller.document.length > 0
                  ? saveContent
                  : null,
            ),
          ],
        );
      },
    );
  }

  Widget buildEditor(BuildContext context) {
    return Container(
      color: AppTheme.colorDarkest,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                    color: AppTheme.colorDark,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: QuillToolbar.basic(
                        controller: _controller,
                        toolbarIconAlignment: WrapAlignment.start,
                        showBackgroundColorButton: false,
                        showFontSize: false,
                        onImagePickCallback: _onImagePickCallback,
                        webImagePickImpl: openFilePicker,
                        iconTheme: QuillIconTheme(
                          iconSelectedColor: AppTheme.colorWarning,
                          iconUnselectedColor: AppTheme.colorLightest,
                          iconSelectedFillColor: AppTheme.colorDarkest,
                          iconUnselectedFillColor: AppTheme.colorDark,
                          disabledIconColor: Colors.grey,
                          disabledIconFillColor: AppTheme.colorDark,
                        ),
                        locale: const Locale('nl'),
                      ),
                    )),
              ),
            ],
          ),
          Expanded(
            child: QuillEditor(
              controller: _controller,
              scrollController: ScrollController(),
              scrollable: true,
              focusNode: _focusNode,
              readOnly: false, // true for view only mode
              padding: const EdgeInsets.symmetric(horizontal: 16),
              autoFocus: false,
              expands: false,
              customStyles: RichTextStyles.get(),
              locale: const Locale('nl'),
            ),
          ),
        ],
      ),
    );
  }

  saveContent() async {
    if (widget.content == null) {
      TextContent content = ContentFactory.createTextcontent();
      content.fromEditor(_controller.document);
      content.name = validator.name.value!;
      String id = await Data.content.create(
          courseID: widget.courseID, topicID: widget.topicID, content: content);
      topic!.contents.add(ContentLink(id: id, name: content.name));
      await Data.topics.update(widget.courseID, topic!);
    } else {
      widget.content!.fromEditor(_controller.document);
      widget.content!.name = validator.name.value!;
      await Data.content.update(
          courseID: widget.courseID,
          topicID: widget.topicID,
          content: widget.content!);
      for (var element in topic!.contents) {
        if (element.id == widget.content!.id) {
          if (element.name != validator.name.value!) {
            element.name = validator.name.value!;
            await Data.topics.update(widget.courseID, topic!);
          }
        }
      }
    }
  }

  Future<String?> openFilePicker(
      OnImagePickCallback onImagePickCallback) async {
    StorageFolder root = await Data.files.loadCourseRoot(widget.courseID);

    String? result = await showDialog(
      context: context,
      builder: (c) => FileManagerDialog(root: root),
    );
    return result;
  }

  Future<String?> _onImagePickCallback(File file) async {
    return "";
  }
}

class RichTextValidator extends ChangeNotifier {
  StringValidationModel _name = StringValidationModel(null, null);

  StringValidationModel get name => _name;

  void clear() {
    _name = StringValidationModel(null, null);
  }

  void validateName(String? val) {
    val = val?.trim();
    if (val == null) {
      _name = StringValidationModel(null, 'verplicht');
    } else if (val.length < 3) {
      _name = StringValidationModel(null, 'minimum 3 characters');
    } else if (val.length > 20) {
      _name = StringValidationModel(null, 'maximum 20 characters');
    } else {
      _name = StringValidationModel(val, null);
    }
    notifyListeners();
  }

  bool get validate {
    return _name.value != null;
  }
}
