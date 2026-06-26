import 'package:flutter/material.dart';

/// Semantic and brand colors used across the application.
abstract final class AppColors {
  static const Color seedColor = Color(0xFF0D7C5F);
  static const Color seedColorDark = Color(0xFF2DD4A8);

  static const Color income = Color(0xFF16A34A);
  static const Color incomeDark = Color(0xFF4ADE80);
  static const Color expense = Color(0xFFDC2626);
  static const Color expenseDark = Color(0xFFF87171);
  static const Color savings = Color(0xFF2563EB);
  static const Color savingsDark = Color(0xFF60A5FA);
  static const Color warning = Color(0xFFD97706);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color success = Color(0xFF16A34A);
  static const Color info = Color(0xFF2563EB);

  static const Color lightSurface = Color(0xFFF8FAFC);
  static const Color darkSurface = Color(0xFF0F1419);

  static Color incomeFor(Brightness brightness) =>
      brightness == Brightness.dark ? incomeDark : income;

  static Color expenseFor(Brightness brightness) =>
      brightness == Brightness.dark ? expenseDark : expense;

  static Color savingsFor(Brightness brightness) =>
      brightness == Brightness.dark ? savingsDark : savings;

  static Color warningFor(Brightness brightness) =>
      brightness == Brightness.dark ? warningDark : warning;

  static Color shimmerBase(ColorScheme colorScheme) =>
      colorScheme.surfaceContainerHighest;

  static Color shimmerHighlight(ColorScheme colorScheme) =>
      colorScheme.surfaceContainerLow;
}
