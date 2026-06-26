import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/app_spacing.dart';
import 'app_icon_button.dart';
import 'app_text.dart';

/// A pagination control with previous and next navigation.
class AppPaginationWidget extends StatelessWidget {
  /// Creates a pagination widget.
  const AppPaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
    this.showPageIndicator = true,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool showPageIndicator;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canGoPrevious = currentPage > 1;
    final canGoNext = currentPage < totalPages;

    return Semantics(
      container: true,
      label: l10n.widgetPageIndicator(currentPage, totalPages),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIconButton(
            icon: Icons.chevron_left,
            tooltip: l10n.widgetPreviousPage,
            onPressed: canGoPrevious ? onPrevious : null,
          ),
          if (showPageIndicator) ...[
            const SizedBox(width: AppSpacing.md),
            AppText(
              l10n.widgetPageIndicator(currentPage, totalPages),
              variant: AppTextVariant.labelLarge,
            ),
            const SizedBox(width: AppSpacing.md),
          ] else
            const SizedBox(width: AppSpacing.sm),
          AppIconButton(
            icon: Icons.chevron_right,
            tooltip: l10n.widgetNextPage,
            onPressed: canGoNext ? onNext : null,
          ),
        ],
      ),
    );
  }
}
