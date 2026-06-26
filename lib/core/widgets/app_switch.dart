import 'package:flutter/material.dart';

/// A theme-aware switch with optional label.
class AppSwitch extends StatelessWidget {
  /// Creates an application switch.
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.semanticsLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final switchWidget = Switch(
      value: value,
      onChanged: onChanged,
    );

    if (label == null) {
      return Semantics(
        label: semanticsLabel,
        toggled: value,
        child: switchWidget,
      );
    }

    return Semantics(
      label: semanticsLabel ?? label,
      toggled: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Text(label!)),
          switchWidget,
        ],
      ),
    );
  }
}
