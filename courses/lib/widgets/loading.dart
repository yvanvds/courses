import 'package:courses/convienience/app_theme.dart';
import 'package:courses/widgets/cards/glass_card.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<Color?>? _tweenColor;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _tweenColor = _animationController.drive(
      ColorTween(
        begin: AppTheme.colorLight,
        end: AppTheme.colorAccent,
      ),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 500,
            height: 500,
            child: GlassCard(
              content: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: CircularProgressIndicator(
                            valueColor: _tweenColor,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(
                          'wacht even ...',
                          textAlign: TextAlign.center,
                          style: AppTheme.text.headline1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
