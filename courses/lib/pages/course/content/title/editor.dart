import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/models/content/title_content.dart';
import 'package:courses/data/models/topic.dart';
import 'package:courses/validators/validated_text_field.dart';
import 'package:courses/validators/validation_models.dart';
import 'package:courses/widgets/footer.dart';
import 'package:courses/widgets/loading.dart';
import 'package:courses/widgets/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitleEditor extends StatefulWidget {
  final String courseID;
  final String topicID;
  final TitleContent? content;

  const TitleEditor(
      {Key? key, required this.courseID, required this.topicID, this.content})
      : super(key: key);

  @override
  State<TitleEditor> createState() => _TitleEditorState();
}

class _TitleEditorState extends State<TitleEditor> {
  final formKey = GlobalKey<FormState>();
  final TitleValidator validator = TitleValidator();
  Topic? topic;

  @override
  void initState() {
    if (widget.content != null) {
      validator.validateTitle(widget.content!.title);
      validator.validateSubTitle(widget.content!.subtitle);
    }
    validator.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
        title: widget.content == null ? 'Nieuwe Titel' : 'Titel Aanpassen',
        providers: [
          StreamProvider<Topic?>(
            create: (_) =>
                Data.topics.getSingle(widget.courseID, widget.topicID),
            initialData: null,
          ),
        ],
        builder: (BuildContext context) {
          topic = Provider.of<Topic?>(context);
          if (topic == null) return const Loading();

          return Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      color: AppTheme.colorDarkest,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ValidatedTextField(
                              labelText: 'Titel',
                              autoFocus: true,
                              onChanged: validator.validateTitle,
                              model: validator.title,
                              maxLength: 12,
                              fontSize: 200,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ValidatedTextField(
                              labelText: 'Ondertitel',
                              autoFocus: true,
                              onChanged: validator.validateSubTitle,
                              model: validator.subtitle,
                              maxLength: 40,
                              fontSize: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppFooter(
                  onSave: validator.validate ? saveContent : null,
                ),
              ],
            ),
          );
        });
  }

  saveContent() async {
    if (widget.content == null) {
      TitleContent content = ContentFactory.createTitlecontent();
      content.title = validator.title.value!;
      content.subtitle = validator.subtitle.value!;
      String id = await Data.content.create(
          courseID: widget.courseID, topicID: widget.topicID, content: content);
      topic!.contents.add(ContentLink(id: id, name: content.name));
      await Data.topics.update(widget.courseID, topic!);
    } else {
      widget.content!.title = validator.title.value!;
      widget.content!.subtitle = validator.subtitle.value!;

      await Data.content.update(
          courseID: widget.courseID,
          topicID: widget.topicID,
          content: widget.content!);
      for (var element in topic!.contents) {
        if (element.id == widget.content!.id) {
          if (element.name != validator.title.value!) {
            element.name = validator.title.value!;
            await Data.topics.update(widget.courseID, topic!);
          }
        }
      }
    }
  }
}

class TitleValidator extends ChangeNotifier {
  StringValidationModel _title = StringValidationModel(null, null);
  StringValidationModel get title => _title;

  StringValidationModel _subtitle = StringValidationModel(null, null);
  StringValidationModel get subtitle => _subtitle;

  void clear() {
    _title = StringValidationModel(null, null);
    _subtitle = StringValidationModel(null, null);
  }

  void validateTitle(String? val) {
    val = val?.trim();
    if (val == null) {
      _title = StringValidationModel(null, 'verplicht');
    } else if (val.length < 3) {
      _title = StringValidationModel(null, 'minimum 3 characters');
    } else if (val.length > 12) {
      _title = StringValidationModel(null, 'maximum 12 characters');
    } else {
      _title = StringValidationModel(val, null);
    }
    notifyListeners();
  }

  void validateSubTitle(String? val) {
    val = val?.trim();
    if (val == null) {
      _subtitle = StringValidationModel(null, 'verplicht');
    } else if (val.length > 40) {
      _subtitle = StringValidationModel(null, 'maximum 40 characters');
    } else {
      _subtitle = StringValidationModel(val, null);
    }
    notifyListeners();
  }

  bool get validate {
    return _title.value != null && _subtitle.value != null;
  }
}
