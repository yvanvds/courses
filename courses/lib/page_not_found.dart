import 'package:courses/widgets/page.dart';
import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  final String text;

  const PageNotFound({Key? key, this.text = 'Content Not Found'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Not Found',
      builder: (BuildContext context) {
        return Text(text);
      },
    );
  }
}
