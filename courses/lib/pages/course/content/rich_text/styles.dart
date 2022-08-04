import 'package:courses/convienience/app_theme.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:tuple/tuple.dart';

class RichTextStyles {
  static get() {
    return DefaultStyles(
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
    );
  }
}
