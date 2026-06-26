import 'package:flutter/material.dart';

/// A theme-aware radio button with optional label.
///
/// Uses [RadioListTile] for improved accessibility and tap targets.
class AppRadioButton<T> extends StatelessWidget {
  /// Creates an application radio button.
  const AppRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.semanticsLabel,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Semantics(
        label: semanticsLabel,
        checked: value == groupValue,
        child: RadioListTile<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          contentPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: VisualDensity.compact,
          title: const SizedBox.shrink(),
        ),
      );
    }

    return Semantics(
      label: semanticsLabel ?? label,
      checked: value == groupValue,
      child: RadioListTile<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
        title: Text(label!),
      ),
    );
  }
}
