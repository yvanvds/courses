import 'package:courses/convienience/app_theme.dart';
import 'package:courses/data/data.dart';
import 'package:courses/data/models/content/content_factory.dart';
import 'package:courses/data/models/topic.dart';
import 'package:courses/pages/course/content/viewer_factory.dart';
import 'package:courses/widgets/footer.dart';
import 'package:courses/widgets/loading.dart';
import 'package:courses/widgets/page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ViewerPageLoader extends StatelessWidget {
  final String courseID;
  final String topicID;
  const ViewerPageLoader(
      {Key? key, required this.courseID, required this.topicID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Topic?>(
      create: (_) => Data.topics.getSingle(courseID, topicID),
      initialData: null,
      builder: (context, widget) {
        Topic? topic = Provider.of<Topic?>(context);
        if (topic == null) return const Loading();
        return ViewerPage(
          courseID: courseID,
          topic: topic,
        );
      },
    );
  }
}

class ViewerPage extends StatefulWidget {
  final String courseID;
  final Topic topic;
  const ViewerPage({Key? key, required this.courseID, required this.topic})
      : super(key: key);

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  List<IContent>? content;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: widget.topic.name,
      providers: [
        StreamProvider<List<IContent>?>(
          create: (_) => Data.content.getAll(widget.courseID, widget.topic.id),
          initialData: null,
        ),
      ],
      builder: (BuildContext context) {
        content = Provider.of<List<IContent>?>(context);

        if (content == null) return const Loading();

        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.maxFinite,
              child: Card(
                color: AppTheme.colorDarkest,
                child: ViewerFactory.create(content![index]),
              ),
            ),
          ),
        ),
        NavigationFooter(
          index: index,
          length: widget.topic.contents.length,
          onIndexChange: (newIndex) {
            if (newIndex == -1) {
              context.pop();
            } else {
              setState(() {
                index = newIndex;
              });
            }
          },
        ),
      ],
    );
  }
}
