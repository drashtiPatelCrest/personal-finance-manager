import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';

/// Shared layout for authentication screens with responsive centering.
class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return AppScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: context.horizontalPagePadding.copyWith(
              top: AppSpacing.xxl,
              bottom: AppSpacing.xxl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.dialogMaxWidth,
              ),
              child: AppFadeIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      margin: const EdgeInsets.only(bottom: AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.borderRadiusLg),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: colorScheme.onPrimaryContainer,
                        size: AppDimensions.iconSizeLg,
                      ),
                    ),
                    AppText(
                      title,
                      variant: AppTextVariant.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      subtitle,
                      variant: AppTextVariant.bodyMedium,
                      color: colorScheme.onSurfaceVariant,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: child,
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
