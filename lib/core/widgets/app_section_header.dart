import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'app_text.dart';

/// A section header with optional trailing action.
class AppSectionHeader extends StatelessWidget {
  /// Creates a section header.
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding,
    this.semanticsLabel,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: semanticsLabel ?? title,
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
            ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(title, variant: AppTextVariant.sectionHeader),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    AppText(
                      subtitle!,
                      variant: AppTextVariant.caption,
                    ),
                  ],
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
