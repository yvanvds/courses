import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/names.dart';

class TitleContent implements IContent {
  @override
  final String id;
  @override
  final ContentType contentType;
  @override
  String get name => title;

  late String title;
  late String subtitle;

  TitleContent.fromMap(this.id, Map<String, dynamic> map)
      : contentType = ContentType.titleContent {
    title = map.containsKey(FB.content.name) ? map[FB.content.name] : '';
    subtitle = map.containsKey('subtitle') ? map['subtitle'] : '';
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    result[FB.content.name] = name;
    result[FB.content.contentType] = contentType.name;
    result['subtitle'] = subtitle;

    return result;
  }
}
