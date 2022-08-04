import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/models/topic.dart';
import 'package:flutter/material.dart';

class ContentCard extends StatefulWidget {
  final ContentLink content;
  final Function onEdit;
  final Function onDelete;

  const ContentCard(
      {Key? key,
      required this.content,
      required this.onEdit,
      required this.onDelete})
      : super(key: key);

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
      child: Card(
        color: AppTheme.colorDark,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  widget.content.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.text.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: AppTheme.colorAccent,
                ),
                onPressed: () async {
                  await widget.onEdit();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: AppTheme.colorWarning,
                ),
                onPressed: () async {
                  widget.onDelete();
                },
              ),
              const SizedBox(width: 50),
            ],
          ),
        ),
      ),
    );
  }
}
