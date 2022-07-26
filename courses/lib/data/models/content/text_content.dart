import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/names.dart';
import 'package:flutter_quill/flutter_quill.dart';

class TextContent implements IContent {
  @override
  final String id;
  @override
  final ContentType contentType;
  @override
  late String name;

  late List<dynamic> _content;
  void fromEditor(Document document) {
    _content = document.toDelta().toJson();
  }

  Document toEditor() {
    return Document.fromJson(_content);
  }

  TextContent.fromMap(this.id, Map<String, dynamic> map)
      : contentType = ContentType.textContent {
    _content =
        map.containsKey(FB.content.content) ? map[FB.content.content] : [];
    name = map.containsKey(FB.content.name) ? map[FB.content.name] : [];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    result[FB.content.content] = _content;
    result[FB.content.contentType] = contentType.toString();

    return result;
  }
}
