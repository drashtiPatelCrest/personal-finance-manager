import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Builds different layouts based on the current screen size.
class AppResponsiveBuilder extends StatelessWidget {
  /// Creates a responsive layout builder.
  const AppResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return desktop ?? tablet ?? mobile;
    }
    if (context.isTablet) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}
