import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// A standardized [Scaffold] with optional content constraints and padding.
class AppScaffold extends StatelessWidget {
  /// Creates an application scaffold.
  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.constrainBodyWidth = false,
    this.bodyPadding,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool constrainBodyWidth;
  final EdgeInsetsGeometry? bodyPadding;

  @override
  Widget build(BuildContext context) {
    Widget? content = body;
    if (content != null && bodyPadding != null) {
      content = Padding(padding: bodyPadding!, child: content);
    }
    if (content != null && constrainBodyWidth) {
      content = context.constrainContent(content);
    }

    return Scaffold(
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}
