import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.light,
      surface: AppColors.lightSurface,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seedColorDark,
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final borderRadius = BorderRadius.circular(AppDimensions.borderRadiusMd);
    final buttonShape = RoundedRectangleBorder(borderRadius: borderRadius);
    final textTheme = _buildTextTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: const FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: const FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: const FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimensions.appBarHeight,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        ),
        minVerticalPadding: AppSpacing.sm,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: borderRadius),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.buttonHeightMd),
          elevation: 0,
          shape: buttonShape,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.buttonHeightMd),
          shape: buttonShape,
          side: BorderSide(color: colorScheme.outlineVariant),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.buttonHeightMd),
          shape: buttonShape,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppDimensions.elevationMd,
        highlightElevation: AppDimensions.elevationLg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusFull),
        ),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        labelStyle: textTheme.labelLarge,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        thickness: AppDimensions.dividerThickness,
        space: AppDimensions.dividerThickness,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: AppDimensions.elevationMd,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        ),
      ),
      dialogTheme: DialogThemeData(
        elevation: AppDimensions.elevationLg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: AppDimensions.elevationLg,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.borderRadiusXl),
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusFull),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: colorScheme.primaryContainer,
      ),
      iconTheme: IconThemeData(
        size: AppDimensions.iconSizeMd,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    final base = Typography.material2021().black;
    final isDark = colorScheme.brightness == Brightness.dark;
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;

    TextStyle withTabular(TextStyle? style) => (style ?? const TextStyle())
        .copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
          color: style?.color ?? onSurface,
        );

    return TextTheme(
      displayLarge: withTabular(base.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -1.2,
        color: onSurface,
      )),
      displayMedium: withTabular(base.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: onSurface,
      )),
      displaySmall: withTabular(base.displaySmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: onSurface,
      )),
      headlineLarge: withTabular(base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: onSurface,
      )),
      headlineMedium: withTabular(base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: onSurface,
      )),
      headlineSmall: withTabular(base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      )),
      titleLarge: withTabular(base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: onSurface,
      )),
      titleMedium: withTabular(base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      )),
      titleSmall: withTabular(base.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      )),
      bodyLarge: withTabular(base.bodyLarge?.copyWith(
        height: 1.5,
        color: onSurface,
      )),
      bodyMedium: withTabular(base.bodyMedium?.copyWith(
        height: 1.45,
        color: onSurface,
      )),
      bodySmall: withTabular(base.bodySmall?.copyWith(
        height: 1.4,
        color: onSurfaceVariant,
      )),
      labelLarge: withTabular(base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onSurface,
      )),
      labelMedium: withTabular(base.labelMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: onSurfaceVariant,
      )),
      labelSmall: withTabular(base.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: onSurfaceVariant,
      )),
    ).apply(
      bodyColor: isDark ? onSurface : onSurface,
      displayColor: onSurface,
    );
  }
}
