import 'package:courses/data/models/content/text_content.dart';
import 'package:courses/pages/course/content/rich_text/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class RichTextViewer extends StatelessWidget {
  final TextContent content;
  final QuillController controller;
  final FocusNode focusNode = FocusNode();

  RichTextViewer({Key? key, required this.content})
      : controller = QuillController(
          document: content.toEditor(),
          selection: const TextSelection.collapsed(offset: 0),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuillEditor(
      controller: controller,
      readOnly: true,
      focusNode: focusNode,
      scrollController: ScrollController(),
      scrollable: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      autoFocus: false,
      expands: false,
      customStyles: RichTextStyles.get(),
      locale: const Locale('nl'),
    );
  }
}
