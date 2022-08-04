import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/data/models/content/text_content.dart';
import 'package:courses/data/models/content/title_content.dart';
import 'package:courses/data/names.dart';
import 'package:flutter/material.dart';

enum ContentType {
  invalid,
  textContent,
  titleContent,
}

class ContentFactory {
  static IconData getIcon(ContentType type) {
    switch (type) {
      case ContentType.textContent:
        return Icons.abc;
      case ContentType.titleContent:
        return Icons.title;
      default:
        return Icons.square;
    }
  }

  static ContentType getType(String value) {
    ContentType result = ContentType.values.firstWhere(
        (element) => element.name == value,
        orElse: () => ContentType.invalid);
    return result;
  }

  static IContent? _parse(
      ContentType type, String id, Map<String, dynamic> data) {
    switch (type) {
      case ContentType.textContent:
        return TextContent.fromMap(id, data);
      case ContentType.titleContent:
        return TitleContent.fromMap(id, data);
      default:
        return null;
    }
  }

  static TextContent createTextcontent() => TextContent.fromMap('0', {});
  static TitleContent createTitlecontent() => TitleContent.fromMap('0', {});

  static List<IContent> fromFirebase(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    var list = snapshot.docs.map((doc) {
      String id = doc.id;
      Map<String, dynamic> data = doc.data();
      return fromMap(id, data);
    }).toList();
    return list.whereType<IContent>().toList();
  }

  static IContent? fromMap(String id, Map<String, dynamic> data) {
    String type = data.containsKey(FB.content.contentType)
        ? data[FB.content.contentType]
        : '';
    ContentType contentType = getType(type);
    return _parse(contentType, id, data);
  }
}

abstract class IContent {
  String get id;
  ContentType get contentType;
  String get name;

  IContent.fromMap(String id, Map<String, dynamic> map);
  Map<String, dynamic> toMap();
}
