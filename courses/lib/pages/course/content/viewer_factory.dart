import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/models/content/text_content.dart';
import 'package:courses/data/models/content/title_content.dart';
import 'package:courses/pages/course/content/rich_text/viewer.dart';
import 'package:courses/pages/course/content/title/viewer.dart';
import 'package:flutter/material.dart';

class ViewerFactory {
  static Widget? create(IContent content) {
    switch (content.contentType) {
      case ContentType.invalid:
        return null;
      case ContentType.textContent:
        return RichTextViewer(
          content: content as TextContent,
        );
      case ContentType.titleContent:
        return TitleViewer(content: content as TitleContent);
    }
  }
}
