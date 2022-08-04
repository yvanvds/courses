import 'package:courses/data/data.dart';
import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/models/content/text_content.dart';
import 'package:courses/data/models/content/title_content.dart';
import 'package:courses/page_not_found.dart';
import 'package:courses/pages/course/content/rich_text/editor.dart';
import 'package:courses/pages/course/content/title/editor.dart';
import 'package:courses/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditorFactory {
  static Widget? forNewContent(
      String courseID, String topicID, ContentType type) {
    switch (type) {
      case ContentType.invalid:
        return null;
      case ContentType.textContent:
        return RichTextEditor(courseID: courseID, topicID: topicID);
      case ContentType.titleContent:
        return TitleEditor(
          courseID: courseID,
          topicID: topicID,
        );
    }
  }

  static Widget? forExistingContent(
      String courseID, String topicID, String contentID) {
    return StreamProvider<IContent?>(
        create: (_) => Data.content.getSingle(courseID, topicID, contentID),
        initialData: null,
        builder: (context, widget) {
          IContent? content = Provider.of<IContent?>(context);
          if (content == null) return const Loading();

          switch (content.contentType) {
            case ContentType.invalid:
              return const PageNotFound(text: 'Invalid Content Type');
            case ContentType.textContent:
              return RichTextEditor(
                  courseID: courseID,
                  topicID: topicID,
                  content: content as TextContent);
            case ContentType.titleContent:
              return TitleEditor(
                  courseID: courseID,
                  topicID: topicID,
                  content: content as TitleContent);
          }
        });
  }
}
