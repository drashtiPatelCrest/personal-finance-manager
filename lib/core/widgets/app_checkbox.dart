import 'package:flutter/material.dart';

/// A theme-aware checkbox with optional label.
class AppCheckbox extends StatelessWidget {
  /// Creates an application checkbox.
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.tristate = false,
    this.semanticsLabel,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final bool tristate;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final checkbox = Checkbox(
      value: value,
      onChanged: onChanged,
      tristate: tristate,
    );

    if (label == null) {
      return Semantics(
        label: semanticsLabel,
        checked: value == true,
        child: checkbox,
      );
    }

    return Semantics(
      label: semanticsLabel ?? label,
      checked: value == true,
      child: InkWell(
        onTap: onChanged == null
            ? null
            : () => onChanged!(value == true ? false : true),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkbox,
            const SizedBox(width: 8),
            Flexible(child: Text(label!)),
          ],
        ),
      ),
    );
  }
}
