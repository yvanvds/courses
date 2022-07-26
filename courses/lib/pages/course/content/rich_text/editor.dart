import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/models/content/text_content.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:courses/widgets/footer.dart';
import 'package:courses/widgets/header.dart';
import 'package:courses/widgets/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:tuple/tuple.dart';

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
  final QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: widget.content == null ? 'Nieuwe Inhoud' : 'Inhoud Aanpassen',
      builder: (BuildContext context) {
        return Column(
          children: [
            AppHeader(text: 'header'),
            Expanded(
                child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16),
              child: buildEditor(context),
            )),
            AppFooter(
              onSave: () {
                if (widget.content == null) {
                  TextContent content = ContentFactory.createTextcontent();
                  content.fromEditor(_controller.document);
                  Data.content.create(
                      courseID: widget.courseID,
                      topicID: widget.topicID,
                      content: content);
                } else {
                  widget.content!.fromEditor(_controller.document);
                  Data.content.update(
                      courseID: widget.courseID,
                      topicID: widget.topicID,
                      content: widget.content!);
                }
              },
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
              customStyles: DefaultStyles(
                h1: DefaultTextBlockStyle(
                  AppTheme.text.headline1!,
                  const Tuple2(16, 0),
                  const Tuple2(0, 0),
                  null,
                ),
                h2: DefaultTextBlockStyle(
                  AppTheme.text.headline2!,
                  const Tuple2(16, 0),
                  const Tuple2(0, 0),
                  null,
                ),
                h3: DefaultTextBlockStyle(
                  AppTheme.text.headline3!,
                  const Tuple2(16, 0),
                  const Tuple2(0, 0),
                  null,
                ),
                paragraph: DefaultTextBlockStyle(
                  AppTheme.text.bodyText1!,
                  const Tuple2(16, 0),
                  const Tuple2(0, 0),
                  null,
                ),
              ),
              locale: const Locale('nl'),
            ),
          ),
        ],
      ),
    );
  }
}
