import 'package:courses/convienience/app_theme.dart';
import 'package:courses/widgets/cards/glass_card.dart';
import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function onPressed;

  const BigButton(
      {Key? key,
      required this.label,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: GlassCard(
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, size: 72, color: AppTheme.colorLightest),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(label, style: AppTheme.text.subtitle1),
            ),
          ],
        ),
      ),
    );
  }
}
