import 'package:flutter/material.dart';

import '../constants/app_breakpoints.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';

/// Convenience extensions on [BuildContext] for theme and layout.
extension BuildContextX on BuildContext {
  ThemeData get appTheme => Theme.of(this);

  ColorScheme get colorScheme => appTheme.colorScheme;

  TextTheme get textTheme => appTheme.textTheme;

  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get viewPadding => MediaQuery.paddingOf(this);

  bool get isMobile => screenWidth < AppBreakpoints.mobile;

  bool get isTablet =>
      screenWidth >= AppBreakpoints.mobile &&
      screenWidth < AppBreakpoints.tablet;

  bool get isDesktop => screenWidth >= AppBreakpoints.tablet;

  /// Centers content and constrains width for large screens.
  Widget constrainContent(Widget child) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
        child: child,
      ),
    );
  }

  /// Standard horizontal padding that adapts to screen size.
  EdgeInsets get horizontalPagePadding {
    if (isDesktop) {
      return const EdgeInsets.symmetric(horizontal: AppSpacing.xxl);
    }
    if (isTablet) {
      return const EdgeInsets.symmetric(horizontal: AppSpacing.xl);
    }
    return const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
  }
}
