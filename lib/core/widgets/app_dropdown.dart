import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

/// A theme-aware dropdown field for selecting a value of type [T].
class AppDropdown<T> extends StatelessWidget {
  /// Creates an application dropdown.
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.isExpanded = true,
    this.semanticsLabel,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool isExpanded;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? label ?? hint,
      child: DropdownButtonFormField<T>(
        key: ValueKey<T?>(value),
        initialValue: value,
        items: items,
        onChanged: enabled ? onChanged : null,
        isExpanded: isExpanded,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: helperText,
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          ),
        ),
      ),
    );
  }
}
