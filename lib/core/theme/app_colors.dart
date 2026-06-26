import 'package:flutter/material.dart';

/// Semantic and brand colors used across the application.
abstract final class AppColors {
  static const Color seedColor = Color(0xFF1B6B4A);

  static const Color income = Color(0xFF2E7D32);
  static const Color expense = Color(0xFFC62828);
  static const Color savings = Color(0xFF1565C0);
  static const Color warning = Color(0xFFF9A825);
  static const Color success = Color(0xFF2E7D32);
  static const Color info = Color(0xFF1565C0);

  static Color shimmerBase(ColorScheme colorScheme) =>
      colorScheme.surfaceContainerHighest;

  static Color shimmerHighlight(ColorScheme colorScheme) =>
      colorScheme.surface;
}
