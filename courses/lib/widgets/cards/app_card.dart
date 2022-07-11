import 'package:cached_network_image/cached_network_image.dart';
import 'package:courses/convienience/app_theme.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget title;
  final Widget content;
  final double width;
  final Color? color;
  final List<Color>? gradient;
  final bool maximize;
  final String? imageUri;

  const AppCard({
    Key? key,
    required this.title,
    required this.content,
    this.color,
    required this.width,
    this.gradient,
    this.imageUri,
    this.maximize = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16, bottom: 16),
      child: SizedBox(
          width: width,
          child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient ??
                        <Color>[AppTheme.colorDark, AppTheme.colorLight],
                  ),
                ),
                child: Column(
                  mainAxisSize: maximize ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    Container(
                      color: color ?? AppTheme.colorDarkest,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: title,
                      ),
                    ),
                    imageUri != null
                        ? SizedBox(
                            width: width,
                            height: width / 20 * 7,
                            child: CachedNetworkImage(
                              imageUrl: imageUri!,
                              fit: BoxFit.fill,
                              width: width,
                              height: width / 20 * 7,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          )
                        : Container(),
                    maximize
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: content,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: content,
                          ),
                  ],
                ),
              ))),
    );
  }
}
