import 'dart:io';

import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/models/content/text_content.dart';
import 'package:courses/pages/course/content/rich_text/editor.dart';
import 'package:flutter/material.dart';

class EditorFactory {
  static Widget? forNewContent(
      String courseID, String topicID, ContentType type) {
    switch (type) {
      case ContentType.invalid:
        return null;
      case ContentType.textContent:
        return RichTextEditor(courseID: courseID, topicID: topicID);
      case ContentType.headerContent:
        return null;
    }
  }

  static Widget? forExistingContent(
      String courseID, String topicID, IContent content) {
    switch (content.contentType) {
      case ContentType.invalid:
        return null;
      case ContentType.textContent:
        return RichTextEditor(
            courseID: courseID,
            topicID: topicID,
            content: content as TextContent);
      case ContentType.headerContent:
        return null;
    }
  }
}
