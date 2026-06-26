import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';

/// A theme-aware loading indicator with accessibility support.
class AppLoadingIndicator extends StatelessWidget {
  /// Creates a loading indicator.
  const AppLoadingIndicator({
    super.key,
    this.size = 32,
    this.strokeWidth = 3,
    this.color,
    this.semanticsLabel,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Semantics(
      label: semanticsLabel ?? l10n.widgetLoading,
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
