import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

/// A standardized application [AppBar] aligned with Material 3 styling.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an application app bar.
  const AppAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
    this.automaticallyImplyLeading = true,
  });

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool? centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize => Size.fromHeight(
        AppDimensions.appBarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      elevation: elevation,
      scrolledUnderElevation: elevation ?? 0,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
      bottom: bottom,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}
