import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import 'app_card.dart';
import 'app_fade_in.dart';
import 'app_text.dart';

/// Shared chrome for chart widgets with title, optional subtitle, and content.
class AppChartContainer extends StatelessWidget {
  const AppChartContainer({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.footer,
    this.emptyMessage,
    this.isEmpty = false,
    this.animate = true,
    this.wrapContent = false,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;
  final String? emptyMessage;
  final bool isEmpty;
  final bool animate;

  /// When true, the child defines its own height instead of using [chartHeight].
  final bool wrapContent;

  @override
  Widget build(BuildContext context) {
    final content = AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText(title, variant: AppTextVariant.titleSmall),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            AppText(subtitle!, variant: AppTextVariant.caption),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (wrapContent)
            isEmpty && emptyMessage != null
                ? SizedBox(
                    height: AppDimensions.chartHeight,
                    child: Center(
                      child: AppText(
                        emptyMessage!,
                        variant: AppTextVariant.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : child
          else
            SizedBox(
              height: AppDimensions.chartHeight,
              child: isEmpty && emptyMessage != null
                  ? Center(
                      child: AppText(
                        emptyMessage!,
                        variant: AppTextVariant.caption,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : child,
            ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.md),
            footer!,
          ],
        ],
      ),
    );

    if (!animate) {
      return content;
    }

    return AppFadeIn(child: content);
  }
}
