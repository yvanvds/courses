import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/models/goals.dart';
import 'package:courses/data/models/periods.dart';
import 'package:flutter/material.dart';

class GoalCard extends StatefulWidget {
  final Goal goal;
  final Periods periods;

  final Function onEdit;
  final Function onRemove;

  const GoalCard({
    Key? key,
    required this.goal,
    required this.periods,
    required this.onEdit,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Text(
              widget.goal.name,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.text.bodyText1,
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
              // await openGoalEditor(widget.goals
              //     .goalSections[widget.sectionIndex].goals[widget.goalIndex]);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: AppTheme.colorWarning,
            ),
            onPressed: () async {
              await widget.onRemove();
            },
          ),
          const SizedBox(width: 50),
        ],
      )
    ]);
  }
}
