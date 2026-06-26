import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import 'app_text.dart';

/// Utility for displaying application dialogs.
class AppDialog {
  AppDialog._();

  /// Shows a customizable application dialog.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          title: AppText(title, variant: AppTextVariant.titleLarge),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.dialogMaxWidth,
            ),
            child: content,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          actions: actions,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
          ),
        );
      },
    );
  }
}
