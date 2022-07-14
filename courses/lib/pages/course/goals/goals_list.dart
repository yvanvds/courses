import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/goals.dart';
import 'package:courses/data/models/periods.dart';
import 'package:courses/pages/course/goals/goal_card.dart';
import 'package:courses/pages/course/goals/goal_editor.dart';
import 'package:courses/pages/course/goals/goal_section_card.dart';
import 'package:courses/pages/course/goals/goal_section_editor.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

class GoalsList extends StatefulWidget {
  final Goals goals;
  final Periods periods;
  final String courseId;
  const GoalsList(
      {Key? key,
      required this.goals,
      required this.periods,
      required this.courseId})
      : super(key: key);

  @override
  State<GoalsList> createState() => _GoalsListState();
}

class _GoalsListState extends State<GoalsList> {
  final List<DragAndDropList> _contents = [];

  @override
  void initState() {
    for (int i = 0; i < widget.goals.goalSections.length; i++) {
      GoalSection currentSection = widget.goals.goalSections[i];
      _contents.add(
        DragAndDropList(
          header: GoalSectionCard(
            section: currentSection,
            onEdit: () async {
              GoalSection? result = await showDialog(
                context: context,
                builder: (_) {
                  return GoalSectionEditor(goalSection: currentSection);
                },
              );
              if (result != null) {
                result.order = currentSection.order;
                widget.goals.goalSections[i] = result;
                await Data.goals.set(widget.courseId, widget.goals);
              }
            },
            onDelete: () async {
              widget.goals.goalSections.removeAt(i);
              await Data.goals.set(widget.courseId, widget.goals);
            },
            onCreateGoal: () async {
              Goal? result = await showDialog(
                context: context,
                builder: (_) {
                  return GoalEditor(periods: widget.periods);
                },
              );
              if (result != null) {
                result.order = widget.goals.goalSections[i].goals.length;
                widget.goals.goalSections[i].goals.add(result);
                await Data.goals.set(widget.courseId, widget.goals);
              }
            },
          ),
          children: List.generate(
            widget.goals.goalSections[i].goals.length,
            (index) {
              Goal currentGoal = widget.goals.goalSections[i].goals[index];
              return DragAndDropItem(
                child: GoalCard(
                  goal: currentGoal,
                  periods: widget.periods,
                  onRemove: () async {
                    widget.goals.goalSections[i].goals.removeAt(index);
                    await Data.goals.set(widget.courseId, widget.goals);
                  },
                  onEdit: () async {
                    Goal? result = await showDialog(
                      context: context,
                      builder: (_) {
                        return GoalEditor(
                          goal: currentGoal,
                          periods: widget.periods,
                        );
                      },
                    );
                    if (result != null) {
                      result.order = currentGoal.order;
                      widget.goals.goalSections[i].goals[index] = result;
                      await Data.goals.set(widget.courseId, widget.goals);
                    }
                  },
                ),
              );
            },
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DragAndDropLists(
      children: _contents,
      onItemReorder: _onItemReorder,
      onListReorder: _onListReorder,
      listDragHandle: DragHandle(
        verticalAlignment: DragHandleVerticalAlignment.top,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, right: 10),
          child: Icon(
            Icons.menu,
            color: AppTheme.colorDarkest,
          ),
        ),
      ),
      itemDragHandle: DragHandle(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: Icon(
            Icons.menu,
            color: AppTheme.colorDarkest,
          ),
        ),
      ),
    );
  }

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,
      int newListIndex) async {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
    await saveGoals();
  }

  _onListReorder(int oldListIndex, int newListIndex) async {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
    await saveGoals();
  }

  Future<void> saveGoals() async {
    // this is a bit complex because the order has changed,
    // and the draglist does not have an easy way to retrieve
    // the new order.
    Goals goals = Goals();
    for (int i = 0; i < _contents.length; i++) {
      var sectionCard = _contents[i].header as GoalSectionCard;
      GoalSection goalSection = GoalSection();

      goalSection.id = sectionCard.section.id;
      goalSection.name = sectionCard.section.name;
      goalSection.order = i;

      for (int j = 0; j < _contents[i].children.length; j++) {
        var goalCard = _contents[i].children[j].child as GoalCard;
        goalSection.goals.add(goalCard.goal);
        goalSection.goals.last.order = j;
      }
      goals.goalSections.add(goalSection);
    }
    await Data.goals.set(widget.courseId, goals);
  }
}
