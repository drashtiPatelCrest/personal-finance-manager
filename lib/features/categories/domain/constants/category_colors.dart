import 'package:flutter/material.dart';

/// Predefined category colors for selection.
abstract final class CategoryColors {
  static const List<Color> palette = [
    Color(0xFF1B6B4A),
    Color(0xFF2E7D32),
    Color(0xFF1565C0),
    Color(0xFFC62828),
    Color(0xFFF9A825),
    Color(0xFF6A1B9A),
    Color(0xFF00838F),
    Color(0xFFEF6C00),
    Color(0xFF5D4037),
    Color(0xFF455A64),
  ];

  static int encode(Color color) => color.toARGB32();

  static Color decode(int value) => Color(value);
}
