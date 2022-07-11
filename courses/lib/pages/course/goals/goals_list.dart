import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/goals.dart';
import 'package:courses/data/models/periods.dart';
import 'package:courses/pages/course/goals/goal_editor.dart';
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
      _contents.add(
        DragAndDropList(
          header: SectionCard(
            courseID: widget.courseId,
            goals: widget.goals,
            periods: widget.periods,
            index: i,
          ),
          children: List.generate(
            widget.goals.goalSections[i].goals.length,
            (index) {
              return DragAndDropItem(
                child: GoalCard(
                    courseID: widget.courseId,
                    goalIndex: index,
                    sectionIndex: i,
                    goals: widget.goals,
                    periods: widget.periods),
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

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }
}

class SectionCard extends StatefulWidget {
  final String courseID;
  final Goals goals;
  final int index;
  final Periods periods;

  const SectionCard(
      {Key? key,
      required this.courseID,
      required this.index,
      required this.goals,
      required this.periods})
      : super(key: key);

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              widget.goals.goalSections[widget.index].name,
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
              await openSectionEditor(widget.goals.goalSections[widget.index]);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: AppTheme.colorLightest,
            ),
            onPressed: () async {
              await openGoalEditor();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: AppTheme.colorWarning,
            ),
            onPressed: () async {
              widget.goals.goalSections.removeAt(widget.index);
              await Data.goals.set(widget.courseID, widget.goals);
            },
          ),
          const SizedBox(width: 50),
        ],
      )
    ]);
  }

  Future<void> openSectionEditor(GoalSection goalSection) async {
    GoalSection? result = await showDialog(
      context: context,
      builder: (_) {
        return GoalSectionEditor(goalSection: goalSection);
      },
    );
    if (result != null) {
      widget.goals.goalSections[widget.index] = result;
      await Data.goals.set(widget.courseID, widget.goals);
    }
  }

  Future<void> openGoalEditor() async {
    Goal? result = await showDialog(
      context: context,
      builder: (_) {
        return GoalEditor(periods: widget.periods);
      },
    );
    if (result != null) {
      widget.goals.goalSections[widget.index].goals.add(result);
      await Data.goals.set(widget.courseID, widget.goals);
    }
  }
}

class GoalCard extends StatefulWidget {
  final String courseID;
  final Goals goals;
  final int goalIndex;
  final int sectionIndex;
  final Periods periods;

  const GoalCard(
      {Key? key,
      required this.courseID,
      required this.goalIndex,
      required this.sectionIndex,
      required this.goals,
      required this.periods})
      : super(key: key);

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
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Text(
              widget.goals.goalSections[widget.sectionIndex]
                  .goals[widget.goalIndex].name,
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
              await openGoalEditor(widget.goals
                  .goalSections[widget.sectionIndex].goals[widget.goalIndex]);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: AppTheme.colorWarning,
            ),
            onPressed: () async {
              widget.goals.goalSections[widget.sectionIndex].goals
                  .removeAt(widget.goalIndex);
              await Data.goals.set(widget.courseID, widget.goals);
            },
          ),
          const SizedBox(width: 50),
        ],
      )
    ]);
  }

  Future<void> openGoalEditor(Goal goal) async {
    Goal? result = await showDialog(
      context: context,
      builder: (_) {
        return GoalEditor(
          goal: goal,
          periods: widget.periods,
        );
      },
    );
    if (result != null) {
      widget.goals.goalSections[widget.sectionIndex].goals[widget.goalIndex] =
          result;
      await Data.goals.set(widget.courseID, widget.goals);
    }
  }
}
