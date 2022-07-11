import 'package:courses/convienience/app_theme.dart';
import 'package:courses/convienience/random_key.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/goals.dart';
import 'package:courses/data/models/periods.dart';
import 'package:courses/pages/course/goals/goal_section_editor.dart';
import 'package:courses/pages/course/goals/goals_list.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:courses/widgets/cards/app_card.dart';
import 'package:flutter/material.dart';

class GoalsWidget extends StatefulWidget {
  final Goals? goals;
  final Periods periods;
  final String courseID;
  const GoalsWidget(
      {Key? key, required this.courseID, required this.periods, this.goals})
      : super(key: key);

  @override
  State<GoalsWidget> createState() => _GoalsWidgetState();
}

class _GoalsWidgetState extends State<GoalsWidget> {
  GlobalKey newButtonKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 400,
      maximize: true,
      title: Row(
        children: [
          Text('Doelen', style: AppTheme.text.subtitle1),
          const Spacer(),
          AppButton(
            key: newButtonKey,
            icon: Icons.add_circle,
            text: 'Nieuwe Sectie',
            onPressed: () {
              openSectionEditor();
            },
          ),
        ],
      ),
      content: widget.goals != null
          ? GoalsList(
              key: RandomValues.getKey(),
              goals: widget.goals!,
              periods: widget.periods,
              courseId: widget.courseID,
            )
          : Container(),
    );
  }

  Future<void> openSectionEditor() async {
    GoalSection? result = await showDialog(
      context: context,
      builder: (_) {
        return const GoalSectionEditor();
      },
    );
    if (result != null) {
      if (widget.goals != null) {
        widget.goals!.goalSections.add(result);
        await Data.goals.set(widget.courseID, widget.goals!);
      } else {
        Goals goals = Goals();
        goals.goalSections.add(result);
        await Data.goals.set(widget.courseID, goals);
      }
    }
  }

  Future<void> openGoalEditor() async {}
}
