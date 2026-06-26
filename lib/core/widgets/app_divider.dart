import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';

/// A theme-aware divider with consistent spacing.
class AppDivider extends StatelessWidget {
  /// Creates an application divider.
  const AppDivider({
    super.key,
    this.height = AppSpacing.lg,
    this.thickness = AppDimensions.dividerThickness,
    this.indent,
    this.endIndent,
    this.color,
  });

  final double height;
  final double thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
