import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

/// A theme-aware chip for tags, filters, and selections.
class AppChip extends StatelessWidget {
  /// Creates an application chip.
  const AppChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.onTap,
    this.selected = false,
    this.avatar,
    this.semanticsLabel,
    this.icon,
  });

  final String label;
  final VoidCallback? onDeleted;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? avatar;
  final String? semanticsLabel;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final leading = avatar ??
        (icon != null
            ? Icon(
                icon,
                size: AppDimensions.iconSizeSm,
                color: selected ? colorScheme.onPrimaryContainer : null,
              )
            : null);

    if (onDeleted != null) {
      return Semantics(
        label: semanticsLabel ?? label,
        child: InputChip(
          label: Text(label),
          avatar: leading,
          selected: selected,
          onPressed: onTap,
          onDeleted: onDeleted,
          selectedColor: colorScheme.primaryContainer,
          checkmarkColor: colorScheme.onPrimaryContainer,
          labelStyle: TextStyle(
            color: selected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      );
    }

    return Semantics(
      label: semanticsLabel ?? label,
      selected: selected,
      button: onTap != null,
      child: FilterChip(
        label: Text(label),
        avatar: leading,
        selected: selected,
        showCheckmark: false,
        onSelected: onTap == null ? null : (_) => onTap!(),
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: selected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurface,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
