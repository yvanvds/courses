import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/goals.dart';
import 'package:courses/data/models/topic.dart';
import 'package:flutter/material.dart';

class TopicGoalsTab extends StatefulWidget {
  final String courseID;
  final Topic topic;
  final Goals goals;

  const TopicGoalsTab(
      {Key? key,
      required this.courseID,
      required this.topic,
      required this.goals})
      : super(key: key);

  @override
  State<TopicGoalsTab> createState() => _TopicGoalsTabState();
}

class _TopicGoalsTabState extends State<TopicGoalsTab> {
  int expandedSection = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  expandedSection = isExpanded ? -1 : panelIndex;
                });
              },
              children: createGoalSections(),
            ),
          ),
        ),
      ],
    );
  }

  List<ExpansionPanel> createGoalSections() {
    List<ExpansionPanel> list = [];
    for (int i = 0; i < widget.goals.goalSections.length; i++) {
      list.add(goalSectionPanel(widget.goals.goalSections[i], i));
    }
    return list;
  }

  ExpansionPanel goalSectionPanel(GoalSection section, int index) {
    int usedGoals = 0;
    for (var goal in section.goals) {
      if (widget.topic.goals.contains(goal.id)) {
        usedGoals++;
      }
    }
    return ExpansionPanel(
      backgroundColor: AppTheme.colorDark,
      isExpanded: index == expandedSection,
      headerBuilder: ((context, isExpanded) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${section.name} ($usedGoals/${section.goals.length})',
            style: AppTheme.text.subtitle2,
          ),
        );
      }),
      body: Card(
        color: AppTheme.colorDarkest,
        child: Column(
          children: getGoals(section),
        ),
      ),
    );
  }

  List<Widget> getGoals(GoalSection section) {
    List<Widget> result = [];
    for (var goal in section.goals) {
      result.add(
        Row(
          children: [
            Checkbox(
              value: widget.topic.goals.contains(goal.id),
              onChanged: (value) {
                if (value == false) {
                  widget.topic.goals.remove(goal.id);
                } else if (!widget.topic.goals.contains(goal.id)) {
                  widget.topic.goals.add(goal.id);
                }
                Data.topics.update(widget.courseID, widget.topic);
              },
            ),
            Text(goal.name),
          ],
        ),
      );
    }
    return result;
  }
}
