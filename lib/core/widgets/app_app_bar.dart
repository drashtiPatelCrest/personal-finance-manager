import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import 'app_text.dart';

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
    this.subtitle,
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
  final String? subtitle;

  @override
  Size get preferredSize => Size.fromHeight(
        AppDimensions.appBarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedTitle = subtitle == null
        ? title
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              title,
              AppText(subtitle!, variant: AppTextVariant.caption),
            ],
          );

    return AppBar(
      title: resolvedTitle,
      leading: leading,
      actions: [
        if (actions != null) ...actions!,
        const SizedBox(width: AppSpacing.sm),
      ],
      centerTitle: centerTitle,
      elevation: elevation,
      scrolledUnderElevation: elevation ?? 0,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      bottom: bottom,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}
