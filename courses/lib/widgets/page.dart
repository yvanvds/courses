import 'package:courses/convienience/app_theme.dart';
import 'package:courses/widgets/app_drawer.dart';
import 'package:courses/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppPage extends StatelessWidget {
  final List<SingleChildWidget>? providers;
  final Widget Function(BuildContext context) builder;
  final String title;

  const AppPage(
      {Key? key, required this.title, this.providers, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return providers != null
        ? MultiProvider(
            providers: providers!,
            child: AppScaffold(
              key: key,
              builder: builder,
              title: title,
            ),
          )
        : AppScaffold(
            key: key,
            builder: builder,
            title: title,
          );
  }
}

class AppScaffold extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final String title;
  const AppScaffold({Key? key, required this.builder, required this.title})
      : super(key: key);

  @override
  AppScaffoldState createState() => AppScaffoldState();
}

class AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("images/logo.png"),
          opacity: 0.2,
          fit: BoxFit.contain,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.colorLight,
            AppTheme.colorDark,
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: AppTheme.colorDarkest,
            elevation: 5,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('images/logo.png'),
            ),
            title: Row(
              children: [
                Text('Courses', style: AppTheme.text.headline2),
                const SizedBox(
                  width: 120,
                ),
                Text(widget.title, style: AppTheme.text.subtitle1),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: AppButton(
                    icon: Icons.logout,
                    onPressed: () {
                      //Data.auth.signOut();
                    },
                  ),
                ),
              ],
            ),
          ),
          body: Row(
            children: [
              const AppDrawer(),
              Expanded(child: widget.builder(context)),
            ],
          )),
    );
  }
}
