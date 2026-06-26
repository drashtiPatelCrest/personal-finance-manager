import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_dimensions.dart';

/// Utility for displaying modal bottom sheets.
class AppBottomSheet {
  AppBottomSheet._();

  /// Shows a themed modal bottom sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    bool isDismissible = true,
    bool enableDrag = true,
    String? semanticsLabel,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: true,
      constraints: BoxConstraints(
        maxWidth: context.isDesktop
            ? AppDimensions.bottomSheetMaxWidth
            : double.infinity,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusLg),
        ),
      ),
      builder: (context) {
        return Semantics(
          container: true,
          label: semanticsLabel,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
