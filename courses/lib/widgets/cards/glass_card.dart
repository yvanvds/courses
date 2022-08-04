import 'dart:ui';
import 'package:courses/convienience/app_theme.dart';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget content;
  final bool highlight;
  const GlassCard({Key? key, required this.content, this.highlight = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.colorDarkest.withOpacity(0.2),
              spreadRadius: 8,
              blurRadius: 40,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 24,
              sigmaY: 24,
            ),
            child: Container(
              decoration: BoxDecoration(
                color:
                    AppTheme.colorLightest.withOpacity(highlight ? 0.5 : 0.2),
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  width: 1.5,
                  color: AppTheme.colorLightest.withOpacity(0.2),
                ),
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
