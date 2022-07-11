import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/periods.dart';
import 'package:courses/pages/course/goals/periods_editor.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:courses/widgets/cards/app_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeriodsWidget extends StatefulWidget {
  final Periods? periods;
  final String courseID;
  const PeriodsWidget({Key? key, required this.courseID, this.periods})
      : super(key: key);

  @override
  State<PeriodsWidget> createState() => _PeriodsWidgetState();
}

class _PeriodsWidgetState extends State<PeriodsWidget> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 400,
      maximize: true,
      title: Row(
        children: [
          Text('Periodes', style: AppTheme.text.subtitle1),
          const Spacer(),
          AppButton(
            icon: Icons.add_circle,
            text: 'Nieuw',
            onPressed: () async {
              Period? result = await showDialog(
                context: context,
                builder: (_) {
                  return const PeriodsEditor();
                },
              );
              if (result != null) {
                Periods periods = Periods();
                if (widget.periods != null) {
                  periods.periods.addAll(widget.periods!.periods);
                }
                periods.periods.add(result);
                await Data.periods.set(widget.courseID, periods);
              }
            },
          ),
        ],
      ),
      content: widget.periods != null
          ? ListView.builder(
              itemCount: widget.periods?.periods.length,
              itemBuilder: (context, index) {
                return createPeriodCard(index);
              },
            )
          : Container(),
    );
  }

  Card createPeriodCard(int index) {
    return Card(
      color: AppTheme.colorDarkest,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.periods!.periods[index].name,
                  style: AppTheme.text.subtitle1,
                ),
                Text(
                  DateFormat.yMd().format(widget.periods!.periods[index].date),
                  style: AppTheme.text.bodyText2,
                ),
              ],
            ),
            const Spacer(),
            AppButton(
              icon: Icons.edit,
              onPressed: () async {
                Period? result = await showDialog(
                  context: context,
                  builder: (_) {
                    return PeriodsEditor(
                        period: widget.periods!.periods[index]);
                  },
                );
                if (result != null) {
                  widget.periods!.periods[index] = result;
                  Data.periods.set(widget.courseID, widget.periods!);
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: AppButton(
                color: AppTheme.colorWarning,
                onPressed: () async {
                  widget.periods!.periods.removeAt(index);
                  Data.periods.set(widget.courseID, widget.periods!);
                },
                icon: Icons.delete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
