import 'package:courses/data/models/topic.dart';
import 'package:courses/validators/validated_text_field.dart';
import 'package:courses/validators/validation_models.dart';
import 'package:courses/widgets/app_dialog.dart';
import 'package:flutter/material.dart';

class TopicEditor extends StatefulWidget {
  final Topic? topic;
  const TopicEditor({Key? key, this.topic}) : super(key: key);

  @override
  State<TopicEditor> createState() => _TopicEditorState();
}

class _TopicEditorState extends State<TopicEditor> {
  final formKey = GlobalKey<FormState>();
  final TopicEditorValidator validator = TopicEditorValidator();

  @override
  void initState() {
    if (widget.topic != null) {
      validator.validateName(widget.topic!.name);
    }
    validator.addListener(listenToValidator);

    super.initState();
  }

  @override
  void dispose() {
    validator.removeListener(listenToValidator);
    super.dispose();
  }

  void listenToValidator() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: widget.topic == null ? 'Nieuw Onderwerp' : 'Bewerk Onderwerp',
      onConfirm: validator.validate
          ? () {
              Topic topic = widget.topic != null ? widget.topic! : Topic();
              topic.name = validator.name.value!;
              Navigator.pop(context, topic);
            }
          : null,
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValidatedTextField(
                labelText: 'Naam',
                model: validator.name,
                onChanged: validator.validateName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopicEditorValidator extends ChangeNotifier {
  StringValidationModel _name = StringValidationModel(null, null);

  StringValidationModel get name => _name;

  void clear() {
    _name = StringValidationModel(null, null, true);
  }

  void validateName(String? val) {
    val = val?.trim();
    if (val == null) {
      _name = StringValidationModel(null, 'verplicht');
    } else if (val.length < 3) {
      _name = StringValidationModel(null, 'minimum 3 characters');
    } else if (val.length > 20) {
      _name = StringValidationModel(null, 'maximum 20 characters');
    } else {
      _name = StringValidationModel(val, null);
    }
    notifyListeners();
  }

  bool get validate {
    return _name.value != null;
  }
}
