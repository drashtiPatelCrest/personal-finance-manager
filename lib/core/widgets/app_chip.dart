import 'package:flutter/material.dart';

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
  });

  final String label;
  final VoidCallback? onDeleted;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? avatar;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    if (onDeleted != null) {
      return Semantics(
        label: semanticsLabel ?? label,
        child: InputChip(
          label: Text(label),
          avatar: avatar,
          selected: selected,
          onPressed: onTap,
          onDeleted: onDeleted,
        ),
      );
    }

    return Semantics(
      label: semanticsLabel ?? label,
      selected: selected,
      button: onTap != null,
      child: FilterChip(
        label: Text(label),
        avatar: avatar,
        selected: selected,
        onSelected: onTap == null ? null : (_) => onTap!(),
      ),
    );
  }
}
