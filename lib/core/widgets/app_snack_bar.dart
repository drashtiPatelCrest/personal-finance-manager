import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/app_spacing.dart';

/// Snackbar visual variants.
enum AppSnackBarVariant { info, success, warning, error }

/// Utility for displaying themed snack bars.
class AppSnackBar {
  AppSnackBar._();

  /// Shows a themed snack bar with the given [message].
  static void show({
    required BuildContext context,
    required String message,
    AppSnackBarVariant variant = AppSnackBarVariant.info,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final (background, foreground) = _resolveColors(colorScheme, variant);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: foreground)),
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppSpacing.lg),
          duration: duration,
          action: actionLabel == null
              ? null
              : SnackBarAction(
                  label: actionLabel,
                  textColor: foreground,
                  onPressed: onAction ?? () {},
                ),
          dismissDirection: DismissDirection.horizontal,
          showCloseIcon: actionLabel == null,
          closeIconColor: foreground,
        ),
      );
  }

  static (Color background, Color foreground) _resolveColors(
    ColorScheme colorScheme,
    AppSnackBarVariant variant,
  ) {
    return switch (variant) {
      AppSnackBarVariant.info => (
          colorScheme.inverseSurface,
          colorScheme.onInverseSurface,
        ),
      AppSnackBarVariant.success => (
          colorScheme.primaryContainer,
          colorScheme.onPrimaryContainer,
        ),
      AppSnackBarVariant.warning => (
          colorScheme.tertiaryContainer,
          colorScheme.onTertiaryContainer,
        ),
      AppSnackBarVariant.error => (
          colorScheme.errorContainer,
          colorScheme.onErrorContainer,
        ),
    };
  }

  /// Shows an info snack bar.
  static void info(BuildContext context, String message) {
    show(context: context, message: message);
  }

  /// Shows a success snack bar.
  static void success(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      variant: AppSnackBarVariant.success,
    );
  }

  /// Shows a warning snack bar.
  static void warning(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      variant: AppSnackBarVariant.warning,
    );
  }

  /// Shows an error snack bar with a localized dismiss action.
  static void error(
    BuildContext context,
    String message, {
    VoidCallback? onDismiss,
  }) {
    show(
      context: context,
      message: message,
      variant: AppSnackBarVariant.error,
      actionLabel: context.l10n.widgetDismiss,
      onAction: onDismiss,
    );
  }
}
