import 'package:flutter/material.dart';

/// Typography variants mapped to the application text theme.
enum AppTextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
  button,
  sectionHeader,
  caption,
}

/// A theme-aware text widget with consistent typography variants.
class AppText extends StatelessWidget {
  /// Creates themed application text.
  const AppText(
    this.data, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.fontWeight,
  });

  final String data;
  final AppTextVariant variant;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticsLabel;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final baseStyle = _resolveStyle(context);
    final resolvedStyle = baseStyle.copyWith(
      color: color ?? baseStyle.color,
      fontWeight: fontWeight ?? baseStyle.fontWeight,
    );

    return Semantics(
      label: semanticsLabel,
      child: Text(
        data,
        style: style ?? resolvedStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  TextStyle _resolveStyle(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return switch (variant) {
      AppTextVariant.displayLarge => theme.displayLarge!,
      AppTextVariant.displayMedium => theme.displayMedium!,
      AppTextVariant.displaySmall => theme.displaySmall!,
      AppTextVariant.headlineLarge => theme.headlineLarge!,
      AppTextVariant.headlineMedium => theme.headlineMedium!,
      AppTextVariant.headlineSmall => theme.headlineSmall!,
      AppTextVariant.titleLarge => theme.titleLarge!,
      AppTextVariant.titleMedium => theme.titleMedium!,
      AppTextVariant.titleSmall => theme.titleSmall!,
      AppTextVariant.bodyLarge => theme.bodyLarge!,
      AppTextVariant.bodyMedium => theme.bodyMedium!,
      AppTextVariant.bodySmall => theme.bodySmall!,
      AppTextVariant.labelLarge => theme.labelLarge!,
      AppTextVariant.labelMedium => theme.labelMedium!,
      AppTextVariant.labelSmall => theme.labelSmall!,
      AppTextVariant.button => theme.labelLarge!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      AppTextVariant.sectionHeader => theme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      AppTextVariant.caption => theme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
    };
  }
}
