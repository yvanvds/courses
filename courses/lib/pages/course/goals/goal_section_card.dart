import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/models/goals.dart';
import 'package:flutter/material.dart';

class GoalSectionCard extends StatefulWidget {
  final GoalSection section;
  final Function onEdit;
  final Function onDelete;
  final Function onCreateGoal;

  const GoalSectionCard({
    Key? key,
    required this.section,
    required this.onEdit,
    required this.onDelete,
    required this.onCreateGoal,
  }) : super(key: key);

  @override
  State<GoalSectionCard> createState() => _GoalSectionCardState();
}

class _GoalSectionCardState extends State<GoalSectionCard> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              widget.section.name,
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
              Icons.add_circle,
              color: AppTheme.colorLightest,
            ),
            onPressed: () async {
              await widget.onCreateGoal();
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
      )
    ]);
  }
}
