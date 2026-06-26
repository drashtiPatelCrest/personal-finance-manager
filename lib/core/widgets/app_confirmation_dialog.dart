import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';
import 'app_outlined_button.dart';
import 'app_text.dart';

/// A confirmation dialog with localized default actions.
class AppConfirmationDialog extends StatelessWidget {
  /// Creates a confirmation dialog.
  const AppConfirmationDialog({
    super.key,
    this.title,
    this.message,
    this.confirmLabel,
    this.cancelLabel,
    this.onConfirm,
    this.isDestructive = false,
  });

  final String? title;
  final String? message;
  final String? confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final bool isDestructive;

  /// Shows a confirmation dialog and returns `true` when confirmed.
  static Future<bool> show({
    required BuildContext context,
    String? title,
    String? message,
    String? confirmLabel,
    String? cancelLabel,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resolvedTitle = title ?? l10n.widgetConfirmationTitle;
    final resolvedMessage = message ?? l10n.widgetConfirmationMessage;
    final resolvedConfirm = confirmLabel ?? l10n.widgetActionConfirm;
    final resolvedCancel = cancelLabel ?? l10n.widgetActionCancel;

    return AlertDialog(
      title: AppText(resolvedTitle, variant: AppTextVariant.titleLarge),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimensions.dialogMaxWidth,
        ),
        child: AppText(resolvedMessage, variant: AppTextVariant.bodyMedium),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      actions: [
        AppOutlinedButton(
          label: resolvedCancel,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: resolvedConfirm,
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          variant: isDestructive
              ? AppButtonVariant.filled
              : AppButtonVariant.filled,
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
      ),
    );
  }
}
