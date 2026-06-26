import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// A theme-aware list tile with consistent spacing and tap handling.
class AppListTile extends StatelessWidget {
  /// Creates an application list tile.
  const AppListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.dense = false,
    this.contentPadding,
    this.semanticsLabel,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool selected;
  final bool dense;
  final EdgeInsetsGeometry? contentPadding;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: onTap != null,
      label: semanticsLabel,
      selected: selected,
      enabled: enabled,
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        enabled: enabled,
        selected: selected,
        dense: dense,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
        selectedTileColor: colorScheme.secondaryContainer.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
