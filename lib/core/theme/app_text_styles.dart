import 'package:flutter/material.dart';

import 'app_dimensions.dart';

/// Typography helpers built on top of Material 3 [TextTheme].
abstract final class AppTextStyles {
  static TextStyle displayLarge(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge!;

  static TextStyle displayMedium(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium!;

  static TextStyle displaySmall(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall!;

  static TextStyle headlineLarge(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge!;

  static TextStyle headlineMedium(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!;

  static TextStyle headlineSmall(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!;

  static TextStyle titleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!;

  static TextStyle titleMedium(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!;

  static TextStyle titleSmall(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall!;

  static TextStyle bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!;

  static TextStyle bodyMedium(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;

  static TextStyle bodySmall(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!;

  static TextStyle labelLarge(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!;

  static TextStyle labelMedium(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium!;

  static TextStyle labelSmall(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall!;

  static TextStyle button(BuildContext context) => labelLarge(context).copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle sectionHeader(BuildContext context) =>
      titleMedium(context).copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      );

  static TextStyle caption(BuildContext context) => bodySmall(context).copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  /// Emphasized monetary values with tabular figures.
  static TextStyle money(BuildContext context, {Color? color}) {
    return titleMedium(context).copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle moneyLarge(BuildContext context, {Color? color}) {
    return headlineSmall(context).copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static BorderRadius borderRadiusSm = BorderRadius.circular(
    AppDimensions.borderRadiusSm,
  );

  static BorderRadius borderRadiusMd = BorderRadius.circular(
    AppDimensions.borderRadiusMd,
  );

  static BorderRadius borderRadiusLg = BorderRadius.circular(
    AppDimensions.borderRadiusLg,
  );
}
